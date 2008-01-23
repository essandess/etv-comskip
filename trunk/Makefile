dist:
	pushd src/FileWatcher; make; make clean; popd
	pushd src/comskip; make; make clean; popd
	mkdir -p FileWatcher.app/Contents/Resources
	mkdir -p FileWatcher.app/Contents/PlugIns
	cp MarkCommercials.sh EyeTVReaper.scpt comskip comskip.ini FileWatcher.app/Contents/Resources
	cp PurgeList.txt FileWatcher.app/Contents/PlugIns #FIXME this should just go in ~/Library/Application\ Support/ETVComskip rather than in the bundle
	mv PurgeList.txt ..
	mv PurgeList.txt.dist PurgeList.txt
	pushd ..; tar --exclude .svn -czvf ETVComskip${VERSION}.tar.gz ETVComskip; popd
	mv PurgeList.txt PurgeList.txt.dist
	mv ../PurgeList.txt .
