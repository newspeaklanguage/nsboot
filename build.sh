#!/bin/sh -e

IM=nsboot-`date +%Y-%m-%d`
IMAGE=$IM.image
CHANGES=$IM.changes
IMAGEPATH="../bootimages"
ZIP=$IM.zip
HEADLESS=-headless

USAGE="usage: `basename $0` -[h?] [-v vm] [-p path] [-u]"
NSVM=
NOZIP=

while getopts 'v:p:uh?' opt "$@"; do
	case "$opt" in
	v)		NSVM="$OPTARG";;
	h)		HEADLESS="";;
	p)		IMAGEPATH="$OPTARG";;
	u)		NOZIP="1";;
	\?|*)	echo $USAGE
			echo '	boot newspeak'
			echo '	-h: run headful, not headless'
			echo '	-v vm: use the supplied VM instead of the default'
			echo '	-p path: where you want the generated image to be placed (default: $IMAGEPATH)'
			echo '	-u: unpacked - do not zip (package) the image. Just generate the .image and .changes file.'
			echo '	-?: display this help'
			test "$opt" = "\?" && exit 0;
			exit 1;;
	esac
done

if [ -z "$NSVM" ]; then
	case `uname -s` in
	Linux) NSVM=/usr/lib/nsvm/nsvm;;
	Darwin) NSVM="/Applications/Newspeak Virtual Machine.app/Contents/MacOS/Newspeak Virtual Machine";;
	*) NSVM=../nsvm/nsvm;;
	esac
fi

date

case `uname -s` in
Darwin) curl -C - http://ftp.squeak.org/4.3/Squeak4.3.zip -o Squeak4.3.zip || true;;
*) wget -c http://ftp.squeak.org/4.3/Squeak4.3.zip || true;;
esac

rm -rf Squeak4.3
unzip Squeak4.3.zip
mv Squeak4.3/Squeak4.3.image $IMAGE
mv Squeak4.3/Squeak4.3.changes $CHANGES

"$NSVM" $HEADLESS $IMAGE NewspeakBootstrap.st

if [ -z "$NOZIP" ]; then
	hg --cwd ../newspeak tip > newspeaktip
	hg --cwd ../nsboot tip > nsboottip

	zip $ZIP $IMAGE $CHANGES newspeaktip nsboottip
	mkdir -p $IMAGEPATH || true
	mv $ZIP $IMAGEPATH
	rm $IMAGE $CHANGES $CHANGES.old newspeaktip nsboottip
	date # date output might be used for deployment scripts. if not, remove this line
else
	mkdir -p $IMAGEPATH || true
	cp -f $IMAGE   "$IMAGEPATH/$IMAGE"
	cp -f $CHANGES "$IMAGEPATH/$CHANGES"
	rm $IMAGE $CHANGES $CHANGES.old
	echo "\n"
        echo "`pwd`/../bootimages/$IMAGE"
fi
