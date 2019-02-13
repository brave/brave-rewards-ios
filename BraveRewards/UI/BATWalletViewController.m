/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATWalletViewController.h"
#import "BATBraveLedger.h"
#import "BATWalletHeaderView.h"
#import "BATPublisherSummaryView.h"
#import "BATRewardsSummaryButton.h"

@interface BATWalletViewController ()
@property (nonatomic) BATBraveLedger *ledger;
@property (nonatomic) BATWalletHeaderView *headerView;
@property (nonatomic) BATRewardsSummaryButton *rewardsSummaryButton;
@property (nonatomic) NSLayoutConstraint *heightConstraint;
@end

@implementation BATWalletViewController

- (instancetype)initWithLedger:(BATBraveLedger *)ledger
{
  if ((self = [super initWithNibName:nil bundle:nil])) {
    self.ledger = ledger;
    
    self.headerView = [[BATWalletHeaderView alloc] init]; {
      self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
      [self.headerView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    
    self.rewardsSummaryButton = [[BATRewardsSummaryButton alloc] init]; {
      self.rewardsSummaryButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
  }
  return self;
}

- (void)setContentView:(UIView<BATWalletContentView> *)contentView
{
  [_contentView removeFromSuperview];
  _contentView = contentView;
  
  if ([self isViewLoaded]) {
    [self setupContentView];
  }
}

- (void)setupContentView
{
  if (!self.contentView) return;
  
  [self.view insertSubview:self.contentView belowSubview:self.headerView];
  
  if (self.contentView.scrollView != nil) {
    [self.contentView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
  } else {
    [self.contentView.topAnchor constraintEqualToAnchor:self.headerView.bottomAnchor].active = YES;
  }
  [NSLayoutConstraint activateConstraints:@[
    [self.contentView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
    [self.contentView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
  ]];
  if (self.contentView.displayRewardsSummaryButton) {
    [self.view addSubview:self.rewardsSummaryButton];
    [NSLayoutConstraint activateConstraints:@[
      [self.contentView.bottomAnchor constraintEqualToAnchor:self.rewardsSummaryButton.topAnchor],
      [self.rewardsSummaryButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
      [self.rewardsSummaryButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
      [self.rewardsSummaryButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
      [self.rewardsSummaryButton.heightAnchor constraintEqualToConstant:48.0],
    ]];
  } else {
    [self.rewardsSummaryButton removeFromSuperview];
    [self.contentView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
  }
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self.view addSubview:self.headerView];
  
  self.heightConstraint = [self.view.heightAnchor constraintEqualToConstant:0.0];
  self.heightConstraint.priority = UILayoutPriorityDefaultLow; // So max-height can break it without issue
  
  [NSLayoutConstraint activateConstraints:@[
    self.heightConstraint,
    
    [self.headerView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
    [self.headerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
    [self.headerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
  ]];
  
  [self setupContentView];
}

#pragma mark -

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  
  [self.headerView layoutIfNeeded];
  [self.contentView layoutIfNeeded];
  
  if (self.contentView.scrollView) {
    self.contentView.scrollView.contentInset = UIEdgeInsetsMake(self.headerView.bounds.size.height, 0, 0, 0);
    self.contentView.scrollView.scrollIndicatorInsets = self.contentView.scrollView.contentInset;
    self.contentView.scrollView.contentOffset = CGPointMake(0, -self.headerView.bounds.size.height); // Make sure it shows the top part of the view
    
    self.heightConstraint.constant = self.headerView.bounds.size.height + self.contentView.scrollView.contentSize.height + self.rewardsSummaryButton.bounds.size.height;
  } else {
    self.heightConstraint.constant = self.headerView.bounds.size.height + self.contentView.bounds.size.height + self.rewardsSummaryButton.bounds.size.height;
  }
}

@end
