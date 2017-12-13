#!/bin/bash
# Jongseok,Park (js0526.park@samsung.com)

choice=$1
echo "You selected target $choice"

declare -a targets=("bsp" "genivi" "virt_dom0" "virt_domu" "gdp")
declare -a variables=("choice" "modules" "targets" "variables")

# saving scripts and yocto root directories
SCRIPTSWD=${PWD}
pushd ../../ > /dev/null
YOCTOROOTWD=${PWD}
popd > /dev/null

if test -z "$choice" ; then
# we assume default target is genivi
choice=genivi

#   echo "[ERROR] An invalid target name was given of $choice, available targets are:"
#   printf '%s\n' "${targets[@]}"
#   unset "${variables[@]}"
#   echo "Usage: source init.sh target"
#   return
fi
#--------------------------------------------------------
#git submodule synchronization
#--------------------------------------------------------
#modules=($(git submodule | awk '{ print $2 }'))
#git submodule init "${modules[@]}"
#git submodule sync "${modules[@]}"
#git submodule update "${modules[@]}"

#--------------------------------------------------------
#run each target environment
#--------------------------------------------------------
if [ "$choice" == "bsp" ] || [ "$choice" == "genivi" ] || [ "$choice" == "virt_dom0" ] ; then
  echo "Building GENIVI based on Samsung Automotive BSP"

	#renaming some files to avoid compile error for genivi
	if [ -f "${YOCTOROOTWD}/meta-ivi/meta-ivi-test/recipes-multimedia/audiomanager/AudioManagerPlugins_%.bbappend" ]
	then
		echo "renaming file 1"
		mv ${YOCTOROOTWD}/meta-ivi/meta-ivi-test/recipes-multimedia/audiomanager/AudioManagerPlugins_%.bbappend ${YOCTOROOTWD}/meta-ivi/meta-ivi-test/recipes-multimedia/audiomanager/audiomanagerplugins_%.bbappend
	fi


	if [ -d "${YOCTOROOTWD}/meta-ivi/meta-ivi-test/recipes-multimedia/audiomanager/AudioManagerPlugins" ]
	then
		echo "renaming file 2"
		mv ${YOCTOROOTWD}/meta-ivi/meta-ivi-test/recipes-multimedia/audiomanager/AudioManagerPlugins ${YOCTOROOTWD}/meta-ivi/meta-ivi-test/recipes-multimedia/audiomanager/audiomanagerplugins
	fi

	if [ -f "${YOCTOROOTWD}/meta-ivi/meta-ivi-test/recipes-multimedia/audiomanager/audiomanagerplugins/AudioManagerPlugins_t.inc" ]
	then
		echo "renaming file 3"
		mv ${YOCTOROOTWD}/meta-ivi/meta-ivi-test/recipes-multimedia/audiomanager/audiomanagerplugins/AudioManagerPlugins_t.inc ${YOCTOROOTWD}/meta-ivi/meta-ivi-test/recipes-multimedia/audiomanager/audiomanagerplugins/audiomanagerplugins_t.inc
	fi

	if [ -f "${YOCTOROOTWD}/meta-ivi/meta-ivi-test/recipes-core-ivi/vsomeip/vsomeip_%.bbappend" ]
	then
		echo "renaming file 4"
		mv ${YOCTOROOTWD}/meta-ivi/meta-ivi-test/recipes-core-ivi/vsomeip/vsomeip_%.bbappend ${YOCTOROOTWD}/meta-ivi/meta-ivi-test/recipes-core-ivi/vsomeip/vsomeip_%.bbappend.bak
	fi

#export TEMPLATECONF=`pwd`/meta-ivi/meta-ivi/conf

	# local patch to avoid build error when we use Mali recipe with PACKAGE_CLASSES=package-ipk
	#cp conf/genivi/0001-added-temporary-remove-code-to-avoid-error-when-PACK.patch ./meta-ivi/
	#cd meta-ivi
	#patch -p1 -f < 0001-added-temporary-remove-code-to-avoid-error-when-PACK.patch
	#rm 0001-added-temporary-remove-code-to-avoid-error-when-PACK.patch
	#cd ..

	# Apply patch for fixing failure fetcher genivi error + Samsung pack error
	pushd ${YOCTOROOTWD}/meta-ivi > /dev/null
	git apply ${SCRIPTSWD}/conf/genivi/0001-added-temporary-remove-code-to-avoid-error-when-PACK.patch
	git apply ${SCRIPTSWD}/conf/genivi/0001-Fixing-fetcher-failure-error-for-genivi-repositories.patch
	git apply ${SCRIPTSWD}/conf/genivi/0002-Disabling-CONNECTIVITY_CHECK_URIS-for-checking-geniv.patch
	git apply ${SCRIPTSWD}/conf/genivi/0003-Removing-audiomanager-from-packagegroup-abstract-com.patch

	# Apply patch for Artifactory access
	cd ${YOCTOROOTWD}/poky > /dev/null
	git apply ${SCRIPTSWD}/conf/genivi/0001-TTXLOG-744-Add-fetcher-for-Artifactory.patch
	popd > /dev/null

	if [ "$choice" == "bsp" ] ; then
		echo "Building Baremetal Samsung Automotive BSP"
		export TEMPLATECONF=${SCRIPTSWD}/conf/bsponly
		source ${YOCTOROOTWD}/poky/oe-init-build-env ${YOCTOROOTWD}/build.bsp
	        echo "GERRIT_ID = \"${GERRIT_ID}\"" >> ${YOCTOROOTWD}/build.bsp/conf/local.conf
        elif [ "$choice" == "genivi" ] ; then
  		export TEMPLATECONF=${SCRIPTSWD}/conf/genivi
		source ${YOCTOROOTWD}/poky/oe-init-build-env ${YOCTOROOTWD}/build.genivi
        	echo "GERRIT_ID = \"${GERRIT_ID}\"" >> ${YOCTOROOTWD}/build.genivi/conf/local.conf

        elif [ "$choice" == "virt_dom0" ] ; then
  		echo "Additionally Building virt-dom0 "
		export TEMPLATECONF=${SCRIPTSWD}/conf/virt_dom0
		source ${YOCTOROOTWD}/poky/oe-init-build-env ${YOCTOROOTWD}/build_virt_dom0
        	echo "GERRIT_ID = \"${GERRIT_ID}\"" >> ${SCRIPTSWD}/conf/local.conf
        fi

elif [ "$choice" == "virt_domu" ] ; then
	export TEMPLATECONF=${SCRIPTSWD}/conf/virt_domu
	source ${YOCTOROOTWD}/poky/oe-init-build-env ${YOCTOROOTWD}/build_virt_domu
        echo "GERRIT_ID = \"${GERRIT_ID}\"" >> ${SCRIPTSWD}/conf/local.conf
        echo "QNX_SDP_PATH = \"${QNX_SDP_PATH}\"" >> ${SCRIPTSWD}/conf/local.conf

elif [ "$choice" == "gdp" ] ; then
   echo "Building GDP based on Samsung Automotive BSP (NOT YET !!)"
#
# not yet
#
fi

unset "${variables[@]}"

echo "$ bitbake miranda-image"
