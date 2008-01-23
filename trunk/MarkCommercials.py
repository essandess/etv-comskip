#
# MarkCommercials.py, EyeTV3 version
#
# Copyright (c) 2008, Jon A. Christopher
# Licensed under the GNU General Public License, version 2
#
#
# Run comskip on the specified file and replace the markers in the .eyetvr
# file with the new markers.
#
# If argument is 'all', process all recordings which don't
# have markers.  
#
# If argument is'forceall', process all recordings.
#
# Otherwise, argument is treated as an EyeTV recording id, and that
# recording is processed.
#


import sys, os, string

# provided with appscript package
import aem
from appscript import *

# for debugging. when False, will not actually run comskip, but will do everything else
RUN_COMSKIP=True


# Possibly run comskip and return the name of a plist file with commercial markers in it
def GetPlistFile(etvr_file, run_comskip=True):
    ETVComskipDir="/Library/Application\ Support/ETVComskip"
    
    FileDir = os.path.dirname(etvr_file)
    dir, fil = os.path.split(etvr_file)
    FileRoot, ext = os.path.splitext(fil)

    MpgFile = FileRoot + ".mpg"
    LogFile = FileRoot + ".log"
    PlistFile = FileRoot + ".plist"

    cmd=ETVComskipDir + "/comskip --ini=" + ETVComskipDir + "/comskip.ini " + MpgFile # + " &> " + LogFile
    os.chdir(FileDir)
    #print "Dir is now: ", FileDir
    #os.system("ls")
    if run_comskip:
        #print "Running command: ", cmd
        os.system(cmd)
    return PlistFile

# extract a time in seconds from a "<integer>?????</integer>" field
def GetTime(field):
    words=field.split(">")
    num=words[1].split("<")
    return int(num[0])/90000.0

# return start and ending times for the given line
def TimeChop(line):
    fields=line.split(" ")
    start=GetTime(fields[0])
    end=GetTime(fields[1])
    return (start,end)

# given a plist file, return a markers array suitable for adding to a recording
def GetMarkersArray(PlistFile):
    try:
        file = open(PlistFile, 'r')
        lines = file.readlines()
        file.close()
    except:
        return

    markers=[]
    for line in lines:
        if line[0:4] == "<int":
            start,end = TimeChop(line)
            marker={}
            marker['position']=start
            marker[aem.AEType('leng')]= end - start
            markers.append(marker)

    return markers


def ProcessRecording(rec_id, run_comskip):
    # use appscript instead of applescript to talk to eyetv and get
    # the recording with the given ID
    rec=app("EyeTV").recordings[its.unique_ID == rec_id].get()[0]

    # and get its path
    etvr_path=rec.location.get().path

    # get the plist file for this recording, and make a markers array for it
    Plist=GetPlistFile(etvr_path,run_comskip)
    markers=GetMarkersArray(Plist)
    
    # and finally, set them
    rec.markers.set(markers)
    #print "Set markers on recording %s" % rec_id



if sys.argv[1]=="all" or sys.argv[1]=="forceall":
    # batch mode, process all recordings without markers
    recs=app("EyeTV").recordings.get()
    for rec in recs:
        if len(rec.markers.get())==0 or sys.argv[1]=="forceall":
            ProcessRecording(rec.unique_ID.get(),RUN_COMSKIP)
else:
    # triggered mode, process just the listed recording
    ProcessRecording(sys.argv[1], RUN_COMSKIP)


