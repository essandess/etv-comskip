all: distdir MarkCommercials comskip ComSkipper RecordingDone Install docs package

distdir::
	-mkdir ETVComskip

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
	pushd src/scripts/MarkCommercials; python setup.py py2app --site-packages; mv dist/MarkCommercials.app ../../../ETVComskip; popd

Install:: distdir
	pushd src/scripts; osacompile -o ../../ETVComskip/Install\ ETVComskip.app Install.applescript; popd
	pushd src/scripts; osacompile -o ../../ETVComskip/UnInstall\ ETVComskip.app UnInstall.applescript; popd

RecordingDone:: distdir
	pushd src/scripts; osacompile -do ../../ETVComskip/RecordingDone.scpt RecordingDone.applescript; popd

docs::
	cp README-EyeTV3 LICENSE LICENSE.rtf CHANGELOG ETVComskip

package:: distdir MarkCommercials comskip ComSkipper RecordingDone Install docs
	rm -rf ETVComskip/ETVComskip-1.0.0rc8.mpkg
	/Developer/Applications/Utilities/PackageMaker.app/Contents/MacOS/PackageMaker --doc ETVComskip-1.0.0rc8.pmdoc --out ETVComskip/ETVComskip-1.0.0rc8.mpkg -v -b

clean::
	pushd src/comskip; make clean; popd
	rm -rf ETVComskip
	-rm -rf src/scripts/MarkCommercials/dist
	-rm -rf src/scripts/MarkCommercials/build
	-rm -rf src/scripts/ComSkipper/dist
	-rm -rf src/scripts/ComSkipper/build
