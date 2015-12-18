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
	
	set DEBUG to true
	set unix_return to (ASCII character 10)
	set ascii_tab to (ASCII character 9)
	set myid to recordingID as integer
	set mp4chaps to "'/Library/Application Support/ETVComskip/bin/mp4chaps'"
	set mp4chaps_suffix to ".chapters.txt"
	set export_suffix to ".exported_inodes.txt"
	set edl_suffix to ".edl"
	set perl_suffix to ".pl"
	
	set TimeoutTime to 12 * hours
	
	with timeout of TimeoutTime seconds
		
		my write_to_file((short date string of (current date) & " " & time string of (current date)) & " " & "ExportDone run for ID: " & recordingID & unix_return, (path to "logs" as Unicode text) & "EyeTV scripts.log", true)
		
		-- try block example for debugging:
		-- try
		-- 	set mymp4 to (item 1 of mytv)
		-- on error errText number errNum
		-- 	set exported_error_file to eyetv_path & eyetv_root & ".error.txt"
		-- 	my write_to_file("ExportDone error 1: " & errText & "; error number " & errNum & "." & unix_return, exported_error_file, false)
		-- end try
		
		tell application "EyeTV"
			set myshortname to get the title of recording id myid
			set eyetvr_file to get the location of recording id myid as alias
		end tell
		if DEBUG then
			my write_to_file(ascii_tab & "ExportDone::Title: " & myshortname & unix_return, (path to "logs" as Unicode text) & "EyeTV scripts.log", true)
			my write_to_file(ascii_tab & "Location: " & POSIX path of eyetvr_file & unix_return, (path to "logs" as Unicode text) & "ExportDone::EyeTV scripts.log", true)
		end if
		
		-- if DEBUG then
		-- 	return
		-- end if
		
		-- Get EyeTV's root file names and paths for the recording
		tell application "Finder" to set eyetv_path to container of eyetvr_file as Unicode text
		-- fix AppleScript's strange trailing colon issue for paths
		if character -1 of eyetv_path is not ":" then set eyetv_path to eyetv_path & ":"
		tell application "Finder" to set eyetv_file to name of eyetvr_file
		set eyetv_root to (RootName(eyetv_file) of me)
		set edl_file to eyetv_path & eyetv_root & edl_suffix
		set edl_file_posix to POSIX path of edl_file
		set exported_inodes_file to eyetv_path & eyetv_root & export_suffix
		set done_waiting_for_itunes_file to eyetv_path & eyetv_root & ".done_waiting_for_iTunes.txt"
		
		-- Elgato adds a few seconds here, but perhaps minutes are necessary to ensure success under heavy CPU loads
		-- delete signaling file `done_waiting_for_itunes_file` if it exists for multiple exports
		tell application "Finder"
			try
				delete file done_waiting_for_itunes_file
			end try
		end tell
		delay 1 * minutes -- wait a minute for iTunes
		set exportdonedate to (current date)
		delay 2 * minutes --if the script does not seem to work, try increasing this delay slightly.
		-- file communication that ExportDone is done waiting for iTunes to update its db
		my write_to_file("", done_waiting_for_itunes_file, true)
		
		-- EyeTV exports to the "TV Shows" playlist
		tell application "iTunes"
			set mytv to {}
			set mymovies to {}
			-- wait for iTunes to find the track, and try a few attempts
			repeat 4 times
				try
					set mytv to get the location of (the tracks of playlist "TV Shows" whose name is myshortname or artist is myshortname)
					-- remove any "missing value" entries (not sure why iTunes throws these sometiimes)
					set mytv to my remove_missing_values_from_list(mytv)
					if DEBUG then
						if the (count of mytv) is greater than 0 then
							repeat with kk from 1 to (count of mytv)
								my write_to_file(ascii_tab & "ExportDone::repeatloop mytv: " & (item kk of mytv) & unix_return, (path to "logs" as Unicode text) & "EyeTV scripts.log", true)
							end repeat
						else
							my write_to_file(ascii_tab & "ExportDone::repeatloop mytv: empty" & unix_return, (path to "logs" as Unicode text) & "EyeTV scripts.log", true)
						end if
					end if
					if not mytv = {} then
						exit repeat
					else
						delay 2 -- wait a couple seconds
					end if
				on error errText number errNum
					if DEBUG then
						my write_to_file(ascii_tab & "ExportDone::repeatloop mytv error: " & errText & "; error number " & errNum & "." & unix_return, (path to "logs" as Unicode text) & "EyeTV scripts.log", true)
					end if
					delay 2 -- wait a couple seconds
				end try
				-- I've also seen EyeTV exports appear in the "Movies" playlist (not sure why)
				try
					set mymovies to get the location of (the tracks of playlist "Movies" whose name is myshortname or artist is myshortname)
					-- remove any "missing value" entries (not sure why iTunes throws these sometiimes)
					set mymovies to my remove_missing_values_from_list(mymovies)
					if DEBUG then
						if the (count of mymovies) is greater than 0 then
							repeat with kk from 1 to (count of mymovies)
								my write_to_file(ascii_tab & "ExportDone::repeatloop mymovies: " & (item kk of mymovies) & unix_return, (path to "logs" as Unicode text) & "EyeTV scripts.log", true)
							end repeat
						else
							my write_to_file(ascii_tab & "ExportDone::repeatloop mymovies: {}" & unix_return, (path to "logs" as Unicode text) & "EyeTV scripts.log", true)
						end if
					end if
					if not mymovies = {} then
						exit repeat
					else
						delay 2 -- wait a couple seconds
					end if
				on error errText number errNum
					if DEBUG then
						my write_to_file(ascii_tab & "ExportDone::repeatloop mymovies error: " & errText & "; error number " & errNum & "." & unix_return, (path to "logs" as Unicode text) & "EyeTV scripts.log", true)
					end if
					delay 2 -- wait a couple seconds
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
			if DEBUG then
				my write_to_file(ascii_tab & "ExportDone::empty mytv!!!" & unix_return, (path to "logs" as Unicode text) & "EyeTV scripts.log", true)
			end if
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
			if mydate is less than mydate_kk and not (mydate_kk is greater than exportdonedate) then
				set mymp4 to mymp4_kk
				set mymp4_posix to mymp4_posix_kk
				set mydate to mydate_kk
			end if
		end repeat
		
		set deltatime to (exportdonedate - mydate)
		-- return if the iTunes recording is too old
		if deltatime is greater than 12 * hours then
			if DEBUG then
				my write_to_file(ascii_tab & "ExportDone::older file, deltatime: " & (deltatime as string) & unix_return, (path to "logs" as Unicode text) & "EyeTV scripts.log", true)
			end if
			return
		end if
		
		-- wait for file to not be open, but proceed even if it is
		with timeout of 20 * minutes seconds
			repeat
				if not my IsFileOpen(mymp4_posix, DEBUG) then exit repeat
				delay 60
			end repeat
		end timeout
		-- proceed whether file was open or not
		
		if DEBUG then
			my write_to_file(ascii_tab & "ExportDone::mymp4: " & mymp4_posix & unix_return, (path to "logs" as Unicode text) & "EyeTV scripts.log", true)
			my write_to_file(ascii_tab & "ExportDone::deltatime: " & (deltatime as string) & unix_return, (path to "logs" as Unicode text) & "EyeTV scripts.log", true)
		end if
		
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
		my write_to_file((my FileInode(mymp4_posix) as string) & unix_return, exported_inodes_file, true)
		
	end timeout
	
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

