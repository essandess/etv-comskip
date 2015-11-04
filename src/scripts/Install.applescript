-- install ETVComskip

-- tell the user to quit EyeTV if it's running.  We can't do it for them in case recording/exporting is happening
try
	set etv to do shell script "ps -xc -o command | egrep -c '^EyeTV$'"
	if etv ³ 1 then
		display dialog "You must quit EyeTV before installing ETVComskip.  Try again after quitting EyeTV." buttons {"Ok"}
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
	set haveetvprev to (folder (etv_path & ".previous") exists)
	set path_ to (folder of file (path to me)) as string
	set path_ to POSIX path of path_
end tell

if not havets then
	do shell script "/bin/mkdir -p " & ts_path with administrator privileges
end if
if haveetv then
	if haveetvprev then
		do shell script "/bin/rm -fr " & etv_path & ".previous" with administrator privileges
	end if
	-- Fix trailing slash issue here:
	-- do shell script "/bin/mv -f " & etv_path & " " & etv_path & ".previous" with administrator privileges
end if
display dialog "The next step may take a few moments...."
-- do shell script "/usr/bin/rsync -av " & path_ & " " & etv_path with administrator privileges
do shell script "/bin/rm -fr " & etv_path with administrator privileges
do shell script "/bin/cp -Rfp " & path_ & " " & etv_path with administrator privileges
do shell script "/bin/cp -f " & etv_path & "/scripts/RecordingStarted.scpt " & ts_path with administrator privileges
do shell script "/bin/cp -f " & etv_path & "/scripts/RecordingDone.scpt " & ts_path with administrator privileges
do shell script "/bin/cp -f " & etv_path & "/scripts/ExportDone.scpt " & ts_path with administrator privileges

-- create a user launchd plist for ComSkipper
try
	-- unload any existing plist and fail gracefully if it's not there
	do shell script "/bin/launchctl unload -w ~/Library/LaunchAgents/com.github.essandess.etv-comskip.comskipper.plist"
end try
do shell script "/bin/cp -f " & etv_path & "/scripts/com.github.essandess.etv-comskip.comskipper.plist ~/Library/LaunchAgents"
do shell script "/bin/launchctl load -w ~/Library/LaunchAgents/com.github.essandess.etv-comskip.comskipper.plist"

-- delete any login item for ComSkipper.app [previous versions]
set appPath to "/Library/Application Support/ETVComskip/ComSkipper.app"
tell application "System Events"
	try
		delete (every login item whose name contains "ComSkipper")
	end try
	-- make new login item at end of login items with properties {path:appPath, hidden:true}
end tell

display dialog "ETVComskip installed" buttons {"Ok"}
