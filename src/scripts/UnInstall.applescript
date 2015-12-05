-- uninstall ETVComskip


-- user launch daemon
do shell script "/bin/launchctl unload -w ~/Library/LaunchAgents/com.github.essandess.etv-comskip.comskipper.plist"
do shell script "/bin/rm -f ~/Library/LaunchAgents/com.github.essandess.etv-comskip.comskipper.plist"

-- remove older login item installs
tell application "System Events"
	delete (every login item whose name contains "ComSkipper")
end tell

do shell script "/bin/rm -rf /Library/Application\\ Support/ETVComskip" with administrator privileges
do shell script "/bin/rm -rf /Library/Application\\ Support/EyeTV/Scripts/TriggeredScripts/RecordingStarted.scpt" with administrator privileges
do shell script "/bin/rm -rf /Library/Application\\ Support/EyeTV/Scripts/TriggeredScripts/RecordingDone.scpt" with administrator privileges
do shell script "/bin/rm -rf /Library/Application\\ Support/EyeTV/Scripts/TriggeredScripts/ExportDone.scpt" with administrator privileges

display dialog "ETVComskip uninstalled" buttons {"Ok"}
