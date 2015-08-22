#!/bin/sh -ex

IM=ns-`date +%Y-%m-%d`.64
IMAGE=$IM.image
CHANGES=$IM.changes
IMAGEPATH="./out"
ZIP=$IM.zip
HEADLESS=-headless

USAGE="usage: `basename $0` -[h?] [-v vm] [-p path] [-u]"
NSVM=
NOZIP=
TEST=

while getopts 'v:p:uth?' opt "$@"; do
	case "$opt" in
	v)		NSVM="$OPTARG";;
	h)		HEADLESS="";;
	p)		IMAGEPATH="$OPTARG";;
	u)		NOZIP="1";;
	t)		TEST="1";;
	\?|*)	echo $USAGE
			echo '	boot newspeak'
			echo '	-h: run headful, not headless'
			echo '	-v vm: use the supplied VM instead of the default'
			echo '	-p path: where you want the generated image to be placed (default: $IMAGEPATH)'
			echo '	-u: unpacked - do not zip (package) the image. Just generate the .image and .changes file.'
			echo '	-t: run tests'
			echo '	-?: display this help'
			test "$opt" = "\?" && exit 0;
			exit 1;;
	esac
done

if [ -z "$NSVM" ]; then
	case `uname -s` in
	Linux) NSVM=/usr/lib/nsvm/nsvm;;
	Darwin) NSVM="/Applications/Newspeak Spur Virtual Machine.app/Contents/MacOS/Newspeak Virtual Machine";;
	*) NSVM=../nsvm/nsvm;;
	esac
fi

cp -p Squeak5.0-15113/Squeak5.0-15113-64.image $IMAGE
cp -p Squeak5.0-15113/Squeak5.0-15113-64.changes $CHANGES
cp -p Squeak5.0-15113/SqueakV50.sources .

"$NSVM" $HEADLESS $COG_FLAGS $IMAGE NewspeakBootstrap.st

if [ ! -z "$TEST" ]; then
    "$NSVM" $HEADLESS $COG_FLAGS $IMAGE NewspeakTests.st
fi

if [ -z "$NOZIP" ]; then
	hg --cwd ../newspeak tip > newspeaktip
	hg --cwd ../nsboot tip > nsboottip

	zip $ZIP $IMAGE $CHANGES newspeaktip nsboottip
	mkdir -p $IMAGEPATH || true
	mv $ZIP $IMAGEPATH
else
	mkdir -p $IMAGEPATH || true
	cp -f $IMAGE   "$IMAGEPATH/$IMAGE"
	cp -f $CHANGES "$IMAGEPATH/$CHANGES"
	echo "\n"
        echo "`pwd`/$IMAGEPATH/$IMAGE"
fi