/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BraveRewardsPublisherViewController.h"
#import <BraveRewardsUI/BraveRewardsUI-Swift.h>
#import "BATBraveLedger.h"
#import "bat/ledger/wallet_info.h"

#import "BraveRewardsSettingsViewController.h"
#import "BraveRewardsTippingViewController.h"
#import "BraveRewardsDataDelegate.h"
#import "BraveRewardsDataDelegate.h"

@interface BraveRewardsPublisherViewController ()
@property (nonatomic, strong) BATPanelState *panelState;

@property (nonatomic) NSArray<NSLayoutConstraint *> *walletViewLayoutConstraints;
@property (nonatomic) WalletViewController *walletController;
// Brave Rewards not enabled
@property (nonatomic) RewardsDisabledView *rewardsDisabledView;
// Publisher
@property (nonatomic) PublisherSummaryView *publisherSummaryView;
@end

@implementation BraveRewardsPublisherViewController

- (instancetype)initWithPanelState:(BATPanelState *)panelState
{
  if ((self = [super initWithNibName:nil bundle:nil])) {
    self.panelState = panelState;
  }
  return self;
}

- (void)loadView
{
  self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BATPreferredPanelWidth, BATPreferredPanelHeight)];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor whiteColor];
  self.view.clipsToBounds = YES;
  
  [self.navigationController setNavigationBarHidden:YES animated:NO];
  
  self.walletController = [[WalletViewController alloc] init];
  [self.walletController.headerView.addFundsButton addTarget:self action:@selector(tappedAddFunds) forControlEvents:UIControlEventTouchUpInside];
  [self.walletController.headerView.settingsButton addTarget:self action:@selector(tappedSettings) forControlEvents:UIControlEventTouchUpInside];
  
  [self reloadState];
  [self.view layoutIfNeeded];
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  
  const auto scrollView = self.walletController.contentView.innerScrollView;
  CGFloat height = 0.0;
  if (scrollView) {
    scrollView.contentInset = UIEdgeInsetsMake(self.walletController.headerView.bounds.size.height, 0, 0, 0);
    scrollView.scrollIndicatorInsets = scrollView.contentInset;
    
    height = self.walletController.headerView.bounds.size.height + scrollView.contentSize.height + self.walletController.rewardsSummaryView.rewardsSummaryButton.bounds.size.height;
  } else {
    height = self.walletController.headerView.bounds.size.height + self.walletController.contentView.bounds.size.height + self.walletController.rewardsSummaryView.rewardsSummaryButton.bounds.size.height;
  }
  if (self.panelState.ledger.enabled) {
    height = BATPreferredPanelHeight;
  }
  self.preferredContentSize = CGSizeMake(BATPreferredPanelWidth, height);
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark -

- (BOOL)isLocal
{
  return [self.panelState.url.host isEqualToString:@"127.0.0.1"] || [self.panelState.url.host isEqualToString:@"localhost"];
}

- (void)reloadState
{
//  if (self.ledger.isWalletCreated) {
    ledger::WalletInfo _walletInfo; // FIXME: Obviously need real values
    _walletInfo.altcurrency_ = "BAT";
    _walletInfo.balance_ = 30.0;
    
    [self.walletController.headerView setWalletBalance:[NSString stringWithFormat:@"%.1f", _walletInfo.balance_]
                                                crypto:[NSString stringWithUTF8String:_walletInfo.altcurrency_.c_str()]
                                           dollarValue:@"0.00 USD"];
    
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
    
    if (self.panelState.ledger.enabled) {
      self.publisherSummaryView = [[PublisherSummaryView alloc] init]; {
        self.publisherSummaryView.translatesAutoresizingMaskIntoConstraints = NO;
      }
      [self setupPublisher];
      self.walletController.contentView = self.publisherSummaryView;
    } else {
      self.rewardsDisabledView = [[RewardsDisabledView alloc] init]; {
        self.rewardsDisabledView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.rewardsDisabledView.enableRewardsButton addTarget:self action:@selector(tappedEnableBraveRewards) forControlEvents:UIControlEventTouchUpInside];
      }
      
      self.walletController.contentView = self.rewardsDisabledView;
    }
}


#pragma mark - Publisher

- (void)setupPublisher
{
  [self.publisherSummaryView.tipButton addTarget:self action:@selector(tappedSendTip) forControlEvents:UIControlEventTouchUpInside];
  
  const auto publisherView = self.publisherSummaryView.publisherView;
  const auto attentionView = self.publisherSummaryView.attentionView;
  
  [publisherView setVerificationStatusHidden:self.isLocal];
  
  // FIXME: Remove fake data
  [self.publisherSummaryView setLocal:self.isLocal];
  if (!self.isLocal) {
    publisherView.publisherNameLabel.text = self.panelState.url.host;
    [publisherView setVerifiedStatus:YES];
    attentionView.valueLabel.text = @"19%";
    
    const auto __weak weakSelf = self;
    [self.panelState.dataSource retrieveFaviconWithURL:self.panelState.faviconURL completion:^(UIImage * _Nullable image) {
      weakSelf.publisherSummaryView.publisherView.faviconImageView.image = image;
    }];
  }
}

- (void)tappedSendTip
{
  const auto controller = [[BraveRewardsTippingViewController alloc] initWithLedger:self.panelState.ledger
                                                                        publisherId:@""]; // TODO: Pass publisher id
  [self.panelState.delegate presentBraveRewardsController:controller];
}

#pragma mark -

- (void)tappedAddFunds
{
  
}

- (void)tappedSettings
{
  const auto settingsController = [[BraveRewardsSettingsViewController alloc] initWithLedger:self.panelState.ledger];
  [self showViewController:settingsController sender:self];
}

#pragma mark - Rewards Disabled

- (void)tappedEnableBraveRewards
{
  self.panelState.ledger.enabled = YES;
  [self reloadState];
}


@end
