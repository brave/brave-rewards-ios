/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <Foundation/Foundation.h>
#import "Records.h"
#import "BATActivityInfoFilter.h"

@class BATBraveLedger;

NS_ASSUME_NONNULL_BEGIN

/// The error domain for ledger related errors
extern NSString * const BATBraveLedgerErrorDomain NS_SWIFT_NAME(BraveLedgerErrorDomain);

NS_SWIFT_NAME(BraveLedger)
@interface BATBraveLedger : NSObject

/// Create a brave ledger that will read and write its state to the given path
- (instancetype)initWithStateStoragePath:(NSString *)path;

- (instancetype)init NS_UNAVAILABLE;

#pragma mark - Wallet

/// Whether or not the wallet has been created
@property (readonly, getter=isWalletCreated) BOOL walletCreated;

/// Creates a cryptocurrency wallet
- (void)createWallet:(nullable void (^)(NSError * _Nullable error))completion;

/// Fetch details about the users wallet (if they have one)
- (void)fetchWalletDetails:(nullable void (^)(BATWalletInfo *))completion;

/// The users wallet info if one has been created
@property (readonly, nullable) BATWalletInfo *walletInfo;

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

- (void)publisherInfoForId:(NSString *)publisherId
                completion:(void (^)(BATPublisherInfo * _Nullable info))completion;

- (void)activityInfoWithFilter:(nullable BATActivityInfoFilter *)filter
                    completion:(void (^)(BATPublisherInfo * _Nullable info))completion;

- (void)mediaPublisherInfoForMediaKey:(NSString *)mediaKey
                           completion:(void (^)(BATPublisherInfo * _Nullable info))completion;

- (void)updateMediaPublisherInfo:(NSString *)publisherId mediaKey:(NSString *)mediaKey;

@property (readonly) NSArray<BATContributionInfo *> *recurringContributions;

/// Update a publishers exclusion state
- (void)updatePublisherExclusionState:(NSString *)publisherId state:(BATPublisherExclude)state
      NS_SWIFT_NAME(updatePublisherExclusionState(withId:state:));

/// Restore all sites which had been previously excluded
- (void)restoreAllExcludedPublishers;

- (void)publisherBannerForId:(NSString *)publisherId
                  completion:(void (^)(BATPublisherBanner * _Nullable banner))completion;

#pragma mark - Tips

- (void)addRecurringTipToPublisherWithId:(NSString *)publisherId
                                  amount:(double)amount NS_SWIFT_NAME(addRecurringTip(publisherId:amount:));

- (void)removeRecurringTipForPublisherWithId:(NSString *)publisherId NS_SWIFT_NAME(removeRecurringTip(publisherId:));

- (void)tipPublisherDirectly:(BATPublisherInfo *)publisher
                      amount:(int)amount
                    currency:(NSString *)currency;


#pragma mark - Grants

- (void)grantCaptchaForPromotionId:(NSString *)promoID
                     promotionType:(NSString *)promotionType
                        completion:(void (^)(NSString *image, NSString *hint))completion;

#pragma mark - Auto Contribute

@property (readonly) NSDictionary<NSString *, BATBalanceReportInfo *> *balanceReports;

- (BATBalanceReportInfo *)balanceReportForMonth:(BATActivityMonth)month
                                                    year:(int)year;

@property (readonly) BATAutoContributeProps *autoContributeProps;

#pragma mark - Misc

+ (bool)isMediaURL:(NSURL *)url
     firstPartyURL:(nullable NSURL *)firstPartyURL
       referrerURL:(nullable NSURL *)referrerURL;

/// Get an encoded URL that can be placed in another URL
- (NSString *)encodedURI:(NSString *)uri;

@property (readonly) BATRewardsInternalsInfo *rewardsInternalInfo;

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
/// Whether or not to allow auto contributions to unverified publishers
@property (nonatomic, assign) BOOL allowUnverifiedPublishers;
/// Whether or not to allow auto contributions to videos
@property (nonatomic, assign) BOOL allowVideoContributions;
/// The auto-contribute amount
@property (nonatomic, assign) double contributionAmount;
/// Whether or not the user will automatically contribute
@property (nonatomic, assign, getter=isAutoContributeEnabled) BOOL autoContributeEnabled;

@end

NS_ASSUME_NONNULL_END
