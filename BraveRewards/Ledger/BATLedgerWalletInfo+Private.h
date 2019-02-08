/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATLedgerWalletInfo.h"

#import "bat/ledger/wallet_info.h"

@interface BATLedgerGrant (Private)

- (instancetype)initWithWalletInfo:(const ledger::WalletInfo&)info;

@end
