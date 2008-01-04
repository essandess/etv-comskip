/*****************************************************************************
 * charset.h: Determine a canonical name for the current locale's character encoding.
 *****************************************************************************
 * Copyright (C) 2003-2005 the VideoLAN team
 * $Id: charset.h 12809 2005-10-10 07:56:33Z jpsaman $
 *
 * Author: Derk-Jan Hartman <thedj at users.sourceforge.net>
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

#ifndef __VLC_CHARSET_H
#define __VLC_CHARSET_H 1

# ifdef __cplusplus
extern "C" {
# endif

VLC_EXPORT( vlc_bool_t, vlc_current_charset, ( char ** ) );
VLC_EXPORT( void, LocaleFree, ( const char * ) );
VLC_EXPORT( char *, FromLocale, ( const char * ) );
VLC_EXPORT( char *, ToLocale, ( const char * ) );
VLC_EXPORT( char *, EnsureUTF8, ( char * ) );
VLC_EXPORT( char *, FromUTF32, ( const wchar_t * ) );
VLC_EXPORT( char *, __vlc_fix_readdir_charset, ( vlc_object_t *, const char * ) );
#define vlc_fix_readdir_charset(a,b) __vlc_fix_readdir_charset(VLC_OBJECT(a),b)

# ifdef __cplusplus
}
# endif

#endif
