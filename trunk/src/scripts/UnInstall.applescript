-- uninstall ETVComskip

tell application "System Events"
	delete (every login item whose name contains "ComSkipper")
end tell

do shell script "rm -rf /Library/Application\\ Support/ETVComskip"
do shell script "rm -rf /Library/Application\\ Support/EyeTV/Scripts/TriggeredScripts/RecordingDone.scpt"

display dialog "ETVComskip uninstalled"
