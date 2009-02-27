#!/bin/sh

SQUEAK_BASE=Squeak3.9-final-7067

if [ -z "${NSREPO}" ]; then
    echo "${0}: NSREPO is undefined." >&2
    exit 1
fi

if [ -z "${NSVMREPO}" ]; then
    echo "${0}: NSVMREPO is undefined." >&2
    exit 1
fi

function inflate() {
    unzip -u "$@" -x "__MACOSX*" "*.DS_Store" > /dev/null
}

function run_nsvm() {
    if [ -z "$(type -p nsvm)" ]; then
        SAVED_DISPLAY="${DISPLAY}"
        unset DISPLAY 
        '/Applications/Newspeak Virtual Machine.app/Contents/MacOS/nsvm' "$@"
        DISPLAY="${SAVED_DISPLAY}"
    else
        nsvm "$@"
    fi
}

set -e -x

[ -e "${SQUEAK_BASE}.zip" ] || curl "http://ftp.squeak.org/3.9/${SQUEAK_BASE}.zip" -o "${SQUEAK_BASE}.zip"

rm -rf build || true
mkdir -p build || true
cd build

inflate "../${SQUEAK_BASE}.zip"

ln "../scripts/nightly-build.sh" .

svn export --native-eol CR "${NSREPO}/nspackages/NsBoot/NsBootStarter.st"

ln "${SQUEAK_BASE}/SqueakV39.sources" .
ln "${SQUEAK_BASE}/${SQUEAK_BASE}.image" NsBootStarter.image
ln "${SQUEAK_BASE}/${SQUEAK_BASE}.changes" NsBootStarter.changes
ln -s ../images .

run_nsvm NsBootStarter.image "file://$(pwd)/NsBootStarter.st"

sh nightly-build.sh 00

exit

(cd "newspeak-${RELEASE}" ; find vm | cpio -p -l -d ..)
ln vm/onebuild/SqueakV39.sources .
ln ${SQUEAK_BASE}/${SQUEAK_BASE}.image NsBootStarter.image
ln ${SQUEAK_BASE}/${SQUEAK_BASE}.changes NsBootStarter.changes

make -C vm/onebuild -f nsvm.gmk binaries "VERSION=${RELEASE}" > make.log 2>&1

vm/onebuild/build/nsvm-debug NsBootStarter.image "file://$(pwd)/newspeak-${RELEASE}/nspackages/NsBoot/NsBootStarter.st"

sh nightly-build.sh 00
