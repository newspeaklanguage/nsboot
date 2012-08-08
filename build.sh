#!/bin/sh

IM=nsboot-`date +%Y-%m-%d`
IMAGE=$IM.image
CHANGES=$IM.changes
ZIP=$IM.zip
HEADLESS=-headless
NSVM=../nsvm/nsvm

date

wget -c http://ftp.squeak.org/4.3/Squeak4.3.zip
rm -r Squeak4.3
unzip Squeak4.3.zip
mv Squeak4.3/Squeak4.3.image $IMAGE
mv Squeak4.3/Squeak4.3.changes $CHANGES

$NSVM $HEADLESS $IMAGE NewspeakBootstrap.st

hg --cwd ../newspeak tip > newspeaktip
hg --cwd ../nsboot tip > nsboottip

zip $ZIP $IMAGE $CHANGES newspeaktip nsboottip
mkdir ../bootimages
mv $ZIP ../bootimages
rm $IMAGE $CHANGES newspeaktip nsboottip

date

