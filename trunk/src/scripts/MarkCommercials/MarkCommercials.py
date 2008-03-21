#!/usr/bin/env python
#
# MarkCommercials.py, EyeTV3 version
#
# Copyright (c) 2008, Jon A. Christopher
# Copyright (c) 2008, TeamSTARS Dick Gordon and Rick Kier
# Licensed under the GNU General Public License, version 2
#
#
# Run comskip on the specified file and replace the markers in the .eyetvr
# file with the new markers.
#
# if no arguments show id, recording name...
#
# If argument is 'all', process all recordings which don't
# have markers and do not match any exclude information from the cfg file.  
#
# If argument is'forceall', process all recordings except those that match
# any exclude information in the cfg file.
#
# Otherwise, argument is treated as an EyeTV recording id, and that
# recording is processed if it is not excluded and it does NOT have any markers.
#
# To be done:
#  exporting - not needed??
#  exclude channels
#   Issue: some channels are 0
#  exclude titles
#  exclude station names
#   Issue: some station names are blank
#  Catch ^c when in c program - comskip throws SIGINT's away?? (see mpeg2dec.c)
#  Catch ^c when in python program - coded
#  EXCLUDED_TITLES and EXCLUDED_CHANNELS are NOT empty lists
#  Handle multiple video pids.


import sys, os, string, os.path
import time
from optparse import OptionParser
from ConfigParser import SafeConfigParser 

# Exit Codes
#  Everything worked ok
successExitCode = 0
#  Unable to import appscript
importExitCode = 1
#  Unable to find the recoring specified
noRecordingExitCode = 2
#  Error getting recordings from EyeTV
getRecordingsErrorExitCode = 3
#  Unknown exit code from comskip
unknownComskipErrorExitCode = 4
#  Error when accessing plist file
accessPlistFileErrorExitCode = 5
#  Error when accessing config file
accessConfigFileErrorExitCode = 6
#  Keyboard interrupt (^c)
keyboardInterruptExitCode = 7
#  Unable to communicate with the application
communicationsErrorExitCode = 8
#  Unable to find comskip
locateComskipErrorExitCode = 9

# provided with appscript package
try:
    import aem
    from appscript import *
except ImportError, e:
    sys.stderr.write('Error: importing appscript\n%s\n' % e)
    sys.exit(importExitCode)
    
version = '0.3.0'
# Cfg file definitions and variables
userSectionName = 'User Section'
listDelimiterName = 'LIST_DELIMITER'
excludedTitlesName = 'EXCLUDED_TITLES'
excludedChannelsName = 'EXCLUDED_CHANNELS'
excludedStationNamesName = 'EXCLUDED_STATION_NAME'
excludedTitles = []
excludedChannels = []
excludedStationNames = []
# General variables
options = None
args = None
recordingCount = 0
comskipLogPathName = None
log = None
growl = None
eyeTV = None
pathToComskip = None
nameOfComskip = 'comskip'
comskipLocations = ['.', r'/Library/Application Support/ETVcomskip']

# for debugging. when False, will not actually run comskip, but will do everything else
RUN_COMSKIP = True

# Get the executable directory
ETVComskipDir = os.path.abspath(os.path.dirname(__file__))

# Growl support
commercialStart = 'Start'
commercialStartDescription = 'Start detecting commercials'
commercialStop = 'Stop'
commercialStopDescription = 'Stop detecting commercials'
programName = 'Mark Commercials'
allNotificationsList = [commercialStart, commercialStop]

def InitGrowl():
    """docstring for InitGrowl"""
    global growl
    global allNotificationsList
    
    # Should we use growl?
    if not options.growl:
        # No
        return
    growl = app('GrowlHelperApp')  
    enabledNotificationsList = allNotificationsList
    WriteToLog('Registering with growl\n')
    try:
        growl.register(as_application=programName,
                        all_notifications=allNotificationsList,
                        default_notifications=enabledNotificationsList)
    except Exception, e:
        WriteToLog('Error: registering with growl\n  %s\n' % e)
        growl = None
        
    
def sendGrowlNotification(title, description):
    """docstring for sendGrowlNotification"""
    # Send a Notification...
    if growl is not None:
        WriteToLog('Sending notification via growl\n')
        try:
            growl.notify(with_name=programName,
                        title=title,
                        description=description,
                        application_name=programName)
        except Exception, e:
            WriteToLog('Error: growl notify\n  %s\n' % e)

