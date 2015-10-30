-- EyeTV ExportDone script to use ComSkip to mark commercials in exports to iTunes and ~/Movies, and save exported file inode numbers as the text file filename.exported_inodes.txt for synchronization with MarkCommercials.py

-- Copyright © 2012Ð2015 Steven T. Smith <steve dot t dot smith at gmail dot com>, GPL

--    This program is free software: you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation, either version 3 of the License, or
--    (at your option) any later version.
--
--    This program is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.
--
--    You should have received a copy of the GNU General Public License
--    along with this program.  If not, see <http://www.gnu.org/licenses/>.

-- 2012-10-19 1.0rc1: Initial release as part of 1.0rc1 at ETVComskip Google code page
-- 2013-01-29 1.0rc2: Handle exports to ~/Movies; Fix issues with multiple exports: extend iTunes delay, modify IsFileOpen to ignore Spotlight indexing, and use creation date

on ExportDone(recordingID)
	
	set myid to recordingID as integer
	set mp4chaps to "/opt/local/bin/mp4chaps"
	set mp4chaps_suffix to ".chapters.txt"
	set export_suffix to ".exported_inodes.txt"
	set edl_suffix to ".edl"
	set perl_suffix to ".pl"
	
	my write_to_file((short date string of (current date) & " " & time string of (current date)) & " " & "Export Done run for ID: " & recordingID & return, (path to "logs" as Unicode text) & "EyeTV scripts.log", true)
	
	-- try block example for debugging:
	-- try
	-- 	set mymp4 to (item 1 of mytv)
	-- on error errText number errNum
	-- 	set exported_error_file to eyetv_path & eyetv_root & ".error.txt"
	-- 	my write_to_file("ExportDone error 1: " & errText & "; error number " & errNum & "." & return, exported_error_file, false)
	-- end try
	
	tell application "EyeTV"
		set myshortname to get the title of recording id myid
		set eyetvr_file to get the location of recording id myid as alias
	end tell
	
	-- Get EyeTV's root file names and paths for the recording
	tell application "Finder" to set eyetv_path to container of eyetvr_file as Unicode text
	-- fix AppleScript's strange trailing colon issue for paths
	if character -1 of eyetv_path is not ":" then set eyetv_path to eyetv_path & ":"
	tell application "Finder" to set eyetv_file to name of eyetvr_file
	set eyetv_root to (RootName(eyetv_file) of me)
	set edl_file to eyetv_path & eyetv_root & edl_suffix
	set edl_file_posix to POSIX path of edl_file
	set exported_inodes_file to eyetv_path & eyetv_root & export_suffix
	
	-- Elgato adds a few seconds here, but minutes are necessary to ensure success under heavy CPU loads
	delay 60 --if the script does not seem to work, try increasing this delay slightly.
	
	-- EyeTV exports to the "TV Shows" playlist
	tell application "iTunes"
		set mytv to {}
		set mymovies to {}
		-- wait for iTunes to find the track, and try a few attempts
		repeat 4 times
			try
				set mytv to get the location of (the tracks of playlist "TV Shows" whose name is myshortname or artist is myshortname)
				if not mytv = {} then
					exit repeat
				else
					delay 2 * 60 -- wait a couple minutes
				end if
			on error
				delay 2 * 60 -- wait a couple minutes
			end try
			-- I've also seen EyeTV exports appear in the "Movies" playlist (not sure why)
			try
				set mymovies to get the location of (the tracks of playlist "Movies" whose name is myshortname or artist is myshortname)
				if not mymovies = {} then
					exit repeat
				else
					delay 2 * 60 -- wait a couple minutes
				end if
			on error
				delay 2 * 60 -- wait a couple minutes
			end try
		end repeat
		-- merge the results from the "TV Shows" and "Movies" playlists
		set mytv to mytv & mymovies
	end tell
	
	-- find all .m4v files in ~/Movies that match the name or artist fields
	
	-- find all files in ~/Movies
	tell application "Finder" to set movie_dir_list to every item of ((folder "Movies" of home))
	
	-- find all .m4v files in ~/Movies
	set movie_list to {}
	repeat with movie in movie_dir_list
		if my ExtensionName(movie as alias) = "m4v" then set end of movie_list to (movie as alias)
	end repeat
	
	-- find all movies whose name or artist match
	set movie_dir_list to movie_list
	set movie_list to {}
	repeat with movie in movie_dir_list
		if my m4v_field(POSIX path of (movie as alias), "Name") = myshortname or my m4v_field(POSIX path of (movie as alias), "Artist") = myshortname then Â
			set end of movie_list to (movie as alias)
	end repeat
	
	-- merge the results from iTunes and ~/Movies
	set mytv to mytv & movie_list
	
	-- return if no exports match; this shouldn't happen!
	if the (count of mytv) is less than 1 then
		return
	end if
	
	-- find the most recent export that isn't an open file
	set mymp4 to (item 1 of mytv)
	set mymp4_posix to POSIX path of mymp4
	tell application "Finder" to set mydate to (creation date of mymp4)
	repeat with kk from 2 to (count of mytv)
		set mymp4_kk to (item kk of mytv)
		set mymp4_posix_kk to POSIX path of mymp4_kk
		tell application "Finder" to set mydate_kk to (creation date of mymp4_kk)
		if mydate is less than mydate_kk and not my IsFileOpen(mymp4_posix_kk) then
			set mymp4 to mymp4_kk
			set mymp4_posix to mymp4_posix_kk
			set mydate to mydate_kk
		end if
	end repeat
	
	-- Setting itunes_root ...
	-- safely quote any single quote characters for system calls: ' --> '"'"'
	set mymp4_posix_safequotes to my replace_chars(mymp4_posix, "'", "'\"'\"'")
	tell application "Finder" to set itunes_path to container of mymp4 as Unicode text
	-- fix AppleScript's strange trailing colon issue for paths
	if character -1 of itunes_path is not ":" then set itunes_path to itunes_path & ":"
	tell application "Finder" to set itunes_file to name of mymp4
	set itunes_root to (RootName(itunes_file) of me)
	
	-- save the iTunes file inode to the exported files file "*.exported_inodes.txt"
	-- find the exported file with the command: find . -type f -inum <inum>
	my write_to_file((my FileInode(mymp4_posix) as string) & return, exported_inodes_file, true)
	
	-- return if no .edl file
	tell application "Finder"
		if not (exists file edl_file) then return
	end tell
	
	-- add the mp4 chapters if the .edl file exists
	
	-- define the mp4chaps chapter file
	set itunes_chapter_file to (POSIX path of itunes_path) & itunes_root & mp4chaps_suffix
	
	-- translate the .edl file into a mp4chaps chapter file using perl
	set perlCode to "
