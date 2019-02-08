/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BATPublisherExclude) {
  /// Excluding all publishers???
  BATPublisherExcludeAll = -1,
  /// This tell us that user did not manually changed exclude state
  BATPublisherExcludeDefault,
  /// User manually changed it to exclude
  BATPublisherExcludeExcluded,
  /// User manually changed it to include and is overriding server flags
  BATPublisherExcludeIncluded
};


typedef NS_ENUM(NSInteger, BATPublisherRewardsCategory) {
  // ledger::AUTO_CONTRIBUTE
  BATPublisherRewardsCategoryAutoContribute = 1 << 1,
  // ledger::TIPPING
  BATPublisherRewardsCategoryTipping = 1 << 2,
  // ledger::DIRECT_DONATION
  BATPublisherRewardsCategoryDirectDonation = 1 << 3,
  // ledger::RECURRING_DONATION
  BATPublisherRewardsCategoryRecurringDonation = 1 << 4,
  // ledger::ALL_CATEGORIES
  BATPublisherRewardsCategoryAll = (1 << 5) - 1,
};

typedef NS_ENUM(NSInteger, BATPublisherActivityMonth) {
  BATPublisherActivityMonthAny = -1,
  BATPublisherActivityMonthJan = 1,
  BATPublisherActivityMonthFeb,
  BATPublisherActivityMonthMar,
  BATPublisherActivityMonthApr,
  BATPublisherActivityMonthMay,
  BATPublisherActivityMonthJun,
  BATPublisherActivityMonthJul,
  BATPublisherActivityMonthAug,
  BATPublisherActivityMonthSep,
  BATPublisherActivityMonthOct,
  BATPublisherActivityMonthNov,
  BATPublisherActivityMonthDec
};

NS_SWIFT_NAME(Publisher)
@interface BATPublisher : NSObject

@property (nonatomic, readonly, copy) NSString *publisherId;

// These are saved to ActivityInfo DB

@property (nonatomic, readonly) UInt64 duration;
@property (nonatomic, readonly) double score;
@property (nonatomic, readonly) int year;
@property (nonatomic, readonly) BATPublisherActivityMonth month;
@property (nonatomic, readonly) UInt64 reconcileStamp;
@property (nonatomic, readonly) UInt32 visits;
@property (nonatomic, readonly) UInt32 percent;
@property (nonatomic, readonly) double weight;
@property (nonatomic, readonly) BATPublisherRewardsCategory rewardsCategory;

// These are saved to Publisher DB

@property (nonatomic, readonly) BATPublisherExclude excluded;
@property (nonatomic, readonly, copy) NSURL *faviconURL;
@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, copy) NSString *provider;
@property (nonatomic, readonly, copy) NSURL *url;
@property (nonatomic, readonly) BOOL verified;

@end

NS_ASSUME_NONNULL_END
