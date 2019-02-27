/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BraveRewardsPanelController.h"
#import <BraveRewardsUI/BraveRewardsUI-Swift.h>

#import <BraveRewards/BATBraveLedger.h>
#import "BATBraveLedger+Private.h"

#import "bat/ledger/wallet_info.h"

@interface BraveRewardsPanelController ()
@property (nonatomic) BATBraveLedger *ledger;
@property (nonatomic) NSURL *url;
@property (nonatomic) BOOL isLocal;
@property (nonatomic) NSURL *faviconURL;

@property (nonatomic) NSArray<NSLayoutConstraint *> *walletViewLayoutConstraints;
@property (nonatomic) WalletViewController *walletController;

// Wallet not created
@property (nonatomic) CreateWalletView *createWalletView;

// Brave Rewards not enabled
@property (nonatomic) RewardsDisabledView *rewardsDisabledView;

// Publisher
@property (nonatomic) PublisherSummaryView *summaryView;

@end

@implementation BraveRewardsPanelController

+ (UIImage *)batLogoImage
{
  return [UIImage imageNamed:@"bat" inBundle:[NSBundle bundleForClass:[CreateWalletView class]] compatibleWithTraitCollection:nil];
}

- (instancetype)initWithLedger:(BATBraveLedger *)ledger url:(NSURL *)url faviconURL:(NSURL *)faviconURL
{
  if ((self = [super initWithNibName:nil bundle:nil])) {
    self.ledger = ledger;
    self.url = url;
    self.isLocal = [url.host isEqualToString:@"127.0.0.1"] || [url.host isEqualToString:@"localhost"];
    self.faviconURL = faviconURL;
    
    self.walletController = [[WalletViewController alloc] init];
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
    
    if (self.ledger.isEnabled) {
      self.summaryView = [[PublisherSummaryView alloc] init]; {
        self.summaryView.translatesAutoresizingMaskIntoConstraints = NO;
      }
      [self setupPublisher];
      self.walletController.contentView = self.summaryView;
    } else {
      self.rewardsDisabledView = [[RewardsDisabledView alloc] init]; {
        self.rewardsDisabledView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.rewardsDisabledView.enableRewardsButton addTarget:self action:@selector(tappedEnableBraveRewards) forControlEvents:UIControlEventTouchUpInside];
      }
      
      self.walletController.contentView = self.rewardsDisabledView;
    }
  } else {
    self.createWalletView = [[CreateWalletView alloc] init];
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
  self.createWalletView.isCreatingWallet = YES;
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
    [publisherView setVerifiedStatus:true];
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
