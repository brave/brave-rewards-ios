# brave-rewards-ios

A framework for consuming Brave Rewards on [brave-ios](https://github.com/brave/brave-ios)

Latest ledger/ads implementations were built around libraries compiled from brave-core/8d11e597677496a02332a223a7fdd15607a46ff3 (`libbat-native-ads.a`, `libbat-native-ledger.a`, and `libchallenge_bypass_ristretto.a`)

These libraries are too large to include in the repo, therefore you must clone http://github.com/brave/brave-browser/ and run the script `gen_rewards_libs.sh` located in `BraveRewards/lib` pointing to that cloned and initialized repo.

Warning: Due to https://github.com/brave/brave-browser/issues/3080, we must throw away all brave-browser/src patches that are applyed when you run `npm run init`/`npm sync -- --all` (`git reset --hard HEAD` on src directory). This means if you intend to build a desktop build with the same repo, you must re-apply the patches (either with another sync or apply-patches npm command)
