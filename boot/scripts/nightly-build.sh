#!/bin/sh
#  Copyright 2008 Cadence Design Systems, Inc.
#  
#  Licensed under the Apache License, Version 2.0 (the ''License''); you may not use this file except in compliance with the License.  You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0

set -e

export DISPLAY=:87

print_log_files() {
	for l in *.log; do
		echo -n "$l" | tr -c '' '='; echo
		echo "$l"
		echo -n "$l" | tr -c '' '='; echo
		cat $l | tr \\r \\n
		echo
	done
}

nsvm() {
	if [ -e fatal-boot-error.log ] ; then
		if [ -z ${DRYRUN} ]; then
			print_log_files | mail newspeak-nightly@cadence.com -s "Failed: Nightly build ${BRANCH}"
		else
			tr \\r \\n < fatal-boot-error.log
		fi
		exit 1
	fi
	if [ -x ./vm/onebuild/build/nsvm-debug ] ; then
		./vm/onebuild/build/nsvm-debug "$@"
	else
		open -W "$@"
	fi
}

no_rep() {
	[ "${REP_HOST}" = . ]
}

do_svn() {
	no_rep && return
	echo svn "$@"
	\svn --no-auth-cache --username bootstrapper --password sbootstrappers --non-interactive "$@"
}

alias svn=do_svn

do_broken_svn() {
	no_rep && return
	echo svn "$@"
	\svn "$@"
}

alias lsvn=do_broken_svn

setup_vnc() {
    Xvnc -geometry 960x600 -depth 24 -localhost -desktop 'Nightly Build' -AlwaysShared -SecurityTypes=None -ac ${DISPLAY} &
    XVNC_PID=$(jobs -p %%)
    trap "kill ${XVNC_PID}" EXIT
    until xsetroot -solid '#4c4c4c'; do usleep 100; done
    metacity &
}

show_build_summary() {
	svn info *.tar.bz2 {,experimental-}{nsboot,${APPLICATION_NAME}}"-${BRANCH}."{image,changes} | grep -E '^URL:'
	grep changes nsboot"-${BRANCH}.log"
}

sigusr1_handler() {
	print_log_files | mail newspeak-nightly@cadence.com -s "Timed out: Nightly build ${BRANCH}"
	kill -HUP $$
}

add_apl() {
	APL=$(date +"Copy""right %Y Cadence Design Systems, Inc.

Licensed under the Apache License, Version 2.0 (the ''License''); you may not use this file except in compliance with the License.  You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0")
	APL1=$(echo "$APL" | ( IFS='' ; read -r ; echo "$REPLY"))
	(
		IFS=''
		while read -r file ; do
			case ${file} in
			*.sources )
		   		echo 'Not including' ${file} >&2
		   		;;
		    * )
				DEST="newspeak-${BRANCH}/${file#*/}"
				mkdir -p $(dirname "${DEST}")
	 			if grep -iE '\(c\)|[c]opyright|[i][p] issue|[s]queak ip' ${file} > /dev/null ; then
					if grep "${APL1}" ${file} > /dev/null ; then
						FILE_LIC=$(grep -a -C2 "${APL1}" ${file} | tail -3 | cut -c4- | tr -d \"\\r)
						if [[ "${FILE_LIC}" != "${APL}" && "Cop${FILE_LIC}" != "${APL}" && "Co${FILE_LIC}" != "${APL}" && "${FILE_LIC}" != "${APL} " && "${FILE_LIC}" != "${APL}. " ]]; then
							echo Existing 'copy''right' in ${file} >&2
							echo "Found '${FILE_LIC}'" >&2
							echo "Expected '${APL}'" >&2
						else
							case ${file} in
							*.st | *.cs )
								echo '"' > "${DEST}"
								echo "${APL}" | sed -e 's/^/   /' >> "${DEST}"
								echo '"!' >> "${DEST}"
								cat ${file} >> "${DEST}"
								;;
							*.ns? )
								echo '"' > "${DEST}"
								echo "${APL}" | sed -e 's/^/   /' >> "${DEST}"
								echo '"' >> "${DEST}"
								cat ${file} >> "${DEST}"
								;;
							esac
						fi
					else
						echo Existing 'copy''right' in ${file} >&2
						grep -iE '\(c\)|[c]opyright|[i][p] issue|[s]queak ip' ${file} >&2
					fi
					[ -e "${DEST}" ] || cp -p "${file}" "${DEST}"
				else
					case ${file} in
					*.st | *.cs )
						echo '"' > "${DEST}"
						echo "${APL}" | sed -e 's/^/   /' >> "${DEST}"
						echo '"!' >> "${DEST}"
						cat ${file} >> "${DEST}"
						;;
					*.ns? | *\=filelist | *\=timestamps )
						echo '"' > "${DEST}"
						echo "${APL}" | sed -e 's/^/   /' >> "${DEST}"
						echo '"' >> "${DEST}"
						cat ${file} >> "${DEST}"
						;;
					*.c | *.h | *.m )
						echo '/*' > "${DEST}"
						echo "${APL}" | sed -e 's/^/ * /' >> "${DEST}"
						echo ' */' >> "${DEST}"
						cat ${file} >> "${DEST}"
						;;
					*.gmk | */Makefile | *.in | *.spec )
						echo "${APL}" | sed -e 's/^/#  /' >> "${DEST}"
						cat ${file} >> "${DEST}"
						;;
					* )
						echo 'No copy''right added to' ${file} >&2
						cp -p ${file} "${DEST}"
						;;
					esac
				fi
				echo "${DEST}"
				;;
   			esac
   		done
	)
}

