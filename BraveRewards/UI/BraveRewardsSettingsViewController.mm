/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BraveRewardsSettingsViewController.h"
#import "BATBraveLedger.h"
#import "BATPanelState.h"
#import <BraveRewardsUI/BraveRewardsUI-Swift.h>
#import "BATPopoverNavigationController.h"

#import "bat/ledger/wallet_info.h"

@interface BraveRewardsSettingsViewController ()
@property (nonatomic) BATBraveLedger *ledger;
@property (nonatomic) SettingsView *view;
@end

@implementation BraveRewardsSettingsViewController
@dynamic view;

- (instancetype)initWithLedger:(BATBraveLedger *)ledger
{
  if ((self = [super initWithNibName:nil bundle:nil])) {
    self.ledger = ledger;
    
    self.modalPresentationStyle = UIModalPresentationFormSheet;
  }
  return self;
}

- (void)loadView
{
  self.view = [[SettingsView alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(tappedDone)];
  
  self.preferredContentSize = CGSizeMake(BATPreferredPanelWidth, 750);
  
  const auto __weak weakSelf = self;
  self.view.rewardsToggleSection.rewardsSwitchValueChanged = ^(BOOL enabled) {
    [weakSelf rewardsSwitchValueChanged:enabled];
  };
  
  [self.view.grantSection.claimGrantButton addTarget:self action:@selector(tappedClaimGrant) forControlEvents:UIControlEventTouchUpInside];
  
  ledger::WalletInfo _walletInfo; // FIXME: Obviously need real values
  _walletInfo.altcurrency_ = "BAT";
  _walletInfo.balance_ = 30.0;
  
  [self.view.walletSection setWalletBalance:[NSString stringWithFormat:@"%.1f", _walletInfo.balance_]
                                     crypto:[NSString stringWithUTF8String:_walletInfo.altcurrency_.c_str()]
                                dollarValue:@"0.00 USD"];
  
  [self.view.autoContributeSection.toggleSwitch addTarget:self action:@selector(autoContributeToggleValueChanged) forControlEvents:UIControlEventValueChanged];
  
  [self updateVisualStateOfSections:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  // Not sure why this has to be set on the nav controller specifically instead of just this controller
  self.navigationController.preferredContentSize = CGSizeMake(355, 1000);
}

#pragma mark -

- (void)updateVisualStateOfSections:(BOOL)animated
{
  // The sections in this controller change a bit based on whether or not Brave Rewards is enabled (or their
  // individual setting is disabled, in the case of auto-contribution)
  
  [self.view.rewardsToggleSection setRewardsEnabled:self.ledger.enabled animated:animated];
  self.view.autoContributeSection.toggleSwitch.on = self.ledger.autoContributeEnabled;
  [self.view.autoContributeSection setSectionEnabled:self.ledger.enabled && self.ledger.autoContributeEnabled
                                         hidesToggle:!self.ledger.enabled
                                            animated:animated];
  [self.view.tipsSection setSectionEnabled:self.ledger.enabled animated:animated];
}

#pragma mark - Actions

- (void)rewardsSwitchValueChanged:(BOOL)enabled
{
  self.ledger.enabled = enabled;
  [self updateVisualStateOfSections:YES];
}

- (void)autoContributeToggleValueChanged
{
  self.ledger.autoContributeEnabled = self.view.autoContributeSection.toggleSwitch.on;
  [self updateVisualStateOfSections:YES];
}

- (void)tappedDone
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tappedClaimGrant
{
  self.navigationController.definesPresentationContext = YES;
  const auto controller = [[BraveRewardsSettingsViewController alloc] initWithLedger:self.ledger];
  const auto container = [[BATPopoverNavigationController alloc] initWithRootViewController:controller];
  container.modalPresentationStyle = UIModalPresentationCurrentContext;
  [self presentViewController:container animated:YES completion:nil];
}

@end
