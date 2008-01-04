/*****************************************************************************
 * vlc_block_helper.h: Helper functions for data blocks management.
 *****************************************************************************
 * Copyright (C) 2003 the VideoLAN team
 * $Id: vlc_block_helper.h 11664 2005-07-09 06:17:09Z courmisch $
 *
 * Authors: Gildas Bazin <gbazin@netcourrier.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111, USA.
 *****************************************************************************/

#ifndef _VLC_BLOCK_HELPER_H
#define _VLC_BLOCK_HELPER_H 1

typedef struct block_bytestream_t
{
    block_t             *p_chain;
    block_t             *p_block;
    int                 i_offset;

} block_bytestream_t;

#define block_BytestreamInit( a ) __block_BytestreamInit( VLC_OBJECT(a) )

/*****************************************************************************
 * block_bytestream_t management
 *****************************************************************************/
static inline block_bytestream_t __block_BytestreamInit( vlc_object_t *p_obj )
{
    block_bytestream_t bytestream;

    bytestream.i_offset = 0;
    bytestream.p_chain = bytestream.p_block = NULL;

    return bytestream;
}

static inline void block_BytestreamRelease( block_bytestream_t *p_bytestream )
{
    while( p_bytestream->p_chain )
    {
        block_t *p_next;
        p_next = p_bytestream->p_chain->p_next;
        p_bytestream->p_chain->pf_release( p_bytestream->p_chain );
        p_bytestream->p_chain = p_next;
    }
    p_bytestream->i_offset = 0;
    p_bytestream->p_chain = p_bytestream->p_block = NULL;
}

static inline void block_BytestreamFlush( block_bytestream_t *p_bytestream )
{
    while( p_bytestream->p_chain != p_bytestream->p_block )
    {
        block_t *p_next;
        p_next = p_bytestream->p_chain->p_next;
        p_bytestream->p_chain->pf_release( p_bytestream->p_chain );
        p_bytestream->p_chain = p_next;
    }
    while( p_bytestream->p_block &&
           (p_bytestream->p_block->i_buffer - p_bytestream->i_offset) == 0 )
    {
        block_t *p_next;
        p_next = p_bytestream->p_chain->p_next;
        p_bytestream->p_chain->pf_release( p_bytestream->p_chain );
        p_bytestream->p_chain = p_bytestream->p_block = p_next;
        p_bytestream->i_offset = 0;
    }
}

static inline void block_BytestreamPush( block_bytestream_t *p_bytestream,
                                         block_t *p_block )
{
    block_ChainAppend( &p_bytestream->p_chain, p_block );
    if( !p_bytestream->p_block ) p_bytestream->p_block = p_block;
}

static inline block_t *block_BytestreamPop( block_bytestream_t *p_bytestream )
{
    block_t *p_block;

    block_BytestreamFlush( p_bytestream );

    p_block = p_bytestream->p_block;
    if( p_block == NULL )
    {
        return NULL;
    }
    else if( !p_block->p_next )
    {
        p_block->p_buffer += p_bytestream->i_offset;
        p_block->i_buffer -= p_bytestream->i_offset;
        p_bytestream->i_offset = 0;
        p_bytestream->p_chain = p_bytestream->p_block = NULL;
        return p_block;
    }

    while( p_block->p_next && p_block->p_next->p_next )
        p_block = p_block->p_next;

    {
        block_t *p_block_old = p_block;
        p_block = p_block->p_next;
        p_block_old->p_next = NULL;
    }

    return p_block;
}

static inline int block_SkipByte( block_bytestream_t *p_bytestream )
{
    /* Most common case first */
    if( p_bytestream->p_block->i_buffer - p_bytestream->i_offset )
    {
        p_bytestream->i_offset++;
        return VLC_SUCCESS;
    }
    else
    {
        block_t *p_block;

        /* Less common case which is also slower */
        for( p_block = p_bytestream->p_block->p_next;
             p_block != NULL; p_block = p_block->p_next )
        {
            if( p_block->i_buffer )
            {
                p_bytestream->i_offset = 1;
                p_bytestream->p_block = p_block;
                return VLC_SUCCESS;
            }
        }
    }

    /* Not enough data, bail out */
    return VLC_EGENERIC;
}

static inline int block_PeekByte( block_bytestream_t *p_bytestream,
                                  uint8_t *p_data )
{
    /* Most common case first */
    if( p_bytestream->p_block->i_buffer - p_bytestream->i_offset )
    {
        *p_data = p_bytestream->p_block->p_buffer[p_bytestream->i_offset];
        return VLC_SUCCESS;
    }
    else
    {
        block_t *p_block;

        /* Less common case which is also slower */
        for( p_block = p_bytestream->p_block->p_next;
             p_block != NULL; p_block = p_block->p_next )
        {
            if( p_block->i_buffer )
            {
                *p_data = p_block->p_buffer[0];
                return VLC_SUCCESS;
            }
        }
    }

    /* Not enough data, bail out */
    return VLC_EGENERIC;
}

