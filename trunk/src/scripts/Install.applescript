-- install ETVComskip

-- tell the user to quit EyeTV if it's running.  We can't do it for them in case recording/exporting is happening
try
	set etv to do shell script "ps -xc -o command | egrep -c '^EyeTV$'"
	if etv ³ 1 then
		display dialog "You must quit EyeTV before installing ETVComskip.  Try again after quitting EyeTV."
		return
	end if
end try


-- restart EyeTV to pick up TriggeredScripts
tell application "EyeTV"
	quit
end tell

-- make triggered scripts directory
set ts_path to "/Library/Application\\ Support/EyeTV/Scripts/TriggeredScripts"
-- make triggered scripts directory
set etv_path to "/Library/Application\\ Support/ETVComskip"
tell application "Finder"
	set havets to (folder ts_path exists)
	set haveetv to (folder etv_path exists)
	set path_ to (folder of file (path to me)) as string
	set path_ to POSIX path of path_
end tell

if not havets then
	do shell script "/bin/mkdir -p " & ts_path with administrator privileges
end if
if not haveetv then
	do shell script "/bin/mkdir -p " & etv_path with administrator privileges
end if
do shell script "/bin/cp -Rfp " & path_ & " " & etv_path with administrator privileges
do shell script "/bin/mv " & etv_path & "/RecordingDone.scpt " & ts_path with administrator privileges

-- make login item for ComSkipper
set appPath to "/Library/Application Support/ETVComskip/ComSkipper.app"
tell application "System Events"
	delete (every login item whose name contains "ComSkipper")
	make new login item at end of login items with properties {path:appPath, hidden:true}
end tell

display dialog "ETVComskip installed"
