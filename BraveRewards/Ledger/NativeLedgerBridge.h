/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <Foundation/Foundation.h>

#import "bat/ledger/ledger.h"

#import <string>

NS_ASSUME_NONNULL_BEGIN

@protocol NativeLedgerBridge <NSObject>
@required

- (void)walletInitialized:(ledger::Result)result;
- (void)onWalletProperties:(ledger::Result)result info:(std::unique_ptr<ledger::WalletInfo>)info;
- (void)onGrantCaptcha:(std::string)image hint:(std::string)hint;

//void OnGrant(Result result, const Grant& grant) override;
//void OnRecoverWallet(Result result, double balance, const std::vector<Grant>& grants) override;
//void OnReconcileComplete(Result result,
//                         const std::string& viewing_id,
//                         REWARDS_CATEGORY category,
//                         const std::string& probi) override;
//void OnGrantFinish(Result result, const Grant& grant) override;

@end

NS_ASSUME_NONNULL_END
