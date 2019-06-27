/* Copyright (c) 2019 The Brave Authors. All rights reserved.
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <Foundation/Foundation.h>

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif




@class BATContributionInfo, BATPublisherInfo, BATPendingContribution, BATPendingContributionInfo, BATVisitData, BATGrant, BATWalletProperties, BATBalance;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(ContributionInfo)
@interface BATContributionInfo : NSObject <NSCopying>
@property (nonatomic, copy) NSString * publisher;
@property (nonatomic) double value;
@property (nonatomic) uint64_t date;
@end

NS_SWIFT_NAME(PublisherInfo)
@interface BATPublisherInfo : NSObject <NSCopying>
@property (nonatomic, copy) NSString * id;
@property (nonatomic) uint64_t duration;
@property (nonatomic) double score;
@property (nonatomic) uint32_t visits;
@property (nonatomic) uint32_t percent;
@property (nonatomic) double weight;
@property (nonatomic) int32_t excluded;
@property (nonatomic) int32_t category;
@property (nonatomic) uint64_t reconcileStamp;
@property (nonatomic) bool verified;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * url;
@property (nonatomic, copy) NSString * provider;
@property (nonatomic, copy) NSString * faviconUrl;
@property (nonatomic, copy) NSArray<BATContributionInfo *> * contributions;
@end

NS_SWIFT_NAME(PendingContribution)
@interface BATPendingContribution : NSObject <NSCopying>
@property (nonatomic, copy) NSString * publisherKey;
@property (nonatomic) double amount;
@property (nonatomic) uint64_t addedDate;
@property (nonatomic, copy) NSString * viewingId;
@property (nonatomic) int32_t category;
@end

NS_SWIFT_NAME(PendingContributionInfo)
@interface BATPendingContributionInfo : NSObject <NSCopying>
@property (nonatomic, copy) NSString * publisherKey;
@property (nonatomic) int32_t category;
@property (nonatomic) bool verified;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * url;
@property (nonatomic, copy) NSString * provider;
@property (nonatomic, copy) NSString * faviconUrl;
@property (nonatomic) double amount;
@property (nonatomic) uint64_t addedDate;
@property (nonatomic, copy) NSString * viewingId;
@property (nonatomic) uint64_t expirationDate;
@end

NS_SWIFT_NAME(VisitData)
@interface BATVisitData : NSObject <NSCopying>
@property (nonatomic, copy) NSString * tld;
@property (nonatomic, copy) NSString * domain;
@property (nonatomic, copy) NSString * path;
@property (nonatomic) uint32_t tabId;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * url;
@property (nonatomic, copy) NSString * provider;
@property (nonatomic, copy) NSString * faviconUrl;
@end

NS_SWIFT_NAME(Grant)
@interface BATGrant : NSObject <NSCopying>
@property (nonatomic, copy) NSString * altcurrency;
@property (nonatomic, copy) NSString * probi;
@property (nonatomic, copy) NSString * promotionId;
@property (nonatomic) uint64_t expiryTime;
@property (nonatomic, copy) NSString * type;
@end

NS_SWIFT_NAME(WalletProperties)
@interface BATWalletProperties : NSObject <NSCopying>
@property (nonatomic) double feeAmount;
@property (nonatomic, copy) NSArray<NSNumber *> * parametersChoices;
@property (nonatomic, copy) NSArray<NSNumber *> * parametersRange;
@property (nonatomic) uint32_t parametersDays;
@property (nonatomic, copy) NSArray<BATGrant *> * grants;
@end

NS_SWIFT_NAME(Balance)
@interface BATBalance : NSObject <NSCopying>
@property (nonatomic) double total;
@property (nonatomic, copy) NSDictionary<NSString *, NSNumber *> * rates;
@property (nonatomic, copy) NSDictionary<NSString *, NSNumber *> * wallets;
@end

NS_ASSUME_NONNULL_END