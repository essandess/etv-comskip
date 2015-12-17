-- Run the python MarkCommercials script for the given recording
-- this must be run with the RecordingStarted script
-- it will check if there were multiple PIDs for the recording and runs MarkCommercials for each pid
-- requires updated MarkCommercials which allows specifying the pid
-- by Ben Blake, September 2009

-- modified for latest ComSkip, which cannot be run until after recording is finished; waits for Turbo.264 HD and EyeTV to stop running as well
-- Steven T. Smith steve dot t dot smith at gmail dot com

global LogMsg

on RecordingDone(recordingID)
	
	set DEBUG to true
	set unix_return to (ASCII character 10)
	set ascii_tab to (ASCII character 9)
	set myid to recordingID as integer
	set TimeoutTime to 12 * hours
	
	with timeout of TimeoutTime seconds
		
		my write_to_file((short date string of (current date) & " " & time string of (current date)) & " " & "RecordingDone run for ID: " & recordingID & unix_return, (path to "logs" as Unicode text) & "EyeTV scripts.log", true)
		
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
		set done_waiting_for_itunes_file to eyetv_path & eyetv_root & ".done_waiting_for_iTunes.txt"
		
		-- test for EyeTV exports
		set not_exporting_count to 0
		set max_not_exporting_count to 3
		set EyeTV_export_flag to false
		repeat
			-- wait a little for EyeTV exports to kick in
			delay 10
			
			-- test for EyeTV exports
			tell application "EyeTV"
				if is_exporting then
					set EyeTV_export_flag to true
				end if
				set EyeTV_is_busy to false
				if is_exporting or is_compacting or my mcIsRunning() then
					set EyeTV_is_busy to true
					set not_exporting_count to 0 -- reset counter
				end if
			end tell
			if not EyeTV_is_busy then
				set not_exporting_count to not_exporting_count + 1
			end if
			if not_exporting_count ³ max_not_exporting_count then
				if EyeTV_export_flag then
					-- wait for ExportDone to wait for iTunes
					with timeout of 30 * minutes seconds
						repeat
							delay 5
							tell application "Finder" to if exists done_waiting_for_itunes_file then exit repeat
						end repeat
						tell application "Finder" to delete file done_waiting_for_itunes_file
					end timeout
				end if
				exit repeat
			end if
			
		end repeat
		
	end timeout
	
	if DEBUG then
		my write_to_file(ascii_tab & "RecordingDone::MarkCommercials" & unix_return, (path to "logs" as Unicode text) & "EyeTV scripts.log", true)
	end if
	
	-- MarkCommercials will run comskip and apply the .edl file to all recordings, including iTunes exports
	set cmd to "export DISPLAY=:0.0; /usr/bin/nice -n 5 '/Library/Application Support/ETVComskip/bin/MarkCommercials' --log " & recordingID & " &> /dev/null &"
	-- display dialog cmd
	-- set cmd to "env > /tmp/etv_test.log &"
	do shell script cmd
	
	set LogMsg to ""
	CheckMultiplePIDs(recordingID, DEBUG)
	
	--disable this if you do not want a logfile written
	if (count of LogMsg) > 0 then
		write_to_file((short date string of (current date) & " " & time string of (current date)) & LogMsg & unix_return, (path to "logs" as string) & "EyeTV scripts.log", true)
	end if
	
end RecordingDone

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

-- compute the percentage CPU used by DecoderProcess
on CPUPercentage(DecoderProcess)
	set ProcessPS to do shell script ("ps -axwwc | grep '" & DecoderProcess & "' | grep -v grep || true")
	if ProcessPS is not equal to "" then
		set ProcessID to word 1 of ProcessPS
		set ProcessPS to do shell script ("ps -xwwco pid,ppid,%cpu -p " & ProcessID & " | tail -1")
		set ProcessCPU to word 3 of ProcessPS
		return ProcessCPU as number
	else
		return ""
	end if
end CPUPercentage

on CheckMultiplePIDs(recordingID, DEBUG)
	--check if there are multiple Video PIDs in the file
	
	tell application "EyeTV"
		set input_text to my read_from_file((path to "logs" as string) & "ETVComskip" & ":" & recordingID & "_comskip.log")
		if (count of (input_text as string)) > 0 then
			set logdata to every paragraph of input_text
			set logdata_lastrow to (item ((count of logdata) - 1) of logdata) as string
			
			if (items 1 thru 19 of logdata_lastrow) as string = "Video PID not found" then
				--multiple Video PIDs, rerun MarkCommercials until successful
				
				set recrdingIDInteger to recordingID as integer
				set rec to recording id recrdingIDInteger
				set LogMsg to "RecordingDone found multiple PIDs for recording ID: " & recordingID & ", Channel " & (channel number of rec) & " - " & (title of rec)
				
				set PIDs to (items 44 thru ((count of logdata_lastrow) - 2) of logdata_lastrow) as string
				set delims to AppleScript's text item delimiters
				set AppleScript's text item delimiters to ", "
				set PID_List to {}
				set PID_List to every word of PIDs
				set AppleScript's text item delimiters to delims
				
				repeat with pid in PID_List
					if DEBUG then
						my write_to_file(ascii_tab & "RecordingDone::CheckMultiplePIDs:MarkCommercials with pid " & (pid as string) & unix_return, (path to "logs" as Unicode text) & "EyeTV scripts.log", true)
					end if
					my launchComSkip(recordingID, pid)
					repeat while (my mcIsRunning())
						delay 5
					end repeat
				end repeat
				
			end if
		end if
	end tell
end CheckMultiplePIDs

on read_from_file(target_file)
	--return the contents of the given file
	set fileRef to (open for access (target_file))
	set txt to (read fileRef for (get eof fileRef) as Çclass utf8È)
	close access fileRef
	return txt
end read_from_file

on write_to_file(this_data, target_file, append_data)
	--from http://www.apple.com/applescript/sbrt/sbrt-09.html
	try
		set the target_file to the target_file as string
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

on launchComSkip(recID, pid)
	if pid = "" then
		set cmd to "export DISPLAY=:0.0; /usr/bin/nice -n 5 '/Library/Application Support/ETVComskip/bin/MarkCommercials' --force --log " & recID & " &> /dev/null &"
	else
		set cmd to "export DISPLAY=:0.0; /usr/bin/nice -n 5 '/Library/Application Support/ETVComskip/bin/MarkCommercials' --force --log " & recID & " --pid=" & pid & " &> /dev/null &"
	end if
	
	do shell script cmd
end launchComSkip

on mcIsRunning()
	set processPaths to do shell script "ps -xww | awk -F/ 'NF >2' | awk -F/ '{print $NF}' | awk -F '-' '{print $1}' "
	return (processPaths contains "MarkCommercials")
end mcIsRunning

-- testing code: this will not be called when triggered from EyeTV, but only when the script is run as a stand-alone script
on run
	tell application "EyeTV"
		-- set rec to unique ID of item 1 of recordings
		set rec to 471846780
		
		my RecordingDone(rec)
	end tell
end run

