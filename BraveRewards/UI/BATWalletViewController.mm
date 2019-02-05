/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATWalletViewController.h"
#import "BATBraveLedger.h"
#import "BATWalletHeaderView.h"
#import "BATActionButton.h"
#import "BATRewardsDisabledView.h"

#import "bat/ledger/wallet_info.h"

@interface BATWalletViewController ()
@property (nonatomic) BATBraveLedger *ledger;
@property (nonatomic) BATWalletHeaderView *headerView;
@property (nonatomic) NSLayoutConstraint *heightConstraint;
@property (nonatomic) BATRewardsDisabledView *rewardsDisabledView;
@end

@implementation BATWalletViewController

- (instancetype)initWithLedger:(BATBraveLedger *)ledger
{
  if ((self = [super initWithNibName:nil bundle:nil])) {
    self.ledger = ledger;
    
    self.headerView = [[BATWalletHeaderView alloc] init]; {
      self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
      
      ledger::WalletInfo _walletInfo; // FIXME: Obviously need real values
      _walletInfo.altcurrency_ = "BAT";
      _walletInfo.balance_ = 30.0;
      
      self.headerView.balanceLabel.text = [NSString stringWithFormat:@"%.1f", _walletInfo.balance_];
      self.headerView.altcurrencyTypeLabel.text = [NSString stringWithUTF8String:_walletInfo.altcurrency_.c_str()];
      self.headerView.usdBalanceLabel.text = @"0.00 USD";
      
      [self.headerView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    
    self.rewardsDisabledView = [[BATRewardsDisabledView alloc] init]; {
      self.rewardsDisabledView.translatesAutoresizingMaskIntoConstraints = NO;
      [self.rewardsDisabledView.enableRewardsButton addTarget:self action:@selector(tappedEnableBraveRewards) forControlEvents:UIControlEventTouchUpInside];
    }
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self.view addSubview:self.rewardsDisabledView];
  [self.view addSubview:self.headerView];
  
  self.heightConstraint = [self.view.heightAnchor constraintEqualToConstant:0.0];
  self.heightConstraint.priority = UILayoutPriorityDefaultLow; // So max-height can break it without issue
  
  [NSLayoutConstraint activateConstraints:@[
    self.heightConstraint,
    
    [self.headerView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
    [self.headerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
    [self.headerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
    
    [self.rewardsDisabledView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
    [self.rewardsDisabledView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
    [self.rewardsDisabledView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
    [self.rewardsDisabledView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
  ]];
}

#pragma mark -

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  
  [self.headerView layoutIfNeeded];
  self.rewardsDisabledView.scrollView.contentInset = UIEdgeInsetsMake(self.headerView.bounds.size.height, 0, 0, 0);
  self.rewardsDisabledView.scrollView.scrollIndicatorInsets = self.rewardsDisabledView.scrollView.contentInset;
  self.rewardsDisabledView.scrollView.contentOffset = CGPointMake(0, -self.headerView.bounds.size.height); // Make sure it shows the top part of the view
  
  [self.rewardsDisabledView layoutIfNeeded];
  self.heightConstraint.constant = self.headerView.bounds.size.height + self.rewardsDisabledView.scrollView.contentSize.height;
}

- (void)tappedEnableBraveRewards
{
  self.ledger.enabled = YES;
}

@end