add_sql() {
	SQL="Licensed under the Squeak License (the ''License''); you may not use this file except in compliance with the License.  You may obtain a copy of the License at  http://www.squeak.org/SqueakLicense/"
	(
		IFS=''
		while read -r file ; do
			case ${file} in
			*.sources )
		   		echo 'Not including' ${file} >&2
		   		;;
		    * )
				DEST="ns-squeak-${BRANCH}/${file#*/}"
				mkdir -p $(dirname "${DEST}")
					case ${file} in
					*.st | *.cs )
						echo '"' > "${DEST}"
						echo "${SQL}" | sed -e 's/^/   /' >> "${DEST}"
						echo '"!' >> "${DEST}"
						cat ${file} >> "${DEST}"
						;;
					*.ns? | *\=filelist | *\=timestamps )
						echo '"' > "${DEST}"
						echo "${SQL}" | sed -e 's/^/   /' >> "${DEST}"
						echo '"' >> "${DEST}"
						cat ${file} >> "${DEST}"
						;;
					*.c | *.h | *.m )
						echo '/*' > "${DEST}"
						echo "${SQL}" | sed -e 's/^/ * /' >> "${DEST}"
						echo ' */' >> "${DEST}"
						cat ${file} >> "${DEST}"
						;;
					*.gmk | */Makefile | *.in | *.spec )
						echo "${SQL}" | sed -e 's/^/#  /' >> "${DEST}"
						cat ${file} >> "${DEST}"
						;;
					* )
						echo 'No copy''right added to' ${file} >&2
						cp -p ${file} "${DEST}"
						;;
					esac
				echo "${DEST}"
				;;
   			esac
   		done
	)
}


trap sigusr1_handler USR1

RESPIN="00"
if [ "$1" ]; then
    RESPIN="$1"
fi

if [ "$2" = --dry-run ]; then
	echo Dry run mode.
	DRYRUN=dryrun
fi

REPOSITORY='svn://'${REP_HOST:=.}
BOOT_TRUNK=${REPOSITORY}'/bootstrap/trunk'
eval $(date +'BUILD_YEAR=%Y;BUILD_year=%y;BUILD_MONTH=%m;BUILD_DAY=%d')
BRANCH="${BUILD_YEAR}-${BUILD_MONTH}-${BUILD_DAY}.${RESPIN}"
VERSION="${BUILD_year}.${BUILD_MONTH}.${BUILD_DAY}${RESPIN}"
NIGHTLY_LOC=${REPOSITORY}'/bootstrap/nightly'
SNAPSHOT_REV=$(svn info ${REPOSITORY} | awk '/^Revision:/ { print "-r" $2 }')
BOOT_IMAGE="nsboot-${BRANCH}.image"

if [ "${APPLICATION_NAME}" ] ; then
	APPLICATION_IMAGE="'${APPLICATION_NAME}-${BRANCH}.image'"
else
	APPLICATION_IMAGE="nil"
fi

(type -t Xvnc > /dev/null 2>&1) && setup_vnc > Xvnc.log 2>&1

if no_rep ; then
	SQUEAK_DIR=$(ls -1dtr ns-squeak-* | tail -1)
	NEWSPEAK_DIR=$(ls -1dtr newspeak-* | tail -1)
	mv "${SQUEAK_DIR}/changesets" .
	mv "${SQUEAK_DIR}/squeakpackages" .
	mv "${NEWSPEAK_DIR}/nspackages" .
	mv "${NEWSPEAK_DIR}/images" .
