NAME=ETVComskip
VERSION=3.0
# El Capitan (10.11)
OsVersion=$(shell python -c 'import platform,sys;x=platform.mac_ver()[0].split(".");sys.stdout.write("%s.%s" % (x[0],x[1]))')
IMGNAME=${NAME}-${VERSION}-${OsVersion}
SUMMARY="Version ${VERSION} for EyeTV3 for ${OsVersion}"

DLDIR=~/Downloads
PORT=/opt/local/bin/port
LOCALBIN=/opt/local/bin

all: xcode macports distdir MarkCommercials comskip ComSkipper EyeTVTriggers Install docs dmg

upload:
	pushd ${DLDIR} && git clone https://github.com/essandess/etv-comskip.git && popd

xcode::
	# Install OS X Command Line Tools
	CLT_DIR=`xcode-select -p`
	RV=$?
	if ! [ $RV -eq '0' ]
	then
		echo 'Please install Xcode Command Line Tools as a sudoer...'
    		sudo /usr/bin/xcode-select --install
    		sudo /usr/bin/xcodebuild -license
	fi

macports:: xcode
	# Install MacPorts
	if ! [ -x $PORT ]
	then
    		open -a Safari https://www.macports.org/install.php
    	cat <<MACPORTS
Please download and install Macports from https://www.macports.org/install.php
then run make again.
MACPORTS
    		exit 1
	fi
	echo 'Please update and install the necessary Macports as a sudoer...'
	sudo $PORT selfupdate
	sudo $PORT install python27
	sudo $PORT --set python python27
	sudo $PORT install py-appscript py-py2app
	-sudo $PORT uninstall ffmpeg-devel
	sudo $PORT install ffmpeg +x11
	sudo $PORT install argtable
	sudo $PORT install mp4v2 coreutils

distdir:: macports
	pushd ${DLDIR} && ( test -d ETVComskip || mkdir ETVComskip ) && popd

dmg: distdir MarkCommercials comskip ComSkipper EyeTVTriggers Install docs
	pushd ${DLDIR}/ETVComskip
	-rm *.dmg*
	hdiutil create -fs HFS+ -format UDBZ -volname ${IMGNAME} -srcfolder . ${IMGNAME}
	popd

comskip:: distdir MarkCommercials
	# comskip
	pushd ./src/Comskip
	./autogen.sh
	./configure
	make
	# comskip.ini
	install -m 644 ./src/comskip_ini/comskip.ini ${DLDIR}/ETVComskip
	install -m 644 ./src/comskip_ini/comskip.ini.us_cabletv ${DLDIR}/ETVComskip

ComSkipper:: distdir
	-rm -rf src/scripts/ComSkipper/dist
	-rm -rf src/scripts/ComSkipper/build
	-rm -rf ETVComskip/ComSkipper.app
	pushd ./src/scripts/ComSkipper && python setup.py py2app ; mv ./dist/ComSkipper.app ${DLDIR}/ETVComskip ; popd

MarkCommercials:: distdir
	-rm -rf src/scripts/MarkCommercials/dist
	-rm -rf src/scripts/MarkCommercials/build
	-rm -rf ETVComskip/MarkCommercials.app
	pushd ./src/scripts/MarkCommercials && python setup.py py2app ; mv ./dist/MarkCommercials.app ${DLDIR}/ETVComskip ; popd

Install:: distdir
	pushd ./src/scripts && osacompile -o ${DLDIR}/ETVComskip/Install\ ETVComskip.app ./Install.applescript && popd
	pushd ./src/scripts && osacompile -o ${DLDIR}/ETVComskip/UnInstall\ ETVComskip.app ./UnInstall.applescript && popd

EyeTVTriggers:: distdir
	pushd ./src/scripts && osacompile -do ${DLDIR}/ETVComskip/RecordingStarted.scpt ./RecordingStarted.applescript && popd
	pushd ./src/scripts && osacompile -do ${DLDIR}/ETVComskip/RecordingDone.scpt ./RecordingDone.applescript && popd
	pushd ./src/scripts && osacompile -do ${DLDIR}/ETVComskip/ExportDone.scpt ./ExportDone.applescript && popd

docs::
	cp LICENSE LICENSE.rtf AUTHORS ${DLDIR}/ETVComskip

package:: distdir MarkCommercials comskip ComSkipper EyeTVTriggers Install docs
	rm -fr ${DLDIR}/ETVComskip/ETVComskip-1.0.0rc8.mpkg
	#/Developer/Applications/Utilities/PackageMaker.app/Contents/MacOS/PackageMaker --doc ETVComskip-$(VERSION).pmdoc --out ${DLDIR}/ETVComskip/ETVComskip-$(VERSION).mpkg -v -b
	pkgbuild --doc ETVComskip-$(VERSION).pmdoc --out ${DLDIR}/ETVComskip/ETVComskip-$(VERSION).mpkg -v -b

install:: distdir MarkCommercials comskip ComSkipper EyeTVTriggers Install docs
	sudo install -m 755 ${DLDIR}/ETVComskip "/Library/Application Support"
	pushd ./src/Comskip
	echo 'Please install the comskip binaries as a sudoer...'
	sudo install -m 755 ./comskip $LOCALBIN
	sudo install -m 755 ./comskip-gui $LOCALBIN
	popd

clean::
	rm -fr ${DLDIR}/ETVComskip
	-rm -fr ./src/scripts/MarkCommercials/dist
	-rm -fr ./src/scripts/MarkCommercials/build
	-rm -fr ./src/scripts/ComSkipper/dist
	-rm -fr ./src/scripts/ComSkipper/build
	-pushd ./src/Comskip && make distclean && popd

