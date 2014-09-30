#!/bin/sh -e

IM=nsboot-`date +%Y-%m-%d`
IMAGE=$IM.image
CHANGES=$IM.changes
HEADLESS=-headless
#HEADLESS=
TIME=
EXTRAARGS=
USEGDB=
SCRIPT=NewspeakBootstrap.st

USAGE="usage: `basename $0` -[h?] [-v vm] [-p path] [-P]"
NSVM=nsspurcfvm

while getopts 'a:v:p:gPuht?' opt "$@"; do
	case "$opt" in
	a)		EXTRAARGS="$OPTARG";;
	g)		USEGDB=1;;
	v)		NSVM="$OPTARG";;
	h)		HEADLESS="";;
	p)		IMAGEPATH="$OPTARG";;
	P)		SCRIPT=NewspeakBootstrap-partial.st;;
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

cp -p Squeak4.3/Squeak4.3.1-spur.image $IMAGE
cp -p Squeak4.3/Squeak4.3.1-spur.changes $CHANGES

if [ -z "$USEGDB" ]; then
	echo "$NSVM" $HEADLESS $EXTRAARGS $IMAGE $SCRIPT
	$TIME "$NSVM" $HEADLESS $EXTRAARGS $IMAGE $SCRIPT
else
	echo run $HEADLESS $EXTRAARGS $IMAGE $SCRIPT
	gdb "$NSVM"
fi
