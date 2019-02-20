/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATWalletViewController.h"
#import "BATBraveLedger.h"
#import "BATWalletHeaderView.h"
#import "BATPublisherSummaryView.h"
#import "BATRewardsSummaryView.h"
#import "UIColor+BATColors.h"
#import "UIImage+Convenience.h"

@interface BATWalletViewController ()
@property (nonatomic) BATBraveLedger *ledger;
@property (nonatomic) BATWalletHeaderView *headerView;
@property (nonatomic) BATRewardsSummaryView *rewardsSummaryView;
@property (nonatomic) NSLayoutConstraint *heightConstraint;
@property (nonatomic) UILayoutGuide *summaryLayoutGuide;
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
    
    self.rewardsSummaryView = [[BATRewardsSummaryView alloc] init]; {
      self.rewardsSummaryView.translatesAutoresizingMaskIntoConstraints = NO;
      [self.rewardsSummaryView.rewardsSummaryButton addTarget:self action:@selector(tappedRewardsSummaryButton) forControlEvents:UIControlEventTouchUpInside];
      self.rewardsSummaryView.monthYearLabel.text = @"MARCH 2019";
      self.rewardsSummaryView.rows = @[
        [BATRewardsSummaryRow rowWithTitle:@"Total Grants Claimed Total Grants Claimed" batValue:@"10.0" usdDollarValue:@"5.25"],
        [BATRewardsSummaryRow rowWithTitle:@"Earnings from Ads" batValue:@"10.0" usdDollarValue:@"5.25"],
        [BATRewardsSummaryRow rowWithTitle:@"Auto-Contribute" batValue:@"-10.0" usdDollarValue:@"-5.25"],
        [BATRewardsSummaryRow rowWithTitle:@"One-Time Tips" batValue:@"-2.0" usdDollarValue:@"-1.05"],
        [BATRewardsSummaryRow rowWithTitle:@"Monthly Tips" batValue:@"-19.0" usdDollarValue:@"-9.97"],
      ];
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
    [self.view insertSubview:self.rewardsSummaryView belowSubview:self.headerView];
    [NSLayoutConstraint activateConstraints:@[
      [self.contentView.bottomAnchor constraintEqualToAnchor:self.rewardsSummaryView.topAnchor],
      [self.rewardsSummaryView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
      [self.rewardsSummaryView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
      [self.rewardsSummaryView.heightAnchor constraintEqualToAnchor:self.summaryLayoutGuide.heightAnchor],
      [self.rewardsSummaryView.rewardsSummaryButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];
  } else {
    [self.rewardsSummaryView removeFromSuperview];
    [self.contentView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
  }
  
  [self.summaryLayoutGuide.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.summaryLayoutGuide = [[UILayoutGuide alloc] init];
  [self.view addLayoutGuide:self.summaryLayoutGuide];
  
  [self.view addSubview:self.headerView];
  
  self.heightConstraint = [self.view.heightAnchor constraintEqualToConstant:0.0];
  self.heightConstraint.priority = UILayoutPriorityDefaultLow; // So max-height can break it without issue
  
  [NSLayoutConstraint activateConstraints:@[
    self.heightConstraint,
    
    [self.headerView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
    [self.headerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
    [self.headerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
    
    [self.summaryLayoutGuide.topAnchor constraintEqualToAnchor:self.headerView.bottomAnchor constant:20.0],
    [self.summaryLayoutGuide.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
    [self.summaryLayoutGuide.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
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
    
    self.heightConstraint.constant = self.headerView.bounds.size.height + self.contentView.scrollView.contentSize.height + self.rewardsSummaryView.rewardsSummaryButton.bounds.size.height;
  } else {
    self.heightConstraint.constant = self.headerView.bounds.size.height + self.contentView.bounds.size.height + self.rewardsSummaryView.rewardsSummaryButton.bounds.size.height;
  }
}

#pragma mark - Rewards Summary

- (void)tappedRewardsSummaryButton
{
  BOOL expanding = self.rewardsSummaryView.transform.ty == 0;
  self.rewardsSummaryView.rewardsSummaryButton.slideToggleImageView.image = [UIImage bat_imageNamed:expanding ? @"slide-down" : @"slide-up"];
  [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.85 initialSpringVelocity:0 options:0 animations:^{
    if (expanding) {
      self.rewardsSummaryView.transform = CGAffineTransformMakeTranslation(0, -self.summaryLayoutGuide.layoutFrame.size.height + self.rewardsSummaryView.rewardsSummaryButton.bounds.size.height);
    } else {
      self.rewardsSummaryView.transform = CGAffineTransformIdentity;
    }
  } completion:nil];
  [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1000 initialSpringVelocity:0 options:0 animations:^{
    if (expanding) {
      self.contentView.alpha = 0.0;
      self.rewardsSummaryView.monthYearLabel.alpha = 1.0;
      self.view.backgroundColor = [UIColor bat_blurple800];
    } else {
      self.contentView.alpha = 1.0;
      self.rewardsSummaryView.monthYearLabel.alpha = 0.0;
      self.view.backgroundColor = [UIColor whiteColor];
    }
  } completion:nil];
}

@end
