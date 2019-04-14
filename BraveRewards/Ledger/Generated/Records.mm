#import "Records.h"
#import "Records+Private.h"
#include "bat/ledger/ledger.h"
#include <vector>
#include <map>
#include <string>
#import <objc/runtime.h>

/// Convert a vector storing primatives to an array of NSNumber's
template <class T>
NS_INLINE NSArray<NSNumber *> *NSArrayFromVector(std::vector<T> v) {
	const auto a = [NSMutableArray new];
	if (v.empty()) {
		return @[];
	}
	std::map<const char *, SEL> map = {
		{ @encode(bool), @selector(numberWithBool:) },
		{ @encode(char), @selector(numberWithChar:) },
		{ @encode(double), @selector(numberWithDouble:) },
		{ @encode(float), @selector(numberWithFloat:) },
		{ @encode(int), @selector(numberWithInt:) },
		{ @encode(NSInteger), @selector(numberWithInteger:) },
		{ @encode(long), @selector(numberWithLong:) },
		{ @encode(long long), @selector(numberWithLongLong:) },
		{ @encode(short), @selector(numberWithShort:) },
		{ @encode(unsigned char), @selector(numberWithUnsignedChar:) },
		{ @encode(unsigned int), @selector(numberWithUnsignedInt:) },
		{ @encode(NSUInteger), @selector(numberWithUnsignedInteger:) },
		{ @encode(unsigned long), @selector(numberWithUnsignedLong:) },
		{ @encode(unsigned long long), @selector(numberWithUnsignedLongLong:) },
		{ @encode(unsigned short), @selector(numberWithUnsignedShort:) },
	};
	// Since vector's are uniformly typed, we can just use v[0]
	const auto encode = @encode(__typeof__(v[0]));
	const auto selector = map[encode];
	if (selector == nullptr) { return @[]; }
	const auto method = class_getClassMethod(NSNumber.class, selector);
//	const auto call = 
	typedef NSNumber *(*NSNumberCall)(id,SEL,T);
	NSNumberCall call = (NSNumberCall)method_getImplementation(method);

	for (auto t : v) {
		NSNumber *number = (NSNumber *)call(NSNumber.class, selector, t);
		[a addObject:number];
	}
	return a;
}

/// Convert a vector storing strings to an array of NSString's
NS_INLINE NSArray<NSString *> *NSArrayFromVector(std::vector<std::string> v) {
	const auto a = [NSMutableArray new];
	for (auto s : v) {
		[a addObject:[NSString stringWithCString:s.c_str() encoding:NSUTF8StringEncoding]];
	}
	return a;
}

/// Convert a vector storing objects to an array of transformed objects's
template <class T, class U>
NS_INLINE NSArray<T> *NSArrayFromVector(std::vector<U> v, T(^transform)(const U&)) {
	const auto a = [NSMutableArray new];
	for (const auto& o : v) {
		[a addObject:transform(o)];
	}
	return a;
}

template <typename T>
NS_INLINE NSNumber* NumberFromPrimitive(T t) {
  std::map<const char *, SEL> map = {
    { @encode(bool), @selector(numberWithBool:) },
    { @encode(char), @selector(numberWithChar:) },
    { @encode(double), @selector(numberWithDouble:) },
    { @encode(float), @selector(numberWithFloat:) },
    { @encode(int), @selector(numberWithInt:) },
    { @encode(NSInteger), @selector(numberWithInteger:) },
    { @encode(long), @selector(numberWithLong:) },
    { @encode(long long), @selector(numberWithLongLong:) },
    { @encode(short), @selector(numberWithShort:) },
    { @encode(unsigned char), @selector(numberWithUnsignedChar:) },
    { @encode(unsigned int), @selector(numberWithUnsignedInt:) },
    { @encode(NSUInteger), @selector(numberWithUnsignedInteger:) },
    { @encode(unsigned long), @selector(numberWithUnsignedLong:) },
    { @encode(unsigned long long), @selector(numberWithUnsignedLongLong:) },
    { @encode(unsigned short), @selector(numberWithUnsignedShort:) },
  };
  const auto encode = @encode(__typeof__(t));
  const auto selector = map[encode];
  if (selector == nullptr) { return nil; }
  const auto method = class_getClassMethod(NSNumber.class, selector);
  typedef NSNumber *(*NSNumberCall)(id,SEL,T);
  NSNumberCall call = (NSNumberCall)method_getImplementation(method);
  return (NSNumber *)call(NSNumber.class, selector, t);
}

