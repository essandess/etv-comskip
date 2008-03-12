all: distdir comskip ComSkipper MarkCommercials RecordingDone Install docs

distdir::
	-mkdir ETVComskip

comskip:: distdir
	pushd src/comskip; make; popd
	mv comskip ETVComskip/
	cp comskip.ini ETVComskip/

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
	cp src/scripts/MarkCommercials/MarkCommercials.cfg ETVComskip/

Install:: distdir
	pushd src/scripts; osacompile -o ../../ETVComskip/Install\ ETVComskip.app Install.applescript; popd
	pushd src/scripts; osacompile -o ../../ETVComskip/UnInstall\ ETVComskip.app UnInstall.applescript; popd

RecordingDone:: distdir
	pushd src/scripts; osacompile -do ../../ETVComskip/RecordingDone.scpt RecordingDone.applescript; popd

docs::
	cp README-EyeTV3 LICENSE CHANGELOG ETVComskip

clean::
	pushd src/comskip; make clean; popd
	rm -rf ETVComskip
	-rm -rf src/scripts/MarkCommercials/dist
	-rm -rf src/scripts/MarkCommercials/build
	-rm -rf src/scripts/ComSkipper/dist
	-rm -rf src/scripts/ComSkipper/build
