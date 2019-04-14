/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <Foundation/Foundation.h>
#import "Records.h"

@class BATBraveLedger;

NS_ASSUME_NONNULL_BEGIN

/// The error domain for ledger related errors
extern NSString * const BATBraveLedgerErrorDomain NS_SWIFT_NAME(BraveLedgerErrorDomain);

NS_SWIFT_NAME(BraveLedger)
@interface BATBraveLedger : NSObject

#pragma mark - Wallet

/// Whether or not the wallet has been created
@property (readonly, getter=isWalletCreated) BOOL walletCreated;

/// Creates a cryptocurrency wallet
- (void)createWallet:(nullable void (^)(NSError * _Nullable error))completion;

/// The wallet's passphrase. nil if the wallet has not been created yet
@property (readonly, nullable) NSString *walletPassphrase;

/// Recover the users wallet using their passphrase
- (void)recoverWalletUsingPassphrase:(NSString *)passphrase completion:(nullable void (^)(NSError *_Nullable))completion;

/// The wallet's addresses. nil if the wallet has not been created yet
@property (readonly, nullable) NSString *BATAddress;
@property (readonly, nullable) NSString *BTCAddress;
@property (readonly, nullable) NSString *ETHAddress;
@property (readonly, nullable) NSString *LTCAddress;

@property (readonly) double balance;

@property (readonly) double defaultContributionAmount;

@property (readonly) BOOL hasSufficientBalanceToReconcile;

#pragma mark - Publishers

- (void)addRecurringPaymentToPublisherWithId:(NSString *)publisherId amount:(double)amount
      NS_SWIFT_NAME(addRecurringPayment(publisherId:amount:));

- (void)makeDirectDonationToPublisher:(BATPublisherInfo *)publisher
                               amount:(int)amount
                             currency:(NSString *)currency;

- (void)publisherInfoForId:(NSString *)publisherId completion:(void (^)(BATPublisherInfo * _Nullable info))completion;

- (void)mediaPublisherInfoForMediaKey:(NSString *)mediaKey completion:(void (^)(BATPublisherInfo * _Nullable info))completion;

- (void)updateMediaPublisherInfo:(NSString *)publisherId mediaKey:(NSString *)mediaKey;

@property (readonly) NSArray<BATContributionInfo *> *recurringContributions;
//
///// Update a publishers exclusion state
//- (void)updatePublisherWithId:(NSString *)publisherId exclusionState:(BATPublisherExclude)excludeState
//      NS_SWIFT_NAME(updatePublisher(withId:exclusionState:));

#pragma mark - Grants

- (void)grantCaptchaForPromotionId:(NSString *)promoID
                     promotionType:(NSString *)promotionType
                        completion:(void (^)(NSString *image, NSString *hint))completion;

#pragma mark - Reporting

@property (nonatomic, assign) UInt32 selectedTabId;

/// Report that a page has loaded in the current browser tab, and the HTML is available for analysis
- (void)reportLoadedPageWithURL:(NSURL *)url tabId:(UInt32)tabId NS_SWIFT_NAME(reportLoadedPage(url:tabId:));

- (void)reportXHRLoad:(NSURL *)url
                tabId:(UInt32)tabId
        firstPartyURL:(NSURL *)firstPartyURL
          referrerURL:(nullable NSURL *)referrerURL;

- (void)reportPostData:(NSData *)postData
                   url:(NSURL *)url
                 tabId:(UInt32)tabId
         firstPartyURL:(NSURL *)firstPartyURL
           referrerURL:(nullable NSURL *)referrerURL;

/// Report that media has started on a tab with a given id
- (void)reportMediaStartedWithTabId:(UInt32)tabId NS_SWIFT_NAME(reportMediaStarted(tabId:));

/// Report that media has stopped on a tab with a given id
- (void)reportMediaStoppedWithTabId:(UInt32)tabId NS_SWIFT_NAME(reportMediaStopped(tabId:));

/// Report that a tab with a given id was closed by the user
- (void)reportTabClosedWithTabId:(UInt32)tabId NS_SWIFT_NAME(reportTabClosed(tabId:));

#pragma mark - Preferences

/// Whether or not brave rewards is enabled
@property (nonatomic, assign, getter=isEnabled) BOOL enabled;
/// The number of seconds before a publisher is added.
@property (nonatomic, assign) UInt64 minimumVisitDuration;
/// The minimum number of visits before a publisher is added
@property (nonatomic, assign) UInt32 minimumNumberOfVisits;
/// Whether or not to add unverified publishers
@property (nonatomic, assign) BOOL allowUnverifiedPublishers;
/// ??
@property (nonatomic, assign) BOOL allowVideos;
/// ??
@property (nonatomic, assign) double contributionAmount;
/// Whether or not the user will automatically contribute
@property (nonatomic, assign, getter=isAutoContributeEnabled) BOOL autoContributeEnabled;

@end

NS_ASSUME_NONNULL_END
