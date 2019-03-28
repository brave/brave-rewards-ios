/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATWalletDetailsViewController.h"
#import <BraveRewardsUI/BraveRewardsUI-Swift.h>
#import "BATPopoverNavigationController.h"

#import "BATPanelState.h"
#import "bat/ledger/wallet_info.h"

@interface BATWalletDetailsViewController ()
@property (nonatomic) WalletDetailsView *view;
@end

@implementation BATWalletDetailsViewController
@dynamic view;

- (void)loadView
{
  self.view = [[WalletDetailsView alloc] init];
}

@end
