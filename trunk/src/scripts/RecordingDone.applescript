-- Run the python MarkCommercials script for the given recording
-- this must be run with the RecordingStarted script
-- it will check if there were multiple PIDs for the recording and runs MarkCommercials for each pid
-- requires updated MarkCommercials which allows specifying the pid
-- by Ben Blake, September 2009

global LogMsg

on RecordingDone(recordingID)
	set LogMsg to ""
	CheckMultiplePIDs(recordingID)
	
	--disable this if you do not want a logfile written
	if (count of LogMsg) > 0 then
		write_to_file((short date string of (current date) & " " & time string of (current date)) & LogMsg & (ASCII character 13), (path to "logs" as string) & "EyeTV scripts.log", true)
	end if
end RecordingDone

-- testing code: this will not be called when triggered from EyeTV, but only when the script is run as a stand-alone script
on run
	tell application "EyeTV"
		set rec to unique ID of item 1 of recordings
		
		my RecordingDone(rec)
	end tell
end run

on CheckMultiplePIDs(recordingID)
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
		set cmd to "'/Library/Application Support/ETVComskip/MarkCommercials.app/Contents/MacOS/MarkCommercials' --force --log " & recID & " &> /dev/null &"
	else
		set cmd to "'/Library/Application Support/ETVComskip/MarkCommercials.app/Contents/MacOS/MarkCommercials' --force --log " & recID & " --pid=" & pid & " &> /dev/null &"
	end if
	
	do shell script cmd
end launchComSkip

on mcIsRunning()
	set processPaths to do shell script "ps -xww | awk -F/ 'NF >2' | awk -F/ '{print $NF}' | awk -F '-' '{print $1}' "
	return (processPaths contains "MarkCommercials")
end mcIsRunning