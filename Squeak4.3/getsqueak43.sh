#!/bin/bash
. ./envvars.sh

IMAGEHASH=43e2a17f4ae24481c1f9a82f3f2087d2
ZIPHASH=bb1bdc44981de59565947412c8ce4097

if [ ! -f Squeak4.3/Squeak4.3.image -o "`quietmd5 Squeak4.3/Squeak4.3.image`" != $IMAGEHASH ]; then
	ZIP=Squeak4.3.zip
	if [ "`quietmd5 $ZIP`" != $ZIPHASH ]
	then
		geturl http://ftp.squeak.org/4.3/$ZIP
	fi
	unzip -o $ZIP
fi
if [ ! -f SqueakV41.sources ]; then
	geturl http://ftp.squeak.org/sources_files/SqueakV41.sources.gz
	gunzip SqueakV41.sources.gz
fi
