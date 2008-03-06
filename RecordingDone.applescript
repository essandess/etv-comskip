-- Run the python MarkCommercials script for the given recording
on RecordingDone(recordingID)
	try
		do shell script "python '/Library/Application Support/ETVComskip/MarkCommercials.py' --log " & recordingID & " > /dev/null 2>&1" & " &"
	end try
end RecordingDone

-- testing code: this will not be called when triggered from EyeTV, but only when the script is run as a stand-alone script
on run
	tell application "EyeTV"
		set rec to unique ID of item 2 of recordings
	end tell
	my RecordingDone(rec)
end run
