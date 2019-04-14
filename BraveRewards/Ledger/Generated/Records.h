#import <Foundation/Foundation.h>
#import "Enums.h"

@class BATAutoContributeProps, BATTransactionInfo, BATTwitchEventInfo, BATWalletInfo, BATContributionInfo, BATPublisherBanner, BATPublisherInfo, BATPublisherInfoListStruct, BATTransactionsInfo, BATBalanceReportInfo, BATGrant, BATReconcileInfo, BATRewardsInternalsInfo, BATPendingContribution, BATPendingContributionList, BATReconcileInfo, BATVisitData;

NS_SWIFT_NAME(AutoContributeProps)
@interface BATAutoContributeProps : NSObject
@property (nonatomic) bool enabledContribute;
@property (nonatomic) uint64_t contributionMinTime;
@property (nonatomic) int32_t contributionMinVisits;
@property (nonatomic) bool contributionNonVerified;
@property (nonatomic) bool contributionVideos;
@property (nonatomic) uint64_t reconcileStamp;
@end

NS_SWIFT_NAME(TransactionInfo)
@interface BATTransactionInfo : NSObject
@property (nonatomic) uint64_t timestampInSeconds;
@property (nonatomic) double estimatedRedemptionValue;
@end

NS_SWIFT_NAME(TwitchEventInfo)
@interface BATTwitchEventInfo : NSObject
@property (nonatomic) NSString * event;
@property (nonatomic) NSString * time;
@property (nonatomic) NSString * status;
@end

NS_SWIFT_NAME(WalletInfo)
@interface BATWalletInfo : NSObject
@property (nonatomic) NSString * altcurrency;
@property (nonatomic) NSString * probi;
@property (nonatomic) double balance;
@property (nonatomic) double feeAmount;
@property (nonatomic) NSDictionary<NSString *, NSNumber *> * rates;
@property (nonatomic) NSArray<NSNumber *> * parametersChoices;
@property (nonatomic) NSArray<NSNumber *> * parametersRange;
@property (nonatomic) unsigned int parametersDays;
@property (nonatomic) NSArray<BATGrant *> * grants;
@end

NS_SWIFT_NAME(ContributionInfo)
@interface BATContributionInfo : NSObject
@property (nonatomic) NSString * publisher;
@property (nonatomic) double value;
@property (nonatomic) uint64_t date;
@end

NS_SWIFT_NAME(PublisherBanner)
@interface BATPublisherBanner : NSObject
@property (nonatomic) NSString * publisherKey;
@property (nonatomic) NSString * title;
@property (nonatomic) NSString * name;
@property (nonatomic) NSString * description;
@property (nonatomic) NSString * background;
@property (nonatomic) NSString * logo;
@property (nonatomic) NSArray<NSNumber *> * amounts;
@property (nonatomic) NSString * provider;
@property (nonatomic) NSDictionary<NSString *, NSString *> * social;
@property (nonatomic) bool verified;
@end

NS_SWIFT_NAME(PublisherInfo)
@interface BATPublisherInfo : NSObject
@property (nonatomic) NSString * id;
@property (nonatomic) uint64_t duration;
@property (nonatomic) double score;
@property (nonatomic) uint32_t visits;
@property (nonatomic) uint32_t percent;
@property (nonatomic) double weight;
@property (nonatomic) BATPublisherExclude excluded;
@property (nonatomic) BATRewardsCategory category;
@property (nonatomic) uint64_t reconcileStamp;
@property (nonatomic) bool verified;
@property (nonatomic) NSString * name;
@property (nonatomic) NSString * url;
@property (nonatomic) NSString * provider;
@property (nonatomic) NSString * faviconUrl;
@property (nonatomic) NSArray<BATContributionInfo *> * contributions;
@end

NS_SWIFT_NAME(PublisherInfoListStruct)
@interface BATPublisherInfoListStruct : NSObject
@property (nonatomic) NSArray<BATPublisherInfo *> * list;
@end

NS_SWIFT_NAME(TransactionsInfo)
@interface BATTransactionsInfo : NSObject
@property (nonatomic) NSArray<BATTransactionInfo *> * transactions;
@end

NS_SWIFT_NAME(BalanceReportInfo)
@interface BATBalanceReportInfo : NSObject
@property (nonatomic) NSString * openingBalance;
@property (nonatomic) NSString * closingBalance;
@property (nonatomic) NSString * deposits;
@property (nonatomic) NSString * grants;
@property (nonatomic) NSString * earningFromAds;
@property (nonatomic) NSString * autoContribute;
@property (nonatomic) NSString * recurringDonation;
@property (nonatomic) NSString * oneTimeDonation;
@property (nonatomic) NSString * total;
@end

NS_SWIFT_NAME(Grant)
@interface BATGrant : NSObject
@property (nonatomic) NSString * altcurrency;
@property (nonatomic) NSString * probi;
@property (nonatomic) NSString * promotionId;
@property (nonatomic) uint64_t expiryTime;
@property (nonatomic) NSString * type;
@end

NS_SWIFT_NAME(RewardsInternalsInfo)
@interface BATRewardsInternalsInfo : NSObject
@property (nonatomic) NSString * paymentId;
@property (nonatomic) bool isKeyInfoSeedValid;
@property (nonatomic) NSDictionary<NSString *, BATReconcileInfo *> * currentReconciles;
@end

NS_SWIFT_NAME(PendingContribution)
@interface BATPendingContribution : NSObject
@property (nonatomic) NSString * publisherKey;
@property (nonatomic) double amount;
@property (nonatomic) uint64_t addedDate;
@property (nonatomic) NSString * viewingId;
@property (nonatomic) int category;
@end

NS_SWIFT_NAME(PendingContributionList)
@interface BATPendingContributionList : NSObject
@property (nonatomic) NSArray<BATPendingContribution *> * list;
@end

NS_SWIFT_NAME(ReconcileInfo)
@interface BATReconcileInfo : NSObject
@property (nonatomic) NSString * viewingid;
@property (nonatomic) NSString * amount;
@property (nonatomic) BATContributionRetry retryStep;
@property (nonatomic) int retryLevel;
@end

NS_SWIFT_NAME(VisitData)
@interface BATVisitData : NSObject
@property (nonatomic) NSString * tld;
@property (nonatomic) NSString * domain;
@property (nonatomic) NSString * path;
@property (nonatomic) uint32_t tabId;
@property (nonatomic) NSString * name;
@property (nonatomic) NSString * url;
@property (nonatomic) NSString * provider;
@property (nonatomic) NSString * faviconUrl;
@end