template <typename T>
NS_INLINE NSDictionary<NSString *, NSNumber *> *NSDictionaryFromMap(std::map<std::string, T> m) {
  const auto d = [NSMutableDictionary new];
  if (m.empty()) {
    return @{};
  }
  for (auto item : m) {
    d[[NSString stringWithCString:item.first.c_str() encoding:NSUTF8StringEncoding]] =
    NumberFromPrimitive(item.second);
  }
  return d;
};

NS_INLINE NSDictionary<NSString *, NSString *> *NSDictionaryFromMap(std::map<std::string, std::string> m) {
  const auto d = [NSMutableDictionary new];
  if (m.empty()) {
    return @{};
  }
  for (auto item : m) {
    d[[NSString stringWithCString:item.first.c_str() encoding:NSUTF8StringEncoding]] =
    [NSString stringWithCString:item.second.c_str() encoding:NSUTF8StringEncoding];
  }
  return d;
};

template <typename V, class ObjCObj>
NS_INLINE NSDictionary<NSString *, ObjCObj> *NSDictionaryFromMap(std::map<std::string, V> m, ObjCObj(^transform)(V)) {
  const auto d = [NSMutableDictionary new];
  if (m.empty()) {
    return @{};
  }
  for (auto item : m) {
    d[[NSString stringWithCString:item.first.c_str() encoding:NSUTF8StringEncoding]] = transform(item.second);
  }
  return d;
};

@implementation BATAutoContributeProps
- (instancetype)initWithAutoContributeProps:(const ledger::AutoContributeProps&)obj {
  if ((self = [super init])) {
    self.enabledContribute = obj.enabled_contribute;
    self.contributionMinTime = obj.contribution_min_time;
    self.contributionMinVisits = obj.contribution_min_visits;
    self.contributionNonVerified = obj.contribution_non_verified;
    self.contributionVideos = obj.contribution_videos;
    self.reconcileStamp = obj.reconcile_stamp;
  }
  return self;
}
@end

@implementation BATTransactionInfo
- (instancetype)initWithTransactionInfo:(const ledger::TransactionInfo&)obj {
  if ((self = [super init])) {
    self.timestampInSeconds = obj.timestamp_in_seconds;
    self.estimatedRedemptionValue = obj.estimated_redemption_value;
  }
  return self;
}
@end

@implementation BATTwitchEventInfo
- (instancetype)initWithTwitchEventInfo:(const ledger::TwitchEventInfo&)obj {
  if ((self = [super init])) {
    self.event = [NSString stringWithCString:obj.event_.c_str() encoding:NSUTF8StringEncoding];
    self.time = [NSString stringWithCString:obj.time_.c_str() encoding:NSUTF8StringEncoding];
    self.status = [NSString stringWithCString:obj.status_.c_str() encoding:NSUTF8StringEncoding];
  }
  return self;
}
@end

@implementation BATWalletInfo
- (instancetype)initWithWalletInfo:(const ledger::WalletInfo&)obj {
  if ((self = [super init])) {
    self.altcurrency = [NSString stringWithCString:obj.altcurrency_.c_str() encoding:NSUTF8StringEncoding];
    self.probi = [NSString stringWithCString:obj.probi_.c_str() encoding:NSUTF8StringEncoding];
    self.balance = obj.balance_;
    self.feeAmount = obj.fee_amount_;
    self.rates = NSDictionaryFromMap(obj.rates_);
    self.parametersChoices = NSArrayFromVector(obj.parameters_choices_);
    self.parametersRange = NSArrayFromVector(obj.parameters_range_);
    self.parametersDays = obj.parameters_days_;
    self.grants = NSArrayFromVector(obj.grants_, ^BATGrant *(const ledger::Grant& o){ return [[BATGrant alloc] initWithGrant: o]; });
  }
  return self;
}
@end

@implementation BATContributionInfo
- (instancetype)initWithContributionInfo:(const ledger::ContributionInfo&)obj {
  if ((self = [super init])) {
    self.publisher = [NSString stringWithCString:obj.publisher.c_str() encoding:NSUTF8StringEncoding];
    self.value = obj.value;
    self.date = obj.date;
  }
  return self;
}
@end

