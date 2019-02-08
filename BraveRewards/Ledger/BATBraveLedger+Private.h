/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATBraveLedger.h"

@interface BATBraveLedger (Private)

- (void)handleUpdatedWallet:(ledger::Result)result walletInfo:(std::unique_ptr<ledger::WalletInfo>)info;

@end
