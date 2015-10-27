# etv-comskip

Commercial Marking and Skipping for EyeTV and iTunes Exports

Currently porting and refactoring from the googlecode version. Please watch for the version 1.0 release.

## Synopsis

Commercial detection and skipping for [EyeTV](https://www.elgato.com/en/eyetv/eyetv-3), using [Comskip](https://github.com/erikkaashoek/Comskip).

These programs allow users of EyeTV to enjoy commercial-free recorded high definition (HD) television.

## Description

EyeTV records tv shows, transcodes them for personal broadcast over an EyeTV server, and exports recordings to iTunes where they can be synced to iOS and iTV devices. Comskip detects the commercials. ETVComskip marks and skips the commercials in both EyeTV recordings and iTunes exports. Helper software is used for commercials skipping. ComSkipper.app skips commercials in EyeTV recordings. The Videos app arrow keys are used in iOS devices, which may be triggered by a wide variety of headphone or bluetooth controls.

## Operation

Recording, transcoding, and commercial detection are all performed sequentially because of their high computational cost. Comskip saves the detected commercials in an Edit Decision List (.edl) file located in the same EyeTV directory as the original h.264 .mpg recording. The MarkCommercials.app sets the markers on the EyeTV recording, and uses the mp4chaps command to set the commercials as chapters within the mp4 .m4v transcodings both in the EyeTV directory and in any iTunes recordings.

Commercials are kept within the recording; users are expected to use helper software to skip them. This avoids any infrequent yet frustrating problems with false detections and misalignment. Both Elgato's EyeTV.app and Turbo.264 HD apps respect .edl files for transcoding, allowing semi-automated commercial deletion from recordings.

## Installation

Double-click on "Install ETVComskip".

This will install several files in /Library/Application Support/ETVComskip, and /Library/Application Support/EyeTV/Scripts/TriggeredScripts.

This will also create a login item for ComSkipper.app to make EyeTV automatically skip marked commercials on playback.

To uninstall these files and login item, double-click on "UnInstall ETVComskip", which is located in /Library/Application Support/ETVComskip.

## Variations

Comskip also allows the capability for live commercial detection and skipping. This feature was once supported in the older [Google code version](https://github.com/essandess/etv-comskip/releases/tag/v0) of etv-comskip for non-HD recordings. etv-comskip has been refactored for sequential operations on HD recordings, but it would be possible to create a live commercial skipping.

## Contributors

Jon Christopher wrote the original etv-comskip for non-HD recordings. Dick Gordon, Rick Kier, and Lycestra all contributed. I refactored the original code with work with the HD version of Comskip and handle MP4 transcodings and iTunes exports.

None of this would be possible without Erik Kaashoek's [Comskip](https://github.com/erikkaashoek/Comskip). Erik has a contributor's link at his [website](http://www.kaashoek.com/comskip/), and asks for a $10 donations for the version of Comskip included in this distribution. 

## License

Licensed under the GNU General Public License, version 2