static inline int block_GetByte( block_bytestream_t *p_bytestream,
                                 uint8_t *p_data )
{
    /* Most common case first */
    if( p_bytestream->p_block->i_buffer - p_bytestream->i_offset )
    {
        *p_data = p_bytestream->p_block->p_buffer[p_bytestream->i_offset];
        p_bytestream->i_offset++;
        return VLC_SUCCESS;
    }
    else
    {
        block_t *p_block;

        /* Less common case which is also slower */
        for( p_block = p_bytestream->p_block->p_next;
             p_block != NULL; p_block = p_block->p_next )
        {
            if( p_block->i_buffer )
            {
                *p_data = p_block->p_buffer[0];
                p_bytestream->i_offset = 1;
                p_bytestream->p_block = p_block;
                return VLC_SUCCESS;
            }
        }
    }

    /* Not enough data, bail out */
    return VLC_EGENERIC;
}

static inline int block_WaitBytes( block_bytestream_t *p_bytestream,
                                   int i_data )
{
    block_t *p_block;
    int i_offset, i_copy, i_size;

    /* Check we have that much data */
    i_offset = p_bytestream->i_offset;
    i_size = i_data;
    i_copy = 0;
    for( p_block = p_bytestream->p_block;
         p_block != NULL; p_block = p_block->p_next )
    {
        i_copy = __MIN( i_size, p_block->i_buffer - i_offset );
        i_size -= i_copy;
        i_offset = 0;

        if( !i_size ) break;
    }

    if( i_size )
    {
        /* Not enough data, bail out */
        return VLC_EGENERIC;
    }
    return VLC_SUCCESS;
}

static inline int block_SkipBytes( block_bytestream_t *p_bytestream,
                                   int i_data )
{
    block_t *p_block;
    int i_offset, i_copy;

    /* Check we have that much data */
    i_offset = p_bytestream->i_offset;
    i_copy = 0;
    for( p_block = p_bytestream->p_block;
         p_block != NULL; p_block = p_block->p_next )
    {
        i_copy = __MIN( i_data, p_block->i_buffer - i_offset );
        i_data -= i_copy;

        if( !i_data ) break;

        i_offset = 0;
    }

    if( i_data )
    {
        /* Not enough data, bail out */
        return VLC_EGENERIC;
    }

    p_bytestream->p_block = p_block;
    p_bytestream->i_offset = i_offset + i_copy;
    return VLC_SUCCESS;
}

static inline int block_PeekBytes( block_bytestream_t *p_bytestream,
                                   uint8_t *p_data, int i_data )
{
    block_t *p_block;
    int i_offset, i_copy, i_size;

    /* Check we have that much data */
    i_offset = p_bytestream->i_offset;
    i_size = i_data;
    i_copy = 0;
    for( p_block = p_bytestream->p_block;
         p_block != NULL; p_block = p_block->p_next )
    {
        i_copy = __MIN( i_size, p_block->i_buffer - i_offset );
        i_size -= i_copy;
        i_offset = 0;

        if( !i_size ) break;
    }

    if( i_size )
    {
        /* Not enough data, bail out */
        return VLC_EGENERIC;
    }

    /* Copy the data */
    i_offset = p_bytestream->i_offset;
    i_size = i_data;
    i_copy = 0;
    for( p_block = p_bytestream->p_block;
         p_block != NULL; p_block = p_block->p_next )
    {
        i_copy = __MIN( i_size, p_block->i_buffer - i_offset );
        i_size -= i_copy;

        if( i_copy )
        {
            memcpy( p_data, p_block->p_buffer + i_offset, i_copy );
            p_data += i_copy;
        }

        i_offset = 0;

        if( !i_size ) break;
    }

    return VLC_SUCCESS;
}

