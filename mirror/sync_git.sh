#!/bin/bash

GIT_ARRAY=(
	"android/u-boot/u-boot.git"
	"kernel/linux.git" 
	"tkboy/android-doc.git"
	"android/tools/git-repo.git"
	"android/kernel/common.git"
	"other/CHMLib.git"
	"other/crengine.git"
	"other/djvulibre.git"
	"other/mupdf.git"
	"other/poppler.git"
	"cyanogenMod/kernel/cm-kernel.git"
	)

REPO_ARRAY=(
	"cyanogenMod"
	)

ROOT_PATH=`pwd`

echo ""
echo "starting sync..."
echo "------------------------------"

for URL in ${GIT_ARRAY[@]}
do
	echo -e "\033[1m""SYNC $URL""\033[0m"
	git --git-dir=$URL fetch
done

echo "------------------------------"

for RURL in ${REPO_ARRAY[@]}
do
	echo -e "\033[1m""SYNC REPO $RURL""\033[0m"
	echo "------------------------------"
	cd $RURL
	repo sync -j16
	cd $ROOT_PATH
	echo "------------------------------"
done


echo "sync finished!"
echo ""

