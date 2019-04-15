/* WARNING: THIS FILE IS GENERATED. ANY CHANGES TO THIS FILE WILL BE OVERWRITTEN
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "Records.h"
#import "Records+Private.h"
#import "CppTransformations.h"

#import <vector>
#import <map>
#import <string>

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

@implementation BATPendingContribution
- (instancetype)initWithPendingContribution:(const ledger::PendingContribution&)obj {
  if ((self = [super init])) {
    self.publisherKey = [NSString stringWithCString:obj.publisher_key.c_str() encoding:NSUTF8StringEncoding];
    self.amount = obj.amount;
    self.addedDate = obj.added_date;
    self.viewingId = [NSString stringWithCString:obj.viewing_id.c_str() encoding:NSUTF8StringEncoding];
    self.category = (BATRewardsCategory)obj.category;
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

@implementation BATTransactionInfo
- (instancetype)initWithTransactionInfo:(const ledger::TransactionInfo&)obj {
  if ((self = [super init])) {
    self.timestampInSeconds = obj.timestamp_in_seconds;
    self.estimatedRedemptionValue = obj.estimated_redemption_value;
    self.confirmationType = [NSString stringWithCString:obj.confirmation_type.c_str() encoding:NSUTF8StringEncoding];
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
