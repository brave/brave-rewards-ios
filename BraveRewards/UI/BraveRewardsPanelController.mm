/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BraveRewardsPanelController.h"

#import <BraveRewards/BATBraveLedger.h>

#import "BATCreateWalletView.h"
#import "BATWalletViewController.h"
#import "BATActionButton.h"

@interface BraveRewardsPanelController ()
@property (nonatomic) BATBraveLedger *ledger;
@property (nonatomic) NSArray<NSLayoutConstraint *> *walletViewLayoutConstraints;
@property (nonatomic) BATCreateWalletView *createWalletView;
@property (nonatomic) BATWalletViewController *walletController;
@end

@implementation BraveRewardsPanelController

- (instancetype)init
{
  if ((self = [super initWithNibName:nil bundle:nil])) {
    self.ledger = [[BATBraveLedger alloc] init];
    self.walletController = [[BATWalletViewController alloc] init];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  if (!self.ledger.isWalletCreated) {
    self.createWalletView = [[BATCreateWalletView alloc] init];
    self.createWalletView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.createWalletView.createWalletButton addTarget:self action:@selector(createWalletTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.createWalletView.learnMoreButton addTarget:self action:@selector(learnMoreTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.createWalletView];
    
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.walletViewLayoutConstraints = @[
      [self.createWalletView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
      [self.createWalletView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
      [self.createWalletView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
      [self.createWalletView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
    ];
    [NSLayoutConstraint activateConstraints:self.walletViewLayoutConstraints];
  }
}

#pragma mark -

- (void)createWalletTapped
{
  [self.createWalletView removeFromSuperview];
  [self addChildViewController:self.walletController];
  [self.walletController didMoveToParentViewController:self];
  [self.view addSubview:self.walletController.view];
  self.walletController.view.translatesAutoresizingMaskIntoConstraints = NO;
  [NSLayoutConstraint activateConstraints:@[
    [self.walletController.view.topAnchor constraintEqualToAnchor:self.view.topAnchor],
    [self.walletController.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    [self.walletController.view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
    [self.walletController.view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
  ]];
}

- (void)learnMoreTapped
{
  
}

@end
