#import <Foundation/Foundation.h>
#import "Records.h"
#include "bat/ledger/ledger.h"

@interface BATAutoContributeProps (Private)
- (instancetype)initWithAutoContributeProps:(const ledger::AutoContributeProps&)obj;
@end

@interface BATTransactionInfo (Private)
- (instancetype)initWithTransactionInfo:(const ledger::TransactionInfo&)obj;
@end

@interface BATTwitchEventInfo (Private)
- (instancetype)initWithTwitchEventInfo:(const ledger::TwitchEventInfo&)obj;
@end

@interface BATWalletInfo (Private)
- (instancetype)initWithWalletInfo:(const ledger::WalletInfo&)obj;
@end

@interface BATContributionInfo (Private)
- (instancetype)initWithContributionInfo:(const ledger::ContributionInfo&)obj;
@end

@interface BATPublisherBanner (Private)
- (instancetype)initWithPublisherBanner:(const ledger::PublisherBanner&)obj;
@end

@interface BATPublisherInfo (Private)
- (instancetype)initWithPublisherInfo:(const ledger::PublisherInfo&)obj;
@end

@interface BATPublisherInfoListStruct (Private)
- (instancetype)initWithPublisherInfoListStruct:(const ledger::PublisherInfoListStruct&)obj;
@end

@interface BATTransactionsInfo (Private)
- (instancetype)initWithTransactionsInfo:(const ledger::TransactionsInfo&)obj;
@end

@interface BATBalanceReportInfo (Private)
- (instancetype)initWithBalanceReportInfo:(const ledger::BalanceReportInfo&)obj;
@end

@interface BATGrant (Private)
- (instancetype)initWithGrant:(const ledger::Grant&)obj;
@end

@interface BATRewardsInternalsInfo (Private)
- (instancetype)initWithRewardsInternalsInfo:(const ledger::RewardsInternalsInfo&)obj;
@end

@interface BATPendingContribution (Private)
- (instancetype)initWithPendingContribution:(const ledger::PendingContribution&)obj;
@end

@interface BATPendingContributionList (Private)
- (instancetype)initWithPendingContributionList:(const ledger::PendingContributionList&)obj;
@end

@interface BATReconcileInfo (Private)
- (instancetype)initWithReconcileInfo:(const ledger::ReconcileInfo&)obj;
@end

@interface BATVisitData (Private)
- (instancetype)initWithVisitData:(const ledger::VisitData&)obj;
@end

