/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <Foundation/Foundation.h>

@class BATLedgerGrant;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(WalletInfo)
@interface BATLedgerWalletInfo : NSObject
/// What kind of currency or utility token is in use (will be "BAT" in this case)
@property (nonatomic, readonly, copy) NSString *altcurrency;
/// The probi amount (10^18 wei)
@property (nonatomic, readonly, copy) NSString *probi;
@property (nonatomic, readonly) double balance;
@property (nonatomic, readonly) double feeAmount;
@property (nonatomic, readonly, copy) NSArray<NSNumber *> *parametersChoices;
@property (nonatomic, readonly, copy) NSArray<NSNumber *> *parametersRange;
@property (nonatomic, readonly) int parametersDays;
@property (nonatomic, readonly, copy) NSArray<BATLedgerGrant *> *grants;

@end

NS_ASSUME_NONNULL_END
