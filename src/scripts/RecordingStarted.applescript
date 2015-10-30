on RecordingStarted(recordingID)
	delay 10
	-- comskip81 uses ffmpeg and does not support live tv; put this in RecordingDone.scpt
	--	set cmd to "export DISPLAY=:0.0; /usr/bin/nice -n 5 '/Library/Application Support/ETVComskip/bin/MarkCommercials' --log " & recordingID & " &> /dev/null &"
	-- display dialog cmd
	-- set cmd to "env > /tmp/etv_test.log &"
	-- do shell script cmd
	
	--disable this if you do not want a logfile written
	write_to_file((short date string of (current date) & " " & time string of (current date)) & "Recording Started run for ID: " & recordingID & (ASCII character 13), (path to "logs" as string) & "EyeTV scripts.log", true)
end RecordingStarted

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
