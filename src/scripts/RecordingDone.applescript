-- Run the python MarkCommercials script for the given recording
on RecordingDone(recordingID)
	set cmd to "'/Library/Application Support/ETVComskip/MarkCommercials.app/Contents/MacOS/MarkCommercials' --log " & recordingID & " &> /dev/null &"
	--display dialog cmd
	do shell script cmd
end RecordingDone

-- testing code: this will not be called when triggered from EyeTV, but only when the script is run as a stand-alone script
on run
	tell application "EyeTV"
		set rec to unique ID of item 1 of recordings
		display dialog rec
		my RecordingDone(rec)
	end tell
end run
