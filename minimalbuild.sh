#!/bin/sh -e

IM=nsboot-`date +%Y-%m-%d`
IMAGE=$IM.image
CHANGES=$IM.changes
HEADLESS=-headless
HEADLESS=
TIME=

USAGE="usage: `basename $0` -[h?] [-v vm] [-p path] [-u]"
NSVM=nsspurcfvm

while getopts 'v:p:uht?' opt "$@"; do
	case "$opt" in
	v)		NSVM="$OPTARG";;
	h)		HEADLESS="";;
	p)		IMAGEPATH="$OPTARG";;
	t)		TIME=time;;
	\?|*)	echo $USAGE
			echo '	boot newspeak'
			echo '	-h: run headful, not headless'
			echo '	-v vm: use the supplied VM instead of the default'
			echo '	-p path: where you want the generated image to be placed (default: $IMAGEPATH)'
			echo '	-t: time the VM execution of the bootstrap'
			echo '	-u: unpacked - do not zip (package) the image. Just generate the .image and .changes file.'
			echo '	-?: display this help'
			test "$opt" = "\?" && exit 0;
			exit 1;;
	esac
done

date

cp -p Squeak4.3/Squeak4.3.3-spur.image $IMAGE
cp -p Squeak4.3/Squeak4.3.3-spur.changes $CHANGES

echo "$NSVM" $HEADLESS $IMAGE NewspeakBootstrap.st
$TIME "$NSVM" $HEADLESS $IMAGE NewspeakBootstrap.st
