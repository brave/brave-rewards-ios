/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATLedgerWalletInfo.h"
#import "BATLedgerGrant+Private.h"

#import "bat/ledger/wallet_info.h"
#import "NSArray+Vector.h"

@interface BATLedgerWalletInfo ()
@property (nonatomic, copy) NSString *altcurrency;
@property (nonatomic, copy) NSString *probi;
@property (nonatomic) double balance;
@property (nonatomic) double feeAmount;
@property (nonatomic, copy) NSArray<NSNumber *> *parametersChoices;
@property (nonatomic, copy) NSArray<NSNumber *> *parametersRange;
@property (nonatomic) int parametersDays;
@property (nonatomic, copy) NSArray<BATLedgerGrant *> *grants;
@end

@implementation BATLedgerWalletInfo

- (instancetype)initWithWalletInfo:(const ledger::WalletInfo&)info
{
  if ((self = [super init])) {
    self.altcurrency = [NSString stringWithUTF8String:info.altcurrency_.c_str()];
    self.probi = [NSString stringWithUTF8String:info.probi_.c_str()];
    self.balance = info.balance_;
    self.feeAmount = info.fee_amount_;
    self.parametersRange = NSArrayFromVector(info.parameters_range_);
    self.parametersChoices = NSArrayFromVector(info.parameters_choices_);
    self.parametersDays = info.parameters_days_;
    self.grants = NSArrayFromVector(info.grants_, ^(const ledger::Grant grant) {
      return [[BATLedgerGrant alloc] initWithGrant:grant];
    });
  }
  return self;
}

@end