@implementation BATPublisherBanner
- (instancetype)initWithPublisherBanner:(const ledger::PublisherBanner&)obj {
  if ((self = [super init])) {
    self.publisherKey = [NSString stringWithCString:obj.publisher_key.c_str() encoding:NSUTF8StringEncoding];
    self.title = [NSString stringWithCString:obj.title.c_str() encoding:NSUTF8StringEncoding];
    self.name = [NSString stringWithCString:obj.name.c_str() encoding:NSUTF8StringEncoding];
    self.description = [NSString stringWithCString:obj.description.c_str() encoding:NSUTF8StringEncoding];
    self.background = [NSString stringWithCString:obj.background.c_str() encoding:NSUTF8StringEncoding];
    self.logo = [NSString stringWithCString:obj.logo.c_str() encoding:NSUTF8StringEncoding];
    self.amounts = NSArrayFromVector(obj.amounts);
    self.provider = [NSString stringWithCString:obj.provider.c_str() encoding:NSUTF8StringEncoding];
    self.social = NSDictionaryFromMap(obj.social);
    self.verified = obj.verified;
  }
  return self;
}
@end

@implementation BATPublisherInfo
- (instancetype)initWithPublisherInfo:(const ledger::PublisherInfo&)obj {
  if ((self = [super init])) {
    self.id = [NSString stringWithCString:obj.id.c_str() encoding:NSUTF8StringEncoding];
    self.duration = obj.duration;
    self.score = obj.score;
    self.visits = obj.visits;
    self.percent = obj.percent;
    self.weight = obj.weight;
    self.excluded = (BATPublisherExclude)obj.excluded;
    self.category = (BATRewardsCategory)obj.category;
    self.reconcileStamp = obj.reconcile_stamp;
    self.verified = obj.verified;
    self.name = [NSString stringWithCString:obj.name.c_str() encoding:NSUTF8StringEncoding];
    self.url = [NSString stringWithCString:obj.url.c_str() encoding:NSUTF8StringEncoding];
    self.provider = [NSString stringWithCString:obj.provider.c_str() encoding:NSUTF8StringEncoding];
    self.faviconUrl = [NSString stringWithCString:obj.favicon_url.c_str() encoding:NSUTF8StringEncoding];
    self.contributions = NSArrayFromVector(obj.contributions, ^BATContributionInfo *(const ledger::ContributionInfo& o){ return [[BATContributionInfo alloc] initWithContributionInfo: o]; });
  }
  return self;
}
@end

@implementation BATPublisherInfoListStruct
- (instancetype)initWithPublisherInfoListStruct:(const ledger::PublisherInfoListStruct&)obj {
  if ((self = [super init])) {
    self.list = NSArrayFromVector(obj.list, ^BATPublisherInfo *(const ledger::PublisherInfo& o){ return [[BATPublisherInfo alloc] initWithPublisherInfo: o]; });
  }
  return self;
}
@end

@implementation BATTransactionsInfo
- (instancetype)initWithTransactionsInfo:(const ledger::TransactionsInfo&)obj {
  if ((self = [super init])) {
    self.transactions = NSArrayFromVector(obj.transactions, ^BATTransactionInfo *(const ledger::TransactionInfo& o){ return [[BATTransactionInfo alloc] initWithTransactionInfo: o]; });
  }
  return self;
}
@end

@implementation BATBalanceReportInfo
- (instancetype)initWithBalanceReportInfo:(const ledger::BalanceReportInfo&)obj {
  if ((self = [super init])) {
    self.openingBalance = [NSString stringWithCString:obj.opening_balance_.c_str() encoding:NSUTF8StringEncoding];
    self.closingBalance = [NSString stringWithCString:obj.closing_balance_.c_str() encoding:NSUTF8StringEncoding];
    self.deposits = [NSString stringWithCString:obj.deposits_.c_str() encoding:NSUTF8StringEncoding];
    self.grants = [NSString stringWithCString:obj.grants_.c_str() encoding:NSUTF8StringEncoding];
    self.earningFromAds = [NSString stringWithCString:obj.earning_from_ads_.c_str() encoding:NSUTF8StringEncoding];
    self.autoContribute = [NSString stringWithCString:obj.auto_contribute_.c_str() encoding:NSUTF8StringEncoding];
    self.recurringDonation = [NSString stringWithCString:obj.recurring_donation_.c_str() encoding:NSUTF8StringEncoding];
    self.oneTimeDonation = [NSString stringWithCString:obj.one_time_donation_.c_str() encoding:NSUTF8StringEncoding];
    self.total = [NSString stringWithCString:obj.total_.c_str() encoding:NSUTF8StringEncoding];
  }
  return self;
}
@end

