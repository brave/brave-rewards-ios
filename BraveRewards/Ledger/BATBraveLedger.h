/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <Foundation/Foundation.h>

@class BATBraveLedger, BATLedgerWalletInfo;

NS_ASSUME_NONNULL_BEGIN

/// The error domain for ledger related errors
extern NSString * const BATBraveLedgerErrorDomain;

@protocol BATBraveLedgerDelegate <NSObject>
@required

/// The user's wallet was updated
- (void)ledger:(BATBraveLedger *)ledger updatedWallet:(BATLedgerWalletInfo *)wallet;

@end

NS_SWIFT_NAME(BraveLedger)
@interface BATBraveLedger : NSObject

@property (nonatomic, weak) id<BATBraveLedgerDelegate> delegate;

#pragma mark - Wallet

/// Creates a cryptocurrency wallet
- (void)createWallet:(void (^)(NSError * _Nullable error))completion;

#pragma mark - Publishers

#pragma mark - Preferences

@end

NS_ASSUME_NONNULL_END
