#!/bin/sh
. ./envvars.sh

echo $VM SpurVMMaker.image BuildSpur431Image.st
$VM SpurVMMaker.image BuildSpur431Image.st

./resizesqueakwindow Squeak4.3.1-spur.image 800 640

echo $VM Squeak4.3.1-spur.image LoadSpurPackagesFromTempDir.st
$VM Squeak4.3.1-spur.image LoadSpurPackagesFromTempDir.st
