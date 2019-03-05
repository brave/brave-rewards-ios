#!/bin/bash

set -e

current_dir="`pwd`/`dirname $0`"
ledger_drop_point="$current_dir/bat-native-ledger"
ads_drop_point="$current_dir/bat-native-ads"

skip_update=`[[ "$1" = "--skip-update" ]] && echo true || echo false`
brave_browser_dir="${@: -1}"

if [ ! -d "$brave_browser_dir/src/brave" ]; then
  echo "Did not pass in a directory pointing to brave-browser which has already been init"
  echo "(by running \`npm run init\` at its root)"
  echo "Example usage: ./gen_rewards_libs.sh [--skip-update] {\$home/brave/brave-browser}"
  exit 1
fi

pushd $brave_browser_dir > /dev/null

if [ "$skip_update" = false ]; then
  # Make sure we rebase master to head
  git checkout -- "*" && git pull
  # Update the deps
  npm run sync -- --all
fi

# Do the rest of the work in the src folder
cd src

# Have to dump the brave-browser/src patches until https://github.com/brave/brave-browser/issues/3080 is resolved
git reset --hard HEAD

# If this script has already been run, we'll clean out the build folders
[[ -d out/sim-release ]] && gn clean out/sim-release
[[ -d out/device-release ]] && gn clean out/device-release

# Generate ninja files for x86_64 and arm64 builds
#
# `root_extra_deps` may have to be extended if more deps from the `//brave` directory are added due to
# brave-browser#3080 mentioned above
gn gen out/sim-release \
  --args=" \
    is_debug = false \
    enable_ios_bitcode = true \
    use_xcode_clang = true \
    ios_deployment_target = \"12.0\" \
    treat_warnings_as_errors = false \
    enable_nacl = false \
    enable_stripping = true \
    is_official_build = true \
    symbol_level = 2 \
    is_chrome_branded = false \
    target_os=\"ios\" \
    target_cpu=\"x64\" \
    root_extra_deps = [ \
      \"//brave/vendor/bat-native-anonize:anonize2\", \
      \"//brave/vendor/bat-native-ledger:bat-native-ledger-standalone\", \
      \"//brave/vendor/bat-native-rapidjson\", \
      \"//brave/vendor/bat-native-tweetnacl:tweetnacl\", \
      \"//brave/vendor/bip39wally-core-native:bip39wally-core\", \
      \"//brave/vendor/challenge_bypass_ristretto_ffi\", \
      \"//brave/vendor/bat-native-ads:bat-native-ads-standalone\", \
      \"//brave/vendor/bat-native-confirmations:challenge_bypass_libs\" \
    ]"

gn gen out/device-release \
  --args=" \
    is_debug = false \
    enable_ios_bitcode = true \
    use_xcode_clang = true \
    ios_deployment_target = \"12.0\" \
    treat_warnings_as_errors = false \
    enable_nacl = false \
    enable_stripping = true \
    is_official_build = true \
    symbol_level = 2 \
    is_chrome_branded = false \
    target_os=\"ios\" \
    target_cpu=\"arm64\" \
    root_extra_deps = [ \
      \"//brave/vendor/bat-native-anonize:anonize2\", \
      \"//brave/vendor/bat-native-ledger:bat-native-ledger-standalone\", \
      \"//brave/vendor/bat-native-rapidjson\", \
      \"//brave/vendor/bat-native-tweetnacl:tweetnacl\", \
      \"//brave/vendor/bip39wally-core-native:bip39wally-core\", \
      \"//brave/vendor/challenge_bypass_ristretto_ffi\", \
      \"//brave/vendor/bat-native-ads:bat-native-ads-standalone\", \
      \"//brave/vendor/bat-native-confirmations:challenge_bypass_libs\" \
    ]"

# Build both ledger and ads for both sim/device
ninja -C out/sim-release bat-native-ledger-standalone bat-native-ads-standalone
ninja -C out/device-release bat-native-ledger-standalone bat-native-ads-standalone

# Create fat binaries of each
lipo -create out/sim-release/libbat-native-ledger-standalone.a \
             out/device-release/libbat-native-ledger-standalone.a \
             -output "$ledger_drop_point/libbat-native-ledger.a"

lipo -create out/sim-release/libbat-native-ads-standalone.a \
             out/device-release/libbat-native-ads-standalone.a \
             -output "$ads_drop_point/libbat-native-ads.a"

lipo -create out/sim-release/gen/challenge_bypass_ristretto/out/x86_64-apple-ios/release/libchallenge_bypass_ristretto.a \
             out/device-release/gen/challenge_bypass_ristretto/out/aarch64-apple-ios/release/libchallenge_bypass_ristretto.a \
             -output "$ledger_drop_point/libchallenge_bypass_ristretto.a"

# Optionally we could run them through strip, but not sure if needed of if it would 
# effect the build
# strip -x libbat-native-ads.a -o libbat-native-ads.a
# strip -x libbat-native-ledger.a -o libbat-native-ledger.a
# strip -x libchallenge_bypass_ristretto.a -o libchallenge_bypass_ristretto.a

# Copy include headers over. If these libraries ever begin to include Chromium dependencies–such as `base`–
# in public headers we will also need to copy over those headers
rsync -a --delete brave/vendor/bat-native-ledger/include/ "$ledger_drop_point/include/"
rsync -a --delete brave/vendor/bat-native-ads/include/ "$ads_drop_point/include/"

popd > /dev/null
