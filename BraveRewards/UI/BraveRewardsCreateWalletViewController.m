/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BraveRewardsCreateWalletViewController.h"
#import <BraveRewardsUI/BraveRewardsUI-Swift.h>

#import "BraveRewardsPublisherViewController.h"
#import "BATBraveLedger.h"

@interface BraveRewardsCreateWalletViewController ()
@property (nonatomic) BATPanelState *panelState;
@property (nonatomic) CreateWalletView *view;
@end

@implementation BraveRewardsCreateWalletViewController
@dynamic view;

- (instancetype)initWithPanelState:(BATPanelState *)panelState
{
  if ((self = [super initWithNibName:nil bundle:nil])) {
    self.panelState = panelState;
  }
  return self;
}

- (void)loadView
{
  self.view = [[CreateWalletView alloc] initWithFrame:UIScreen.mainScreen.bounds];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self.navigationController setNavigationBarHidden:YES animated:NO];
  
  [self.view.createWalletButton addTarget:self action:@selector(tappedCreateWallet) forControlEvents:UIControlEventTouchUpInside];
  [self.view.learnMoreButton addTarget:self action:@selector(learnMoreTapped) forControlEvents:UIControlEventTouchUpInside];
  
  self.preferredContentSize = [self.view systemLayoutSizeFittingSize:CGSizeMake(BATPreferredPanelWidth, UIScreen.mainScreen.bounds.size.height)
                                       withHorizontalFittingPriority:UILayoutPriorityRequired
                                             verticalFittingPriority:UILayoutPriorityFittingSizeLevel];
}

#pragma mark - Create Wallet

- (void)tappedCreateWallet
{
  self.view.isCreatingWallet = YES;
  [self.panelState.ledger createWallet:^(NSError * _Nullable error) {
    if (error) {
      self.view.isCreatingWallet = NO;
      const __auto_type alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
      [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
      [self presentViewController:alertController animated:YES completion:nil];
      return;
    }
    self.panelState.ledger.enabled = YES;
    
    __auto_type controller = [[BraveRewardsPublisherViewController alloc] initWithPanelState:self.panelState];
    [self showViewController:controller sender:self];
  }];
}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
  
  __auto_type navControllers = self.navigationController.viewControllers;
  if (navControllers.firstObject == self) {
    self.navigationController.viewControllers = [navControllers subarrayWithRange:NSMakeRange(1, navControllers.count-1)];
  }
}

- (void)learnMoreTapped
{
  
}

@end
