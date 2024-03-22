#!/bin/bash

rm -rf packages/services/Car/ packages/apps/CellBroadcastReceiver/ packages/apps/Traceur/ packages/apps/TvSettings/ packages/apps/Updater/ frameworks/base/
# init and sync
rm -rf .repo/local_manifests
repo init -u https://github.com/LeafOS-Project/android.git -b leaf-3.1
git clone https://github.com/xyz-sundram/local_manifest.git -b leaf .repo/local_manifests
repo sync -c --no-clone-bundle --optimized-fetch --prune --force-sync -j$(nproc --all)

# source patches
cd hardware/qcom-caf/common/
curl https://github.com/xyz-sundram/android_hardware_qcom-caf_common/commit/99fb248c6f67772c44686f5b117c911ffd70fd6f.patch | git am
cd ../../..

# build rom
source build/envsetup.sh
export SELINUX_IGNORE_NEVERALLOWS=true
lunch tulip-userdebug
m leaf
