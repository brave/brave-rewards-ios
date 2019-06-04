#!/bin/bash

set -xe

current_dir="`pwd`/`dirname $0`"
framework_drop_point="$current_dir/../lib"

skip_update=0
clean=0
brave_browser_dir="${@: -1}"

function usage() {
  echo "Usage: ./build_in_core.sh [--skip-update] [--clean] {\$home/brave/brave-browser}"
  echo " --skip-update:   Does not pull down any brave-core/brave-browser changes"
  echo " --clean:         Cleans build directories before building"
  exit 1
}

for i in "$@"
do
case $i in
    -h|--help)
    usage
    ;;
    --skip-update)
    skip_update=1
    shift
    ;;
    --clean)
    clean=1
    shift
    ;;
esac
done

if [ ! -d "$brave_browser_dir/src/brave" ]; then
  echo "Did not pass in a directory pointing to brave-browser which has already been init"
  echo "(by running \`npm run init\` at its root)"
  usage
fi

pushd $brave_browser_dir > /dev/null

if [ "$skip_update" = 0 ]; then
  # Make sure we rebase master to head
  git checkout -- "*" && git pull
  # Do the rest of the work in the src folder
  cd src
  # Update the deps
  npm run init -- --all --target_os=ios
else
  # Do the rest of the work in the src folder
  cd src
fi

# [ -d brave/vendor/brave-rewards-ios ] && rm -r brave/vendor/brave-rewards-ios
# rsync -a --delete "$current_dir/../" brave/vendor/brave-rewards-ios

# TODO: Check if there are any changes made to any of the dependent vendors via git. If no files are changed,
#       we can just skip building altogether

if [ "$clean" = 1 ]; then
  # If this script has already been run, we'll clean out the build folders
  [[ -d out/sim-release ]] && gn clean out/sim-release
  [[ -d out/device-release ]] && gn clean out/device-release
fi

npm run build -- Release --target_os=ios
npm run build -- Release --target_os=ios --target_arch=arm64

# Copy the framework structure (from iphoneos build) to the universal folder
cp -R "out/ios_Release_arm64/BraveRewards.framework" "$framework_drop_point/"
# cp -R "out/device-release/BraveRewards.dSYM" "$framework_drop_point/BraveRewards.framework.dSYM"

# Create universal binary file using lipo and place the combined executable in the copied framework directory
lipo -create -output "$framework_drop_point/BraveRewards.framework/BraveRewards" "out/ios_Release/BraveRewards.framework/BraveRewards" "out/ios_Release_arm64/BraveRewards.framework/BraveRewards"

echo "Created FAT framework: $framework_drop_point/BraveRewards.framework"

# cd brave
brave_core_build_hash=`git rev-parse HEAD`

cd ..

brave_browser_build_hash=`git rev-parse HEAD`

popd > /dev/null

echo "Completed building BraveRewards from \`brave-core/$brave_core_build_hash\`"
sed -i '' -e "s/brave-core\/[A-Za-z0-9]*/brave-core\/$brave_core_build_hash/g" "$current_dir/../README.md"
sed -i '' -e "s/brave-browser\/[A-Za-z0-9]*/brave-browser\/$brave_browser_build_hash/g" "$current_dir/../README.md"
echo "  → Updated \`README.md\` to reflect updated library builds"

# Check if any of the includes had changed.
if `git diff --quiet "$framework_drop_point/BraveRewards.framework/Headers/"`; then
  echo "  → No updates to library includes were made"
else
  echo "  → Changes found in library includes"
fi
