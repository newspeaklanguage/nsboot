#!/bin/sh

IM=nsboot-`date +%Y-%m-%d`
IMAGE=$IM.image
CHANGES=$IM.changes
ZIP=$IM.zip
HEADLESS=-headless

USAGE="usage: `basename $0` -[h?] [-v vm]"
NSVM=

while getopts 'v:h?' opt "$@"; do
	case "$opt" in
	v)		NSVM="$OPTARG";;
	h)		HEADLESS="";;
	\?|*)	echo $USAGE
			echo '	boot newspeak'
			echo '	-h: run headful, not headless'
			echo '	-v vm: use the supplied VM instead of the default'
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

wget -c http://ftp.squeak.org/4.3/Squeak4.3.zip
rm -r Squeak4.3
unzip Squeak4.3.zip
mv Squeak4.3/Squeak4.3.image $IMAGE
mv Squeak4.3/Squeak4.3.changes $CHANGES

"$NSVM" $HEADLESS $IMAGE NewspeakBootstrap.st

hg --cwd ../newspeak tip > newspeaktip
hg --cwd ../nsboot tip > nsboottip

zip $ZIP $IMAGE $CHANGES newspeaktip nsboottip
mkdir ../bootimages
mv $ZIP ../bootimages
rm $IMAGE $CHANGES newspeaktip nsboottip

date

