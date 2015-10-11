# ETVComskip #

ETVComskip is a Mac OS X port of comskip (http://www.kaashoek.com/comskip/), along with programs to have comskip interoperate with [EyeTV](http://www.elgato.com).  These programs allow users of EyeTV to enjoy commercial-free recorded television.

ETVComskip also integrates with [PyeTV](http://code.google.com/p/pyetv/), a Leopard Front Row plugin for interacting with EyeTV.  With this plugin it's possible to turn commercial skipping on and off directly from within Front Row, as well as start a commercial search on recordings which don't have commercial markers already.

# Installation #

Download the appropriate version for your system 10.4 (Tiger) or 10.5 (Leopard).  Double click to open the .dmg file and run the installer application.

Some few users have reported problems with the .dmg files.  In this case, make sure the extension on the file is .dmg and nothing else.  That should resolve the issue.


# Notes #

It is possible to have a user configuration file which indicates programs/channels not to process for commercials; this might be useful for public broadcasting channels where it is known that there are no commercials.  See the README-EyeTV3 file for details.

The current versions are designed to work with EyeTV3.  The last version which works with EyeTV2 is [1.0RC6](http://etv-comskip.googlecode.com/files/ETVComskip-1.0RC6.tar.gz).

**You must use mpeg-2 recording, not mpeg4 for ETVComskip!**

# News #

## Apr 19, 2010 ##
Updated to version 1.1 which fixes a number of bugs in the python script and switches to running on-the-fly in comskip's "live\_tv" mode.  This should resolve the problems with unicode characters in channel/episode names, too.

## Aug 31, 2009 ##
Thanks to a user, Hank, a Snow Leopard-compatible version is now available.

## Apr 20, 2008 ##

Version 1.0.3: Don't produce debugging samples.csv file (accidentally left on in upstream comskip).

## Apr 17, 2008 ##

Version 1.0.2: Small tweak to installer: ignore errors removing old ComSkipper startup item.

## Apr 16, 2008 ##

Version 1.0.1 Released: updated to comskip 0.79.126; includes bug fixes for MarkCommercials crashing when given a recording with unicode characters in the title.
