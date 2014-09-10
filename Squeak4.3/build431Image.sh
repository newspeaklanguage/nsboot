#!/bin/bash
# Load 4.3. compress changes and save. Write Spur packages to package-cache

. ./getGoodCogNsvm.sh

cp -p Squeak4.3/Squeak4.3.image Squeak4.3/Squeak4.3.changes .
rm -f Squeak4.3.1.image Squeak4.3.1.changes
"`pwd`/$VM" -headless Squeak4.3.image CompressAndSaveAs431.st
"`pwd`/$VM" -headless Squeak4.3.image GetSpurPackagesInPackageCache.st
