/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATWalletViewController.h"
#import "BATBraveLedger.h"
#import "BATWalletHeaderView.h"
#import "BATRewardsDisabledView.h"
#import "BATActionButton.h"
#import "BATGradientView.h"

#import "bat/ledger/wallet_info.h"

@interface BATWalletViewController ()
@property (nonatomic) BATBraveLedger *ledger;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) BATWalletHeaderView *headerView;
@property (nonatomic) BATGradientView *gradientView;
@property (nonatomic) BATRewardsDisabledView *disabledRewardsView;
@property (nonatomic) NSLayoutConstraint *heightConstraint;
@end

@implementation BATWalletViewController

- (instancetype)initWithLedger:(BATBraveLedger *)ledger
{
  if ((self = [super initWithNibName:nil bundle:nil])) {
    self.ledger = ledger;
    
    self.scrollView = [[UIScrollView alloc] init]; {
      self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
      self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
      self.scrollView.alwaysBounceVertical = YES;
      self.scrollView.delaysContentTouches = NO;
    }
    
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
    
    self.gradientView = [BATGradientView softBlueToClearGradientView]; {
      self.gradientView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.disabledRewardsView = [[BATRewardsDisabledView alloc] init]; {
      self.disabledRewardsView.translatesAutoresizingMaskIntoConstraints = NO;
      [self.disabledRewardsView.enableRewardsButton addTarget:self action:@selector(tappedEnableBraveRewards) forControlEvents:UIControlEventTouchUpInside];
    }
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self.view addSubview:self.gradientView];
  [self.view addSubview:self.scrollView];
  [self.view addSubview:self.headerView];
  [self.scrollView addSubview:self.disabledRewardsView];
  
  self.heightConstraint = [self.view.heightAnchor constraintEqualToConstant:UIScreen.mainScreen.bounds.size.height];
  self.heightConstraint.priority = UILayoutPriorityDefaultLow;
  
  [NSLayoutConstraint activateConstraints:@[
    self.heightConstraint,
    
    [self.scrollView.contentLayoutGuide.widthAnchor constraintEqualToAnchor:self.view.widthAnchor],
                                            
    [self.headerView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
    [self.headerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
    [self.headerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
    
    [self.scrollView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
    [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
    [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
    [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    
    [self.gradientView.topAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
    [self.gradientView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    [self.gradientView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
    [self.gradientView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
    
    [self.disabledRewardsView.topAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.topAnchor],
    [self.disabledRewardsView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
    [self.disabledRewardsView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
    [self.scrollView.contentLayoutGuide.bottomAnchor constraintEqualToAnchor:self.disabledRewardsView.bottomAnchor],
  ]];
}

#pragma mark -

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  
  [self.headerView layoutIfNeeded];
  self.scrollView.contentInset = UIEdgeInsetsMake(self.headerView.bounds.size.height, 0, 0, 0);
  
  [self.disabledRewardsView layoutIfNeeded];
  self.heightConstraint.constant = self.headerView.bounds.size.height + self.disabledRewardsView.bounds.size.height;
}

- (void)tappedEnableBraveRewards
{
  self.ledger.enabled = YES;
}

@end