@implementation BATGrant
- (instancetype)initWithGrant:(const ledger::Grant&)obj {
  if ((self = [super init])) {
    self.altcurrency = [NSString stringWithCString:obj.altcurrency.c_str() encoding:NSUTF8StringEncoding];
    self.probi = [NSString stringWithCString:obj.probi.c_str() encoding:NSUTF8StringEncoding];
    self.promotionId = [NSString stringWithCString:obj.promotionId.c_str() encoding:NSUTF8StringEncoding];
    self.expiryTime = obj.expiryTime;
    self.type = [NSString stringWithCString:obj.type.c_str() encoding:NSUTF8StringEncoding];
  }
  return self;
}
@end

@implementation BATRewardsInternalsInfo
- (instancetype)initWithRewardsInternalsInfo:(const ledger::RewardsInternalsInfo&)obj {
  if ((self = [super init])) {
    self.paymentId = [NSString stringWithCString:obj.payment_id.c_str() encoding:NSUTF8StringEncoding];
    self.isKeyInfoSeedValid = obj.is_key_info_seed_valid;
    self.currentReconciles = NSDictionaryFromMap(obj.current_reconciles, ^BATReconcileInfo *(ledger::ReconcileInfo o){ return [[BATReconcileInfo alloc] initWithReconcileInfo:o]; });
  }
  return self;
}
@end

@implementation BATPendingContribution
- (instancetype)initWithPendingContribution:(const ledger::PendingContribution&)obj {
  if ((self = [super init])) {
    self.publisherKey = [NSString stringWithCString:obj.publisher_key.c_str() encoding:NSUTF8StringEncoding];
    self.amount = obj.amount;
    self.addedDate = obj.added_date;
    self.viewingId = [NSString stringWithCString:obj.viewing_id.c_str() encoding:NSUTF8StringEncoding];
    self.category = obj.category;
  }
  return self;
}
@end

@implementation BATPendingContributionList
- (instancetype)initWithPendingContributionList:(const ledger::PendingContributionList&)obj {
  if ((self = [super init])) {
    self.list = NSArrayFromVector(obj.list_, ^BATPendingContribution *(const ledger::PendingContribution& o){ return [[BATPendingContribution alloc] initWithPendingContribution: o]; });
  }
  return self;
}
@end

@implementation BATReconcileInfo
- (instancetype)initWithReconcileInfo:(const ledger::ReconcileInfo&)obj {
  if ((self = [super init])) {
    self.viewingid = [NSString stringWithCString:obj.viewingId_.c_str() encoding:NSUTF8StringEncoding];
    self.amount = [NSString stringWithCString:obj.amount_.c_str() encoding:NSUTF8StringEncoding];
    self.retryStep = (BATContributionRetry)obj.retry_step_;
    self.retryLevel = obj.retry_level_;
  }
  return self;
}
@end

@implementation BATVisitData
- (instancetype)initWithVisitData:(const ledger::VisitData&)obj {
  if ((self = [super init])) {
    self.tld = [NSString stringWithCString:obj.tld.c_str() encoding:NSUTF8StringEncoding];
    self.domain = [NSString stringWithCString:obj.domain.c_str() encoding:NSUTF8StringEncoding];
    self.path = [NSString stringWithCString:obj.path.c_str() encoding:NSUTF8StringEncoding];
    self.tabId = obj.tab_id;
    self.name = [NSString stringWithCString:obj.name.c_str() encoding:NSUTF8StringEncoding];
    self.url = [NSString stringWithCString:obj.url.c_str() encoding:NSUTF8StringEncoding];
    self.provider = [NSString stringWithCString:obj.provider.c_str() encoding:NSUTF8StringEncoding];
    self.faviconUrl = [NSString stringWithCString:obj.favicon_url.c_str() encoding:NSUTF8StringEncoding];
  }
  return self;
}
@end

