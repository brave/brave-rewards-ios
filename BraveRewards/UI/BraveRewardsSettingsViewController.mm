/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BraveRewardsSettingsViewController.h"
#import "BATBraveLedger.h"
#import <BraveRewardsUI/BraveRewardsUI-Swift.h>

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
  
//  self.navigationController.navigationBar.translucent = NO;
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(tappedDone)];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self.view.rewardsToggleSection setRewardsEnabled:self.ledger.enabled];
  const auto __weak weakSelf = self;
  self.view.rewardsToggleSection.rewardsSwitchValueChanged = ^(BOOL enabled) {
    weakSelf.ledger.enabled = enabled;
  };
}

- (void)tappedDone
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
