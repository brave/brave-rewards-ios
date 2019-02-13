/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BraveRewardsPanelController.h"

#import <BraveRewards/BATBraveLedger.h>
#import "BATBraveLedger+Private.h"

#import "NSBundle+Convenience.h"
#import "UIImage+Convenience.h"

#import "BATWalletViewController.h"
#import "BATActionButton.h"

#import "BATWalletHeaderView.h"
#import "bat/ledger/wallet_info.h"

#import "BATCreateWalletView.h"
#import "BATRewardsDisabledView.h"
#import "BATPublisherSummaryView.h"

@interface BraveRewardsPanelController ()
@property (nonatomic) BATBraveLedger *ledger;
@property (nonatomic) NSURL *url;
@property (nonatomic) BOOL isLocal;
@property (nonatomic) UIImage *favicon;

@property (nonatomic) NSArray<NSLayoutConstraint *> *walletViewLayoutConstraints;
@property (nonatomic) BATWalletViewController *walletController;

// Wallet not created
@property (nonatomic) BATCreateWalletView *createWalletView;

// Brave Rewards not enabled
@property (nonatomic) BATRewardsDisabledView *rewardsDisabledView;

// Publisher
@property (nonatomic) BATPublisherSummaryView *summaryView;

@end

@implementation BraveRewardsPanelController

- (instancetype)initWithLedger:(BATBraveLedger *)ledger url:(NSURL *)url isLocal:(BOOL)isLocal favicon:(UIImage *)favicon
{
  if ((self = [super initWithNibName:nil bundle:nil])) {
    self.ledger = ledger;
    self.url = url;
    self.isLocal = isLocal;
    self.favicon = favicon;
    
    self.walletController = [[BATWalletViewController alloc] initWithLedger:ledger];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self reloadState];
}

- (void)reloadState
{
  if (self.ledger.isWalletCreated) {
    ledger::WalletInfo _walletInfo; // FIXME: Obviously need real values
    _walletInfo.altcurrency_ = "BAT";
    _walletInfo.balance_ = 30.0;
    
    self.walletController.headerView.balanceLabel.text = [NSString stringWithFormat:@"%.1f", _walletInfo.balance_];
    self.walletController.headerView.altcurrencyTypeLabel.text = [NSString stringWithUTF8String:_walletInfo.altcurrency_.c_str()];
    self.walletController.headerView.usdBalanceLabel.text = @"0.00 USD";
    
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
    
    if (self.ledger.isEnabled) {
      self.summaryView = [[BATPublisherSummaryView alloc] init]; {
        self.summaryView.translatesAutoresizingMaskIntoConstraints = NO;
      }
      [self setupPublisher];
      self.walletController.contentView = self.summaryView;
    } else {
      self.rewardsDisabledView = [[BATRewardsDisabledView alloc] init]; {
        self.rewardsDisabledView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.rewardsDisabledView.enableRewardsButton addTarget:self action:@selector(tappedEnableBraveRewards) forControlEvents:UIControlEventTouchUpInside];
      }
      
      self.walletController.contentView = self.rewardsDisabledView;
    }
  } else {
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
  [self.createWalletView.createWalletButton setTitle:BATLocalizedString(@"BraveRewardsCreatingWallet", @"Creating Wallet").uppercaseString forState:UIControlStateNormal];
  [self.ledger createWallet:^(NSError * _Nullable error) {
    [self.createWalletView removeFromSuperview];
    self.ledger.enabled = YES;
    [self reloadState];
  }];
}

#pragma mark - Publisher

- (void)setupPublisher
{
  const auto publisherView = self.summaryView.publisherView;
  const auto attentionView = self.summaryView.attentionView;
  if (self.isLocal) {
    publisherView.publisherNameLabel.text = @"Brave Browser";
    publisherView.faviconImageView.contentMode = UIViewContentModeCenter;
//     publisherView.faviconImageView.image =
    attentionView.valueLabel.text = @"–";
  } else {
    publisherView.publisherNameLabel.text = self.url.host;
    publisherView.verifiedLabel.text = BATLocalizedString(@"BraveRewardsNotYetVerified", @"Not yet verified");
    publisherView.verificationSymbolImageView.image = [UIImage bat_imageNamed:@"icn-unverified"];
    attentionView.valueLabel.text = @"19%";
  }
}

#pragma mark - Create Wallet

- (void)learnMoreTapped
{
  
}

#pragma mark - Rewards Disabled

- (void)tappedEnableBraveRewards
{
  self.ledger.enabled = YES;
  [self reloadState];
}

@end
