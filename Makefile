NAME=ETVComskip
VERSION=1.0.2
#  Leopard (10.5), Tiger (10.4)
OsVersion=$(shell python -c 'import platform,sys;x=platform.mac_ver()[0].split(".");sys.stdout.write("%s.%s" % (x[0],x[1]))')
IMGNAME=${NAME}-${VERSION}-${OsVersion}
SUMMARY="Version ${VERSION} for EyeTV3 for ${OsVersion}"


all: distdir MarkCommercials comskip ComSkipper RecordingDone Install docs dmg

upload:
	python ./googlecode_upload.py --config-dir=none -s '${SUMMARY}' -p etv-comskip -u jon.christopher -l "Type-Installer,Featured,OpSys-OSX" ETVComskip/${IMGNAME}.dmg


distdir::
	-mkdir ETVComskip

dmg: distdir MarkCommercials comskip ComSkipper RecordingDone Install docs 
	cd ETVComskip; rm *.dmg*; hdiutil create -fs HFS+ -format UDBZ -volname ${IMGNAME} -srcfolder . ${IMGNAME}


comskip:: distdir MarkCommercials
	pushd src/comskip; make; popd
	mv comskip ETVComskip/MarkCommercials.app/Contents/Resources
	cp comskip.ini ETVComskip/MarkCommercials.app/Contents/Resources

ComSkipper:: distdir
	-rm -rf src/scripts/ComSkipper/dist
	-rm -rf src/scripts/ComSkipper/build
	-rm -rf ETVComskip/ComSkipper.app
	pushd src/scripts/ComSkipper; python setup.py py2app; mv dist/ComSkipper.app ../../../ETVComskip; popd

MarkCommercials:: distdir
	-rm -rf src/scripts/MarkCommercials/dist
	-rm -rf src/scripts/MarkCommercials/build
	-rm -rf ETVComskip/MarkCommercials.app
	pushd src/scripts/MarkCommercials; python setup.py py2app; mv dist/MarkCommercials.app ../../../ETVComskip; popd

Install:: distdir
	pushd src/scripts; osacompile -o ../../ETVComskip/Install\ ETVComskip.app Install.applescript; popd
	pushd src/scripts; osacompile -o ../../ETVComskip/UnInstall\ ETVComskip.app UnInstall.applescript; popd

RecordingDone:: distdir
	pushd src/scripts; osacompile -do ../../ETVComskip/RecordingDone.scpt RecordingDone.applescript; popd

docs::
	cp README-EyeTV3 LICENSE LICENSE.rtf CHANGELOG AUTHORS ETVComskip

package:: distdir MarkCommercials comskip ComSkipper RecordingDone Install docs
	rm -rf ETVComskip/ETVComskip-1.0.0rc8.mpkg
	/Developer/Applications/Utilities/PackageMaker.app/Contents/MacOS/PackageMaker --doc ETVComskip-$(VERSION).pmdoc --out ETVComskip/ETVComskip-$(VERSION).mpkg -v -b

clean::
	pushd src/comskip; make clean; popd
	rm -rf ETVComskip
	-rm -rf src/scripts/MarkCommercials/dist
	-rm -rf src/scripts/MarkCommercials/build
	-rm -rf src/scripts/ComSkipper/dist
	-rm -rf src/scripts/ComSkipper/build
