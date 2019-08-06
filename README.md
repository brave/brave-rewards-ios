# brave-rewards-ios

A UI framework for consuming Brave Rewards on [brave-ios](https://github.com/brave/brave-ios). The core logic around BraveRewards resides in brave-core

The latest BraveRewards.framework was built on:

```
brave-browser/d87b70acc7a9b2a407d72a0beed6ef79ce654543
brave-core/98fbddc221a5915dd29c0d69186e5d6e9f2bdc1f
```

Building the code
-----------------

1. Install the latest [Xcode developer tools](https://developer.apple.com/xcode/downloads/) from Apple. (Xcode 10 and up required)
1. Install Carthage:
    ```shell
    brew update
    brew install carthage
    ```
1. Install SwiftLint:
    ```shell
    brew install swiftlint
    ```
1. Clone the repository:
    ```shell
    git clone https://github.com/brave/brave-rewards-ios.git
    ```
1. Pull in the project dependencies:
    ```shell
    cd brave-rewards-ios
    carthage bootstrap --platform ios --cache-builds --no-use-binaries
    ```
1. Open `BraveRewards.xcodeproj` in Xcode.
1. Build the `BraveRewardsExample` scheme in Xcode
