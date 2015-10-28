-- ETVComskip MarkCommercials script that returns the POSIX directory of the iTunes playlist "TV Shows" folder

set TV_Shows to "TV Shows"

tell application "iTunes"
	try
		set tvlist to playlist TV_Shows
		set first_file to location of (get first track in tvlist) --as alias
	on error
		return
	end try
	tell application "Finder" to set itunes_tv_path to container of first_file as Unicode text
	-- fix AppleScript's strange trailing colon issue for paths
	if character -1 of itunes_tv_path is not ":" then set itunes_tv_path to itunes_tv_path & ":"
	set delims to AppleScript's text item delimiters
	set AppleScript's text item delimiters to TV_Shows
	set itunes_tv_path to (text item 1 of itunes_tv_path) & TV_Shows & ":"
	set AppleScript's text item delimiters to delims
	set itunes_tv_path to POSIX path of itunes_tv_path
	get itunes_tv_path
end tell
