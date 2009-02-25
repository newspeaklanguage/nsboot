#!/bin/sh

RELEASE=2008-10-31.00
SQUEAK_BASE=Squeak3.9-final-7067

set -e -x

[ -e "${SQUEAK_BASE}.zip" ] || wget "http://ftp.squeak.org/3.9/${SQUEAK_BASE}.zip"

rm -rf build || true
mkdir -p build || true
cd build

unzip -u "../${SQUEAK_BASE}.zip" -x "__MACOSX*" "*.DS_Store" > /dev/null
unzip -u "../newspeak-${RELEASE}.zip" -x "__MACOSX*" "*.DS_Store" > /dev/null
unzip -u "../ns-squeak-${RELEASE}.zip" -x "__MACOSX*" "*.DS_Store" > /dev/null

ln "newspeak-${RELEASE}/nightly-build.sh" .
(cd "newspeak-${RELEASE}" ; find vm | cpio -p -l -d ..)
ln vm/onebuild/SqueakV39.sources .
ln ${SQUEAK_BASE}/${SQUEAK_BASE}.image NsBootStarter.image
ln ${SQUEAK_BASE}/${SQUEAK_BASE}.changes NsBootStarter.changes

make -C vm/onebuild -f nsvm.gmk binaries "VERSION=${RELEASE}" > make.log 2>&1

vm/onebuild/build/nsvm-debug NsBootStarter.image "file://$(pwd)/newspeak-${RELEASE}/nspackages/NsBoot/NsBootStarter.st"

sh nightly-build.sh 00
