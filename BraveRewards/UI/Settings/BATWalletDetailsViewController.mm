/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATWalletDetailsViewController.h"
#import <BraveRewardsUI/BraveRewardsUI-Swift.h>
#import "BATPopoverNavigationController.h"
#import "BATAddFundsViewController.h"

#import "BATPanelState.h"
#import "bat/ledger/wallet_info.h"

@interface BATWalletDetailsViewController ()
@property (nonatomic) WalletDetailsView *view;
@property (nonatomic) BATBraveLedger *ledger;
@end

@implementation BATWalletDetailsViewController
@dynamic view;

- (instancetype)initWithLedger:(BATBraveLedger *)ledger
{
  if ((self = [super initWithNibName:nil bundle:nil])) {
    self.ledger = ledger;
  }
  return self;
}

- (void)loadView
{
  self.view = [[WalletDetailsView alloc] init];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self.view.walletSection.addFundsButton addTarget:self action:@selector(addFundsTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addFundsTapped
{
  const auto controller = [[BATAddFundsViewController alloc] initWithLedger:self.ledger];
  const auto container = [[BATPopoverNavigationController alloc] initWithRootViewController:controller];
  container.modalPresentationStyle = UIModalPresentationCurrentContext;
  [self presentViewController:container animated:YES completion:nil];
}

@end
