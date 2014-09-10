#!/bin/sh
. ./envvars.sh

TRUNKSPUR=http://www.mirandabanda.org/files/Cog/SpurImages/trunk46-spur

if [ ! -f trunk46-spur.image -o ! -f trunk46-spur.changes ]; then
	geturl $TRUNKSPUR.image
	geturl $TRUNKSPUR.changes
fi

. ./getGoodSpurVM.sh

if [ ! -f SpurVMMaker.image -o ! SpurVMMaker.changes ]; then
	trap 'rm -f SpurVMMaker.image SpurVMMaker.changes; exit 2' HUP INT PIPE TERM

	cp -p trunk46-spur.image SpurVMMaker.image
	cp -p trunk46-spur.changes SpurVMMaker.changes

	./resizesqueakwindow SpurVMMaker.image 800 640

	echo $VM SpurVMMaker.image BuildSqueakTrunkVMMakerImage.st
	$VM SpurVMMaker.image BuildSqueakTrunkVMMakerImage.st
fi
