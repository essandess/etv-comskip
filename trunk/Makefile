
#####################################################
#  Global variables
NAME=EyeTV-Comskip
VERSION=1.0.0rc8
#  Leopard (10.5), Tiger (10.4)
OsVersion=$(shell python -c 'import platform,sys;x=platform.mac_ver()[0].split(".");sys.stdout.write("%s.%s" % (x[0],x[1]))')

######################################################
#  DMG building mostly from http://el-tramo.be/files/fancy-dmg/Makefile
#  Variables for the dmg file

SOURCE_DIR=ETVComskip
SOURCE_FILES=README-EyeTV3 
SOURCE_FILES+=UnInstall\ ETVComskip.app
SOURCE_FILES+=Install\ ETVComskip.app
SOURCE_FILES+=MarkCommercials.app
SOURCE_FILES+=CHANGELOG
SOURCE_FILES+=LICENSE
SOURCE_FILES+=AUTHORS
SOURCE_FILES+=ComSkipper.app
SOURCE_FILES+=RecordingDone.scpt

SOURCE_PATHS=$(SOURCE_DIR)/README-EyeTV3 
SOURCE_PATHS+=$(SOURCE_DIR)/UnInstall\ ETVComskip.app
SOURCE_PATHS+=$(SOURCE_DIR)/Install\ ETVComskip.app
SOURCE_PATHS+=$(SOURCE_DIR)/MarkCommercials.app
SOURCE_PATHS+=$(SOURCE_DIR)/CHANGELOG
SOURCE_PATHS+=$(SOURCE_DIR)/LICENSE
SOURCE_PATHS+=$(SOURCE_DIR)/AUTHORS
SOURCE_PATHS+=$(SOURCE_DIR)/ComSkipper.app
SOURCE_PATHS+=$(SOURCE_DIR)/RecordingDone.scpt

DMG_SIZE_IN_MB=64
# Do not modify after this
TEMPLATE_DMG=template.dmg

MASTER_DMG=$(NAME)-$(VERSION).dmg
FINAL_DMG=$(NAME)-$(VERSION)-$(OsVersion).dmg
WC_DMG=wc.dmg
WC_DIR=wc

ifeq ($(OsVersion), 10.5)
	DMG_HDIUTIL_GREP_STRING=48465300-0000-11AA-AA11-00306543ECAC
else
	DMG_HDIUTIL_GREP_STRING=Apple_HFS
endif

all: distdir MarkCommercials comskip ComSkipper RecordingDone Install docs $(MASTER_DMG)

distdir::
	-mkdir ETVComskip

###################################
#  Targets for the dmg file

$(TEMPLATE_DMG): $(TEMPLATE_DMG).bz2
	bunzip2 -k $<

$(TEMPLATE_DMG).bz2: 
	@echo
	@echo --------------------- Generating empty template --------------------
	mkdir template
	hdiutil create -size $(DMG_SIZE_IN_MB)m "$(TEMPLATE_DMG)" -srcfolder template -format UDRW -volname "$(NAME)" -quiet -partitionType Apple_HFS
	rmdir template
	bzip2 "$(TEMPLATE_DMG)"
	@echo

$(WC_DMG): $(TEMPLATE_DMG)
	cp $< $@

$(MASTER_DMG): $(WC_DMG) $(SOURCE_PATHS)
	@echo
	@echo --------------------- Creating Disk Image for MacOS $(OsVersion) --------------------
	mkdir -p $(WC_DIR)
	hdiutil attach "$(WC_DMG)" -noautoopen -quiet -mountpoint "$(WC_DIR)"
	for i in $(SOURCE_FILES); do  \
		rm -rf "$(WC_DIR)/$$i"; \
		ditto -rsrc "$(SOURCE_DIR)/$$i" "$(WC_DIR)/$$i"; \
	done
	#  The second grep:
	#   Tiger: Apple_HFS.  
	#   Leopard: 48465300-0000-11AA-AA11-00306543ECAC
	#   
	WC_DEV=`hdiutil info | grep "$(WC_DIR)" | grep $(DMG_HDIUTIL_GREP_STRING) | awk '{print $$1}'` && hdiutil detach $$WC_DEV -quiet -force
	rm -f "$(MASTER_DMG)" "$(FINAL_DMG)"
	hdiutil convert "$(WC_DMG)" -quiet -format UDBZ -o "$@"
	rm -rf $(WC_DIR)
	rm -rf $(WC_DMG)
	rm -rf $(TEMPLATE_DMG)
	mv "$(MASTER_DMG)" "$(FINAL_DMG)"
	@echo


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
	-rm -rf $(TEMPLATE_DMG) $(MASTER_DMG) $(WC_DMG) $(FINAL_DMG)