else
	svn -q co -N ${NIGHTLY_LOC} nightly
	cd nightly
	svn -q copy ${SNAPSHOT_REV} ${BOOT_TRUNK} ${BRANCH}
	cd ${BRANCH}
	svn -q mkdir ${REP_HOST}
	svn -q copy ${SNAPSHOT_REV} ${REPOSITORY}/packages ${REP_HOST}/packages
	svn -q copy ${SNAPSHOT_REV} ${REPOSITORY}/nspackages ${REP_HOST}/nspackages
	svn -q copy ${SNAPSHOT_REV} ${REPOSITORY}/squeakpackages ${REP_HOST}/squeakpackages
	svn -q copy ${SNAPSHOT_REV} ${REPOSITORY}/squeaktests ${REP_HOST}/squeaktests
	svn -q copy ${SNAPSHOT_REV} ${REPOSITORY}/vm/trunk vm
fi

echo "CrLfFileStream fileNamed: '${REP_HOST}/nspackages/NsBoot/NsBoot.st' do: [ :s | s fileIn]!" > doit.st
echo "NsBoot bootstrap: '${REP_HOST}' imageName: '${BOOT_IMAGE}' applicationName: ${APPLICATION_IMAGE}!" >> doit.st

if no_rep ; then
	true
else
	echo Producing source bundle...
	mkdir newspeak
	mkdir newspeak-${BRANCH}
	mkdir ns-squeak
	mkdir ns-squeak-${BRANCH}
	ln -s ../${REP_HOST}/squeakpackages ns-squeak
	ln -s ../${REP_HOST}/nspackages newspeak
	ln -s ../changesets ns-squeak
	ln -s ../images newspeak
	# ln -s ../vm newspeak
	ln -s ../vm/platforms/Cross/plugins/IA32ABI newspeak
	ln -s ../vm/onebuild newspeak
	svn -q export ${BOOT_TRUNK}/nightly-build.sh newspeak/nightly-build.sh
	find newspeak/nightly-build.sh newspeak/*/* \( -name \.svn -o -name =versioninfo\* -o -name \*_proprietary \) -prune -o -type f -print | add_apl | tar --numeric-owner -jc -T - -f newspeak-${BRANCH}.tar.bz2
	find ns-squeak/*/* \( -name \.svn -o -name =versioninfo\* -o -name \*_proprietary \) -prune -o -type f -print | add_sql | tar --numeric-owner -jc -T - -f ns-squeak-${BRANCH}.tar.bz2
	lsvn -q add newspeak-${BRANCH}.tar.bz2 ns-squeak-${BRANCH}.tar.bz2
	echo Producing source bundle...done
fi

if [ -d vm/onebuild ] ; then
	echo Building vm...
	make -C vm/onebuild VERSION=${VERSION} IMAGE_IN_EXE=no binaries > make.log 2>&1
	echo Building vm...done
fi

echo 'Bootstrap phase 1...'
nsvm NsBootStarter.image
echo 'Bootstrap phase 1...done'

if [ "${APPLICATION_NAME}" ] ; then
	echo 'Bootstrap phase 2 (experimental '${APPLICATION_NAME}')...'
	nsvm ${BOOT_IMAGE}
	echo 'Bootstrap phase 2 (experimental '${APPLICATION_NAME}')...done'
	
	echo 'Bootstrap phase 2 ('${APPLICATION_NAME}')...'
	nsvm ${BOOT_IMAGE}
	echo 'Bootstrap phase 2 ('${APPLICATION_NAME}')...done'

	echo 'Bootstrap phase 2 (nsboot)...'
	nsvm ${BOOT_IMAGE}
	echo 'Bootstrap phase 2 (nsboot)...done'
	
	echo 'Bootstrap phase 2 (experimental nsboot)...'
	nsvm experimental-${BOOT_IMAGE}
	echo 'Bootstrap phase 2 (experimental nsboot)...done'
else
	echo 'Bootstrap phase 2 (nsboot)...'
	nsvm ${BOOT_IMAGE}
	echo 'Bootstrap phase 2 (nsboot)...done'
	
	echo 'Bootstrap phase 2 (experimental nsboot)...'
	nsvm ${BOOT_IMAGE}
	echo 'Bootstrap phase 2 (experimental nsboot)...done'
fi

lsvn -q revert NsBootStarter.changes
lsvn -q add {,experimental-}{nsboot,${APPLICATION_NAME}}"-${BRANCH}."{image,changes,log} make.log

if [ -z ${DRYRUN} ]; then
	svn -q ci -m "Nightly build ${BRANCH}"
	show_build_summary | mail newspeak-nightly@cadence.com -s "Nightly build ${BRANCH}"
else
	show_build_summary
fi

if [ -z ${DRYRUN} ]; then
	cd ..
	rm -rf ${BRANCH}
fi