# Find comskip
def findComskip(name=nameOfComskip):
    global pathToComskip
    
    # Add our location 
    comskipLocations.append(os.path.dirname(sys.argv[0]))
    WriteToLog('Searching %s for %s\n' % (comskipLocations, name))
    for location in comskipLocations:
        absLocation = os.path.abspath(location)
        currentPath = os.path.join(absLocation, name)
        WriteToLog('Checking for %s\n' % currentPath)
        if os.path.isfile(currentPath):
            WriteToLog('  found\n')
            pathToComskip = absLocation
            break
        else:
            WriteToLog('  not found\n')

    else:
        msg = 'Error: unable to locate commercial skip application:%s\n' % name
        WriteToLog(msg)
        sys.stderr.write(msg)
        sys.exit(locateComskipErrorExitCode)
    
    
# Create the log file
def GetLog(name=None):
    """docstring for GetLog"""
    global log
    global comskipLogPathName
    
    # Should we log?
    if not options.log:
        return

    # Is the log directory created?
    fullPath = os.path.expanduser('~/Library/Logs/ETVComskip')
    if not os.path.isdir(fullPath):
        # No, create it.
        os.mkdir(fullPath)
    # Create the log
    if name is None:
        name = time.strftime('%m-%d-%Y %H-%M-%S')
    comskipLogPathName = os.path.join(fullPath, name + '_comskip.log')
    log = open(os.path.join(fullPath, name + '.log'), 'w')
    
def WriteToLog(message):
    """docstring for WriteToLog"""
    if options.log:
        log.write('%s - %s' % (time.asctime(), message))
        log.flush()

def CheckForApplicationCommunications(retries=3):
    """docstring for CheckForApplicationCommunications"""
    global EyeTV
    
    # launch the application
    EyeTV.launch
    WriteToLog('Checking communications to %s with %d retries\n' % (options.app, retries))
    for attempt in range(retries):
        try:
            # Get the recordings
            EyeTV.recordings.get()
            # It worked - break out of here
            WriteToLog('  Attempt %d worked\n' % (attempt + 1))
            break
        except Exception, e:
            WriteToLog('  Attempt %d failed\n    %s\n' % ((attempt + 1), e))
            EyeTV = app(options.app)
            time.sleep(0.5)
            continue
    else:
        msg = 'Error: unable to communicate with %s\n' % application
        WriteToLog(msg)
        sys.stderr.write(msg)
        sys.exit(communicationsErrorExitCode)
    
def GetRecordings(retries=0):
    """docstring for GetRecordings"""
    global EyeTV
    
    WriteToLog('Getting recordings\n')
    try:
        recordings = EyeTV.recordings.get()
    except Exception, e:
        msg = 'Error: unable to get recordings\n%s\n' % e
        WriteToLog(msg)
        sys.stderr.write(msg)
        sys.exit(getRecordingsErrorExitCode)
    WriteToLog('Recordings: %s\n' % recordings)
    return recordings

# Possibly run comskip and return the name of a plist file with commercial markers in it
def GetPlistFile(etvr_file, run_comskip=True):
    
    FileDir = os.path.dirname(etvr_file)
    dir, fil = os.path.split(etvr_file)
    FileRoot, ext = os.path.splitext(fil)

    MpgFile = FileRoot + ".mpg"
    PlistFile = FileRoot + ".plist"

    cmd = '"%s" --ini="%s" %s' % (os.path.join(pathToComskip, nameOfComskip), 
                                  os.path.join(pathToComskip, nameOfComskip) + '.ini', 
                                  MpgFile)
    outputName = '/dev/null'
    if options.log:
        cmd += ' > %s 2>&1' % comskipLogPathName
    else:
        cmd += ' > %s 2>&1' % '/dev/null'
    if options.verbose:
        cmd += ' --verbose=%d' % options.verbose
    WriteToLog('Changing directory to %s\n' % FileDir)
    os.chdir(FileDir)
    if run_comskip:
        # Notify the user
        sendGrowlNotification(commercialStart, commercialStartDescription)
        # TBD stop comskip when ^c happens
        WriteToLog('Running: %s\n' % cmd)
        rc = os.system(cmd)
        # Notify the user
        sendGrowlNotification(commercialStop, commercialStopDescription)
        WriteToLog('Return code is: %d, 0x%x\n' % (rc, rc))
        errorCode = (rc >> 8) & 0xff
        WriteToLog('Error code is: %d, 0x%x\n' % (errorCode, errorCode))
        # Error code:
        #   3 = no Video pid found
        #   2 = Can't open the mpeg2 file TBD
        #   1 = Commercials found
        #   0 = Commercials not found
        if errorCode  == 2:
            msg = 'Unable to open mpeg2 file return from "comskip": %d\n' % errorCode
            WriteToLog(msg)
            sys.stderr.write(msg)
            return None
        elif errorCode == 3:
            msg = 'No video pid found return from "comskip": %d\n' % errorCode
            WriteToLog(msg)
            sys.stderr.write(msg)
            return None
        elif errorCode == 1:
            WriteToLog('Commercials found by comskip\n')
            return PlistFile
        elif errorCode == 0:
            WriteToLog('No commercials found by comskip\n')
            return None
        else:
            msg = 'Error: unknown error code from comskip: %d\n' % errorCode
            WriteToLog(msg)
            sys.stderr.write(msg)
            sys.exit(unknownComskipErrorExitCode)

