#!/usr/bin/env python
#
# ComSkipper.py, EyeTV3 version, part of ETVComskip.
#
# Copyright (c) 2008, Jon A. Christopher
# Licensed under the GNU General Public License, version 2
#
#
# Theory of operation: This program runs in an infinite loop.  If
# EyeTV is not running it sleeps for 15 sec and tries again.  If it is
# running, and playing a recording, then the program wakes up every
# second to see if the current playback time is within a commercial
# break as defined by the markers in the EyeTV recording.  If so, it
# jumps to the end of the break.



try:
    import aem # provided with appscript package
    from appscript import *
except ImportError, e:
    sys.stderr.write('Error: importing appscript\n%s\n' % e)
    sys.exit(importExitCode)
    
import time
import objc
from AppKit import *
from ScriptingBridge import *

last_rec=""
last_ct=-1


def IsETVRunning():
    for app in NSWorkspace.sharedWorkspace().launchedApplications():
        if app['NSApplicationName'] == "EyeTV":
            return True
    return False


def GetMarkers(rec,current_time=0):
    markers=rec.markers.get()
    mrks=[]
    for m in markers:
        p=m['position']
        l=m[aem.AEType('leng')]
        if p > current_time:
            mrks.append((p,p+l))
    return mrks

def MainLoop():
  global last_rec, last_ct, markers
  while 1:
      if not IsETVRunning():
          #print "ETV Not runnink"
          time.sleep(15)
          continue

      if not app("EyeTV").playing.get():
          #print "ETV Not playink"
          time.sleep(1)
          continue

      # get currently-playing recording
      # unfortunately, there's not a direct way to do this(!), so we have to use the window name and hope
      window_name=app("EyeTV").player_windows()[0].name()
      rec=app("EyeTV").recordings[window_name].get()
      if rec != last_rec:
          last_rec = rec
          last_ct = -1
          markers=GetMarkers(rec)
          #print "got markers"

      ct=app("EyeTV").current_time.get()

      # reset markers if we've gone backwards
      if ct < last_ct:
          markers=GetMarkers(rec,ct)
          #print "gone backwards!!!!!!!!!!!!!!!!!"
      last_ct=ct


      for m in markers:
          #print "CT %f comparing to (%f %f)\n" % (ct,m[0],m[1])
          if ct < m[0]:
              #print "Ct < m[0], breaking"
              break

          if ct < m[1]:
              app("EyeTV").jump(to=m[1])

              # re-get the (pruned) markers list so that the first
              # entry will be the next commercial break.  we use the
              # pruned list to avoid having to iterate through the
              # entire list of markers every second

              ct=app("EyeTV").current_time.get()
              markers=GetMarkers(rec,ct)
              #print "ETV skipped"

      time.sleep(1)
        

# keep trying again in case of error (connection lost, etc)
while 1:
    try:
        MainLoop()
        last_rec=""
        last_ct=-1
    except:
        pass
