#!/bin/bash

pushd `dirname $0`

unzip libbat-native-ads.a.zip -d bat-native-ads
unzip libbat-native-ledger.a.zip -d bat-native-ledger

popd