-- remove any "missing value" list entries
on remove_missing_values_from_list(mylist)
	set mylist_nomissingvalue to {}
	repeat with kk from 1 to (count of mylist)
		set mylist_kk to (item kk of mylist)
		if mylist_kk is not missing value then set end of mylist_nomissingvalue to mylist_kk
	end repeat
	return mylist_nomissingvalue
end remove_missing_values_from_list

-- return a field from an m4v file
on m4v_field(posix_filename, field_name)
	set mp4info to "'/Library/Application Support/ETVComskip/bin/mp4info'"
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
on IsFileOpen(posix_filename, DEBUG)
	-- safely quote any single quote characters for system calls: ' --> '"'"'
	set posix_filename_safequotes to my replace_chars(posix_filename, "'", "'\"'\"'")
	set res to do shell script ("lsof '" & posix_filename_safequotes & "' | tail -n +2 | perl -ane 'BEGIN {$rv=q/false/;}; $_=@F[0]; !/^mdworker$/ && do {$rv=q/true/;}; END {print $rv;}' || true")
	-- original test; ignores benign Spotlight (mdworker) indexing
	-- set res to do shell script ("lsof '" & posix_filename_safequotes & "' > /dev/null 2>&1 && echo 'true' || echo 'false' || true")
	if res is equal to "true" then
		set res to true
		if DEBUG then
			set pname to do shell script ("lsof '" & posix_filename_safequotes & "' | tail -n +2 | perl -ane 'BEGIN {$rv=q/{/;}; $_=@F[0]; $rv=$rv . q/ / . $_; END {print $rv, q/ }/;}' || true")
			my write_to_file(ascii_tab & "ExportDone::IsFileOpen: " & posix_filename & " is open with process(es) " & pname & unix_return, (path to "logs" as Unicode text) & "EyeTV scripts.log", true)
		end if
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

-- test if the comskip process is running
on comskipIsRunning()
	set processPaths to do shell script "ps -xww | awk -F/ 'NF >2' | awk -F/ '{print $NF}' | awk -F '-' '{print $1}' || true "
	return (processPaths contains "comskip")
end comskipIsRunning

-- testing code: this will not be called when triggered from EyeTV, but only when the script is run as a stand-alone script
on run
	tell application "EyeTV"
		--set rec to unique ID of item 1 of recordings
		-- for all your id's, run /Library/Application\ Support/ETVComskip/bin/MarkCommercials
		set rec to 471846780
		my ExportDone(rec)
	end tell
end run
