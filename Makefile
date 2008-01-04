dist:
	mv PurgeList.txt ..
	mv PurgeList.txt.dist PurgeList.txt
	pushd src/FileWatcher; make; make clean; popd
	pushd src/comskip; make; make clean; popd
	pushd ..; tar --exclude .svn -czvf ETVComskip${VERSION}.tar.gz ETVComskip; popd
	mv PurgeList.txt PurgeList.txt.dist
	mv ../PurgeList.txt .
