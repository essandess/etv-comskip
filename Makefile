NAME=ETVComskip
VERSION=3.0
# El Capitan (10.11)
OsVersion=$(shell python -c 'import platform,sys;x=platform.mac_ver()[0].split(".");sys.stdout.write("%s.%s" % (x[0],x[1]))')
IMGNAME=${NAME}-${VERSION}-${OsVersion}
SUMMARY="Version ${VERSION} for EyeTV3 for ${OsVersion}"

DLDIR=~/Downloads

all: distdir MarkCommercials comskip ComSkipper EyeTVTriggers Install docs dmg

upload:
	pushd ${DLDIR} && git clone https://github.com/essandess/etv-comskip.git && popd

distdir::
	pushd ${DLDIR} && mkdir ETVComskip && popd

dmg: distdir MarkCommercials comskip ComSkipper EyeTVTriggers Install docs
	pushd ${DLDIR}/ETVComskip
	-rm *.dmg*
	hdiutil create -fs HFS+ -format UDBZ -volname ${IMGNAME} -srcfolder . ${IMGNAME}
	popd

comskip:: distdir MarkCommercials
	rsync -va ${DLDIR}/etv-comskip/src/comskip_ini ${DLDIR}/ETVComskip

ComSkipper:: distdir
	pushd ${DLDIR}/etv-comskip
	-rm -rf src/scripts/ComSkipper/dist
	-rm -rf src/scripts/ComSkipper/build
	-rm -rf ETVComskip/ComSkipper.app
	pushd ./src/scripts/ComSkipper && python setup.py py2app ; mv ./dist/ComSkipper.app ${DLDIR}/ETVComskip ; popd
	popd

MarkCommercials:: distdir
	pushd ${DLDIR}/etv-comskip
	-rm -rf src/scripts/MarkCommercials/dist
	-rm -rf src/scripts/MarkCommercials/build
	-rm -rf ETVComskip/MarkCommercials.app
	pushd ./src/scripts/MarkCommercials && python setup.py py2app ; mv ./dist/MarkCommercials.app ${DLDIR}/ETVComskip ; popd
	popd

Install:: distdir
	pushd ${DLDIR}/etv-comskip
	pushd ./src/scripts && osacompile -o ${DLDIR}/ETVComskip/Install\ ETVComskip.app ./Install.scpt && popd
	pushd ./src/scripts && osacompile -o ${DLDIR}/ETVComskip/UnInstall\ ETVComskip.app ./UnInstall.scpt && popd
	popd

EyeTVTriggers:: distdir
	pushd ${DLDIR}/etv-comskip
	pushd ./src/scripts && osacompile -do ${DLDIR}/ETVComskip/RecordingStarted.scpt ./RecordingStarted.scpt && popd
	pushd ./src/scripts && osacompile -do ${DLDIR}/ETVComskip/RecordingDone.scpt ./RecordingDone.scpt && popd
	pushd ./src/scripts && osacompile -do ${DLDIR}/ETVComskip/ExportDone.scpt ./ExportDone.scpt && popd
	popd

docs::
	pushd ${DLDIR}/etv-comskip
	cp LICENSE LICENSE.rtf AUTHORS ${DLDIR}/ETVComskip
	popd

package:: distdir MarkCommercials comskip ComSkipper EyeTVTriggers Install docs
	rm -fr ${DLDIR}/ETVComskip/ETVComskip-1.0.0rc8.mpkg
	#/Developer/Applications/Utilities/PackageMaker.app/Contents/MacOS/PackageMaker --doc ETVComskip-$(VERSION).pmdoc --out ${DLDIR}/ETVComskip/ETVComskip-$(VERSION).mpkg -v -b
	pkgbuild --doc ETVComskip-$(VERSION).pmdoc --out ${DLDIR}/ETVComskip/ETVComskip-$(VERSION).mpkg -v -b

clean::
	rm -fr ${DLDIR}/ETVComskip
	pushd ${DLDIR}/etv-comskip
	-rm -fr ./src/scripts/MarkCommercials/dist
	-rm -fr ./src/scripts/MarkCommercials/build
	-rm -fr ./src/scripts/ComSkipper/dist
	-rm -fr ./src/scripts/ComSkipper/build
	popd