# extract a time in seconds from a "<integer>?????</integer>" field
def GetTime(field):
    words = field.split(">")
    num = words[1].split("<")
    return int(num[0])/90000.0

# return start and ending times for the given line
def TimeChop(line):
    fields = line.split(" ")
    start = GetTime(fields[0])
    end = GetTime(fields[1])
    return (start,end)

# given a plist file, return a markers array suitable for adding to a recording
def GetMarkersArray(PlistFile):
    try:
        file = open(PlistFile)
        lines = file.readlines()
        file.close()
    except Exception, e:
        msg = 'Error: accessing %s\n%s\n' % (PlistFile, e)
        WriteToLog(msg)
        sys.stderr.write(msg)
        sys.exit(accessPlistFileErrorExitCode)

    WriteToLog('Plist file contents: %s\n' % lines)
    markers=[]
    for line in lines:
        if line[0:4] == "<int":
            start,end = TimeChop(line)
            WriteToLog('Adding marker, start: %d, end: %d\n' % (start, end))
            marker = {}
            marker['position'] = start
            marker[aem.AEType('leng')] = end - start
            markers.append(marker)

    return markers

def ProcessRecording(recording, run_comskip):
    
    global recordingCount 
    
    channel = recording.channel_number()
    title = recording.title()
    stationName = recording.station_name()

    recordingCount += 1
    msg = '%2d. Processing "%s" on [%s] channel [%s]...' % (recordingCount, title, stationName, channel)
    WriteToLog('%s\n' % msg)
    print msg

    # Should excludes be allowed?
    if not options.noexclude:
        # Yes, Is this one allowed?
        #  User can exclude titles, channels and station names
        # Channel
        print '  Channel: %s' % channel,
        if str(channel) in excludedChannels:
            WriteToLog('Skipped due to channel match\n')
            print ' skipped'
            return
        print ', not skipped'
        # Title
        print '  Title: %s' % title,
        if title in excludedTitles:
            WriteToLog('Skipped due to title match\n')
            print ' skipped'
            return
        print ', not skipped'
        # Station name
        print '  Station name: %s' % stationName,
        if stationName in excludedStationNames:
            WriteToLog('Skipped due to station name match\n')
            print ' skipped'
            return
        print ', not skipped'

    # Get its path
    etvr_path = recording.location.get().path
    WriteToLog('Path to recording is %s\n' % etvr_path)

    # get the plist file for this recording, and make a markers array for it
    Plist = GetPlistFile(etvr_path, run_comskip)
    # Did we get a plist file?
    if Plist is not None:
        # Yes, convert it.
        markers = GetMarkersArray(Plist)    
        # and finally, set them
        WriteToLog('Setting markers on recording\n')
        recording.markers.set(markers)

