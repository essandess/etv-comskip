-- uninstall ETVComskip

tell application "System Events"
	delete (every login item whose name contains "ComSkipper")
end tell

do shell script "/bin/rm -rf /Library/Application\\ Support/ETVComskip" with administrator privileges
do shell script "/bin/rm -rf /Library/Application\\ Support/EyeTV/Scripts/TriggeredScripts/RecordingDone.scpt" with administrator privileges

display dialog "ETVComskip uninstalled"
