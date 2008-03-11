#!/bin/sh

# run comskip on the specified file and replace the markers in the .eyetvr
# file with the new markers.  This is a separate script instead of
# embedded in the applescript because we don't want applescript to have to
# wait for the results, but we need to do two steps: comskip and PlistBuddy merge

#echo "got arguments $*"


CSDIR="`dirname $0`" 
PLISTBUDDY=`locate PlistBuddy | head -1`

MPEG_FILE=$1
DIR=`dirname "$1"`
BASE=`basename "$1" .mpg`

MPEG_FILE="${BASE}.mpg"
EYETVR_FILE="${BASE}.eyetvr"
PLIST_FILE="${BASE}.plist"
LOG_FILE="${BASE}.log"

cd "${DIR}"


if [ ! -e ${PLIST_FILE} -o $# -gt 1 ]
then
  "${CSDIR}/comskip" --ini="${CSDIR}/comskip.ini" "${MPEG_FILE}" &>"${LOG_FILE}"
fi

# delete the markers array if it exists
printf "delete markers\nsave\nquit\n" | "${PLISTBUDDY}" "${EYETVR_FILE}"

# replace it with our version
printf "add markers array\nmerge\'${PLIST_FILE}\' markers\nsave\nquit\n" | "${PLISTBUDDY}" "${EYETVR_FILE}"

