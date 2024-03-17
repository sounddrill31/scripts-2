#!/bin/bash

# init and sync
rm -rf .repo/local_manifests
repo init -u https://github.com/RisingTechOSS/android -b fourteen --git-lfs
git clone https://github.com/xyz-sundram/local_manifest.git -b rising .repo/local_manifests
repo sync -c --no-clone-bundle --optimized-fetch --prune --force-sync -j$(nproc --all)

rm -rf hardware/qcom-caf/common/
git clone https://github.com/xyz-sundram/android_hardware_qcom-caf_common.git hardware/qcom-caf/common/

cd system/libhidl 
git fetch https://github.com/Evolution-X/system_libhidl f93f60fa2b93b6ff1699f1cfc6e3192fcbe7f36e
git cherry-pick f93f60fa2b93b6ff1699f1cfc6e3192fcbe7f36e
cd ../..

# build rom
source build/envsetup.sh
export SELINUX_IGNORE_NEVERALLOWS=true
lunch rising_tulip-userdebug
mka bacon
