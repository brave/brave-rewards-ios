/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(BraveLedger)
@interface BATBraveLedger : NSObject

/*
#pragma mark - Wallet

/// The address of the BAT wallet
@property (nonatomic, readonly, copy) NSString *BATAddress NS_SWIFT_NAME(BATAddress);

/// The address of the BTC wallet
@property (nonatomic, readonly, copy) NSString *BTCAddress NS_SWIFT_NAME(BTCAddress);

/// The address of the ETH wallet
@property (nonatomic, readonly, copy) NSString *ETHAddress NS_SWIFT_NAME(ETHAddress);

/// The address of the LTC wallet
@property (nonatomic, readonly, copy) NSString *LTCAddress NS_SWIFT_NAME(LTCAddress);

/// Creates a cryptocurrency wallet
- (void)createWallet;

/// Deletes this wallet
- (void)deleteWallet;

/// The recovery key to display to the user when they choose to backup the wallet
- (NSString *)walletRecoveryKey;

/// Recover the wallet using a recovery key previously generated
- (void)recoverWallet:(NSString *)recoveryKey NS_SWIFT_NAME(recoverWallet(key:));

#pragma mark - Publishers

- (void)addPublisher:(NSString *)publisher;

- (void)setPublisherIncluded:(NSString *)publisher included:(BOOL)included;

- (void)removePublisher:(NSString *)publisher;

- (void)recordVisitForPublisher:(NSString *)publisher duration:(NSTimeInterval)duration NS_SWIFT_NAME(recordVisit(publisher:duration:));

- (void)pinPublisher:(NSString *)publisher percent:(double)percent;

- (void)unpinPublisher:(NSString *)publisher;

#pragma mark - Preferences

/// The amount the user wishes to contribute monthly
@property (nonatomic, assign) double contributionAmount;

/// The minimum number of visits until a publisher is added automatically
@property (nonatomic, assign) UInt32 minimumVisitsForPublisherRelevancy;

/// The minimum time required to be on a page before it is counted as a visit
@property (nonatomic, assign) NSTimeInterval minimumVisitTimeThreshold;

/// Whether or not to allow non-verified publishers to be added automatically
@property (nonatomic, assign) BOOL allowNonVerifiedPublishers;

/// Whether or not to allocate some of the contribution to video publishers
@property (nonatomic, assign) BOOL allowContributionsToVideos;
 
*/

@end

NS_ASSUME_NONNULL_END