static inline int block_GetBytes( block_bytestream_t *p_bytestream,
                                  uint8_t *p_data, int i_data )
{
    block_t *p_block;
    int i_offset, i_copy, i_size;

    /* Check we have that much data */
    i_offset = p_bytestream->i_offset;
    i_size = i_data;
    i_copy = 0;
    for( p_block = p_bytestream->p_block;
         p_block != NULL; p_block = p_block->p_next )
    {
        i_copy = __MIN( i_size, p_block->i_buffer - i_offset );
        i_size -= i_copy;
        i_offset = 0;

        if( !i_size ) break;
    }

    if( i_size )
    {
        /* Not enough data, bail out */
        return VLC_EGENERIC;
    }

    /* Copy the data */
    i_offset = p_bytestream->i_offset;
    i_size = i_data;
    i_copy = 0;
    for( p_block = p_bytestream->p_block;
         p_block != NULL; p_block = p_block->p_next )
    {
        i_copy = __MIN( i_size, p_block->i_buffer - i_offset );
        i_size -= i_copy;

        if( i_copy )
        {
            memcpy( p_data, p_block->p_buffer + i_offset, i_copy );
            p_data += i_copy;
        }

        if( !i_size ) break;

        i_offset = 0;
    }

    /* No buffer given, just skip the data */
    p_bytestream->p_block = p_block;
    p_bytestream->i_offset = i_offset + i_copy;

    return VLC_SUCCESS;
}

static inline int block_PeekOffsetBytes( block_bytestream_t *p_bytestream,
    int i_peek_offset, uint8_t *p_data, int i_data )
{
    block_t *p_block;
    int i_offset, i_copy, i_size;

    /* Check we have that much data */
    i_offset = p_bytestream->i_offset;
    i_size = i_data + i_peek_offset;
    i_copy = 0;
    for( p_block = p_bytestream->p_block;
         p_block != NULL; p_block = p_block->p_next )
    {
        i_copy = __MIN( i_size, p_block->i_buffer - i_offset );
        i_size -= i_copy;
        i_offset = 0;

        if( !i_size ) break;
    }

    if( i_size )
    {
        /* Not enough data, bail out */
        return VLC_EGENERIC;
    }

    /* Find the right place */
    i_offset = p_bytestream->i_offset;
    i_size = i_peek_offset;
    i_copy = 0;
    for( p_block = p_bytestream->p_block;
         p_block != NULL; p_block = p_block->p_next )
    {
        i_copy = __MIN( i_size, p_block->i_buffer - i_offset );
        i_size -= i_copy;

        if( !i_size ) break;

        i_offset = 0;
    }

    /* Copy the data */
    i_offset += i_copy;
    i_size = i_data;
    i_copy = 0;
    for( ; p_block != NULL; p_block = p_block->p_next )
    {
        i_copy = __MIN( i_size, p_block->i_buffer - i_offset );
        i_size -= i_copy;

        if( i_copy )
        {
            memcpy( p_data, p_block->p_buffer + i_offset, i_copy );
            p_data += i_copy;
        }

        i_offset = 0;

        if( !i_size ) break;
    }

    return VLC_SUCCESS;
}

static inline int block_FindStartcodeFromOffset(
    block_bytestream_t *p_bytestream, int *pi_offset,
    uint8_t *p_startcode, int i_startcode_length )
{
    block_t *p_block, *p_block_backup = 0;
    int i_size, i_offset, i_offset_backup = 0;
    int i_caller_offset_backup = 0, i_match;

    /* Find the right place */
    i_size = *pi_offset + p_bytestream->i_offset;
    for( p_block = p_bytestream->p_block;
         p_block != NULL; p_block = p_block->p_next )
    {
        i_size -= p_block->i_buffer;
        if( i_size < 0 ) break;
    }

    if( i_size >= 0 )
    {
        /* Not enough data, bail out */
        return VLC_EGENERIC;
    }

    /* Begin the search.
     * We first look for an occurrence of the 1st startcode byte and
     * if found, we do a more thorough check. */
    i_size = p_block->i_buffer + i_size;
    *pi_offset -= i_size;
    i_match = 0;
    for( ; p_block != NULL; p_block = p_block->p_next )
    {
        for( i_offset = i_size; i_offset < p_block->i_buffer; i_offset++ )
        {
            if( p_block->p_buffer[i_offset] == p_startcode[i_match] )
            {
                if( !i_match )
                {
                    p_block_backup = p_block;
                    i_offset_backup = i_offset;
                    i_caller_offset_backup = *pi_offset;
                }

                if( i_match + 1 == i_startcode_length )
                {
                    /* We have it */
                    *pi_offset += i_offset - i_match;
                    return VLC_SUCCESS;
                }

                i_match++;
            }
            else if ( i_match )
            {
                /* False positive */
                p_block = p_block_backup;
                i_offset = i_offset_backup;
                *pi_offset = i_caller_offset_backup;
                i_match = 0;
            }

        }
        i_size = 0;
        *pi_offset += i_offset;
    }

    *pi_offset -= i_match;
    return VLC_EGENERIC;
}

#endif /* VLC_BLOCK_HELPER_H */