def main():
    global options
    global args
    global excludedTitles
    global excludedChannels
    global excludedStationNames
    global log
    global EyeTV
    
    # Do the options
    usage = "usage: %prog [options] [RECORDING-ID | 'all' | 'forceall']"
    parser = OptionParser(usage=usage, version=version)
    parser.add_option("--noexclude",
                    action="store_true", dest="noexclude", default=False,
                    help="Do NOT exclude recordings specified in cfg file, default=%default")
    parser.add_option("--force",
                    action="store_true", dest="force", default=False,
                    help="Force commercial marking on specified RECORDING-ID. Allows marking when markers already exist, default=%default")
    parser.add_option("--growl",
                    action="store_true", dest="growl", default=False,
                    help="Enable growl notification, default=%default")
    parser.add_option("--log",
                    action="store_true", dest="log", default=False,
                    help="Enable logging, default=%default")
    parser.add_option("--app",
                    dest="app", default='EyeTV',
                    help="Specify EyeTV application name, default=%default")
    parser.add_option("--verbose",
                    type='int',
                    dest="verbose", default=0,
                    help="Verbosity level, 0-10, default=%default")
    (options, args) = parser.parse_args()

    if len(args):
        name = args[0]
    else:
        name = None
    GetLog(name=name)
    WriteToLog('%s, %s starting\n' % (sys.argv[0], version))
    WriteToLog('Command line: %s\n' % sys.argv)
    WriteToLog('Application name: %s\n' % options.app)
    print '\t\t%s\t%s\n' % (os.path.splitext(os.path.basename(sys.argv[0]))[0], version)
    
    # Get the app
    EyeTV = app(options.app)

    # Use growl notifications
    InitGrowl()
    # Get our configuration file & data
    configInput = SafeConfigParser()
    try:
        cfgFilesRead = configInput.read([os.path.join(os.path.dirname(sys.argv[0]), 'MarkCommercials.cfg'),
                                         os.path.expanduser('~/.MarkCommercials.cfg')])
    except Exception, e:
        msg = 'Error: reading configuration file\n%s\n' % e
        WriteToLog(msg)
        sys.stderr.write(msg)
        sys.exit(accessConfigFileErrorExitCode)
    WriteToLog('Cfg files read: %s\n' % cfgFilesRead)
    if cfgFilesRead:
        # Process the user's section
        if configInput.has_section(userSectionName):
            # Process the user's section
            #   Get the delimiter
            listDelimiter = configInput.get(userSectionName, listDelimiterName)
            if configInput.has_option(userSectionName, excludedChannelsName):
                for channel in configInput.get(userSectionName, excludedChannelsName).split(listDelimiter):
                    excludedChannels.append(channel)
            if configInput.has_option(userSectionName, excludedTitlesName):
                for title in configInput.get(userSectionName, excludedTitlesName).split(listDelimiter):
                    excludedTitles.append(title)
            if configInput.has_option(userSectionName, excludedStationNamesName):
                for title in configInput.get(userSectionName, excludedStationNamesName).split(listDelimiter):
                    excludedStationNames.append(title)
        WriteToLog('List Delimiter: %s\n' % listDelimiter)
        WriteToLog('Excluded Channels: %s\n' % excludedChannels)
        WriteToLog('Excluded Titles: %s\n' % excludedTitles)
        WriteToLog('Excluded Station names: %s\n' % excludedStationNames)
         
    # Test communications with application
    CheckForApplicationCommunications()

    # Get the location of the commercial skipper
    findComskip()

    # Show the IDs and program names when there are no arguments
    #    replace any non ascii characters with ?
    if len(args) == 0:
        for rec in GetRecordings():
            programName = os.path.split(os.path.splitext(os.path.dirname(rec.location.get().path))[0])[1]
            outputName = ''
            for char in programName:
                # Insure the character is ascii
                if ord(char) <= 127:
                    outputName += char
                else:
                    outputName += '?'
            msg = '  %d = [%s], [%s], [%s]' % (rec.unique_ID.get(), outputName, rec.channel_number(), rec.station_name())
            WriteToLog('%s\n' % msg)
            print msg
        return successExitCode

    if args[0] == "all" or args[0] == "forceall":
        # batch mode, process all recordings without markers
        recs = GetRecordings()
        for rec in recs:
            markerCount = len(rec.markers.get())
            WriteToLog('Marker count: %d\n' % markerCount)
            if markerCount == 0 or args[0] == "forceall":
                ProcessRecording(rec, RUN_COMSKIP)
    else:
        # triggered mode, process just the listed recording
        recs = GetRecordings()
        recordingRequested = int(args[0])
        for rec in recs:
            if rec.unique_ID() == recordingRequested:
                WriteToLog('Found recording %d\n' % recordingRequested)
                break
        else:
            msg = 'Error: unable to find recording %d\n' % recordingRequested
            WriteToLog(msg)
            sys.stderr.write(msg)
            sys.exit(noRecordingExitCode)
        markerCount = len(rec.markers.get())
        WriteToLog('Marker count: %d\n' % markerCount)
        # Recording already have markers?
        if markerCount == 0:
            # No
            ProcessRecording(rec, RUN_COMSKIP)
        # Is the recording already marked but the user wants it done again?
        elif markerCount != 0 and options.force:
            # Yes
            WriteToLog('Recording already marked - use forcing with --force option\n')
            ProcessRecording(rec, RUN_COMSKIP)
        else:
            # Recording already maked and user doesn't want it done again
            msg = 'Recording previously marked'
            WriteToLog('%s\n' % msg)
            print '  %s' % msg
    return successExitCode

if __name__ == '__main__':
    '''
    Call main
    '''
    try:
        exitStatus = main()
    except KeyboardInterrupt, e:
        msg = 'Error: %s\n' % e
        WriteToLog(msg)
        sys.stderr.write(msg)
        sys.exit(keyboardInterruptExitCode)
        pass
    WriteToLog('Exiting\n')
    sys.exit(exitStatus)