#!/usr/bin/perl

########################################
# CONVERT EDL FILES TO MP4CHAPS FILES  #
########################################

# Copyright © 2012Ð2013 Steven T. Smith <steve dot t dot smith at gmail dot com>, GPL

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

use strict;

my $edl_file = q{" & edl_file_posix & "};
my $txt_file = q{" & itunes_chapter_file & "};

sub sec2hhmmss {
my $rem = $_[0]/3600;
my $hh = int($rem);
$rem = ($rem - $hh)*60;
my $mm = int($rem);
$rem = ($rem - $mm)*60;
    my $ss = int($rem);
    $rem = ($rem - $ss);
    $rem = sprintf(\"%.3f\",$rem);  # millisecond precision
    $rem =~ s/^0//;
    return sprintf(\"%02d:%02d:%02d%s\",$hh,$mm,$ss,$rem);
}

open (EDL,$edl_file) || die(\"Cannot open edl file \" . $edl_file);
open (TXT,\">\",$txt_file) || die(\"Cannot open txt file \" . $txt_file);
my $line;
my @times;
my $comskipno = 0;
my $comskipchapno = 0;
print TXT \"00:00:00.000 Beginning\\n\";
while ($line = <EDL>) {
    chomp $line;
    # parse the space-delimited edl ascii times into an array of numbers
    @times = split ' ', $line;
    @times = map {$_+0} @times; # (unnecessarily) convert strings to numbers
    $comskipno += 1 if ($comskipno == 0 && $times[0] != 0.0);
    if ($#times < 2 || $times[2] == 0.0) {
        if ($times[0] != 0.0) {
            print TXT sprintf(\"%s Chapter %d End\\n\",sec2hhmmss($times[0]),$comskipno);
        }
	 $comskipno++;
        print TXT sprintf(\"%s Chapter %d Start\\n\",sec2hhmmss($times[1]),$comskipno);
    } else {
        # never seen this case, but here for logical consistency
        $comskipchapno++;
        if ($times[0] != 0.0) {
            print TXT sprintf(\"%s Chapter %d Start\\n\",sec2hhmmss($times[0]),$comskipchapno);
        }
        print TXT sprintf(\"%s Chapter %d End\\n\",sec2hhmmss($times[1]),$comskipchapno);
    }
}
close (EDL) ;
close (TXT) ;
"
	
	-- define the perl  script and run it and delete it
	set perl_file to eyetv_path & eyetv_root & perl_suffix
	-- safely quote any single quote characters for system calls: ' --> '"'"'
	set perl_file_safequotes to my replace_chars(POSIX path of perl_file, "'", "'\"'\"'")
	
	my write_to_file(perlCode & return, perl_file as Unicode text, false)
	set perlRes to do shell script "perl '" & perl_file_safequotes & "' || true"
	tell application "Finder" to delete file perl_file
	
	-- execute mp4chaps and delete the chapter file
	-- remove any existing chapters
	set mp4chapsRes to do shell script mp4chaps & " -r '" & mymp4_posix_safequotes & "' > /dev/null 2>&1 || true"
	-- import the comskip chapters
	set mp4chapsRes to do shell script mp4chaps & " -i '" & mymp4_posix_safequotes & "' > /dev/null 2>&1 || true"
	-- delete the chapter file
	tell application "Finder" to delete file (itunes_path & itunes_root & mp4chaps_suffix)
end ExportDone

-- extract the root name of a file
on RootName(fname)
	-- http://stackoverflow.com/questions/12907517/extracting-file-extensions-from-applescript-paths
	set root to fname as Unicode text
	set delims to AppleScript's text item delimiters
	set AppleScript's text item delimiters to "."
	if root contains "." then set root to (text items 1 thru -2 of root) as text
	set AppleScript's text item delimiters to delims
	return root
end RootName
-- extract the root name of a file
on ExtensionName(fname)
	set extn to fname as Unicode text
	set delims to AppleScript's text item delimiters
	set AppleScript's text item delimiters to "."
	if extn contains "." then set extn to (last text item of extn) as text
	set AppleScript's text item delimiters to delims
	return extn
end ExtensionName

-- return a field from an m4v file
on m4v_field(posix_filename, field_name)
	set mp4info to "/opt/local/bin/mp4info"
	-- safely quote any single quote characters for system calls: ' --> '"'"'
	set posix_filename_safequotes to my replace_chars(posix_filename, "'", "'\"'\"'")
	set res to do shell script (mp4info & " '" & posix_filename_safequotes & "' | perl -ne 'chomp; $f=$_; $v=$_; $f=~s/ *(.+):.*/$1/; $f=~/" & field_name & "/ && do {$v=~s/.*: *(.+)$/$1/; print $v;}' || true")
	return res
end m4v_field

-- get the inode of a file
on FileInode(posix_filename)
	-- safely quote any single quote characters for system calls: ' --> '"'"'
	set posix_filename_safequotes to my replace_chars(posix_filename, "'", "'\"'\"'")
	set fi to do shell script ("ls -i '" & posix_filename_safequotes & "' || true")
	if fi is not equal to "" then
		set fi to word 1 of fi
		return fi as number
	else
		return ""
	end if
end FileInode

-- test if a file is open
on IsFileOpen(posix_filename)
	-- safely quote any single quote characters for system calls: ' --> '"'"'
	set posix_filename_safequotes to my replace_chars(posix_filename, "'", "'\"'\"'")
	set res to do shell script ("lsof '" & posix_filename_safequotes & "' | tail -n +2 | perl -ane 'BEGIN {$rv=q/false/;}; $_=@F[0]; !/^mdworker$/ && do {$rv=q/true/;}; END {print $rv;}' || true")
	-- original test; ignores benign Spotlight (mdworker) indexing
	-- set res to do shell script ("lsof '" & posix_filename_safequotes & "' > /dev/null 2>&1 && echo 'true' || echo 'false' || true")
	if res is equal to "true" then
		set res to true
	else
		set res to false
	end if
	return res
end IsFileOpen

-- string replacement
on replace_chars(this_text, search_string, replacement_string)
	set delims to AppleScript's text item delimiters
	set AppleScript's text item delimiters to the search_string
	set the item_list to every text item of this_text
	set AppleScript's text item delimiters to the replacement_string
	set this_text to the item_list as string
	set AppleScript's text item delimiters to delims
	return this_text
end replace_chars

on write_to_file(this_data, target_file, append_data)
	--from http://www.apple.com/applescript/sbrt/sbrt-09.html
	try
		set the target_file to the target_file as Unicode text
		set the open_target_file to open for access file target_file with write permission
		if append_data is false then set eof of the open_target_file to 0
		write this_data to the open_target_file starting at eof
		close access the open_target_file
		return true
	on error
		try
			close access file target_file
		end try
		return false
	end try
end write_to_file

-- testing code: this will not be called when triggered from EyeTV, but only when the script is run as a stand-alone script
on run
	tell application "EyeTV"
		--set rec to unique ID of item 1 of recordings
		-- for all your id's, run /Library/Application\ Support/ETVComskip/bin/MarkCommercials
		set rec to 467532420
		my ExportDone(rec)
	end tell
end run
