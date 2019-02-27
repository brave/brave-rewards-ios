/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BraveRewardsPanelController.h"
#import <BraveRewardsUI/BraveRewardsUI-Swift.h>

#import <BraveRewards/BATBraveLedger.h>
#import "BATBraveLedger+Private.h"

#import "bat/ledger/wallet_info.h"

#import "BraveRewardsTippingViewController.h"

@interface BraveRewardsPanelController ()
@property (nonatomic) BATBraveLedger *ledger;
@property (readonly) BOOL isLocal;

@property (nonatomic) NSArray<NSLayoutConstraint *> *walletViewLayoutConstraints;
@property (nonatomic) WalletViewController *walletController;

// Wallet not created
@property (nonatomic) CreateWalletView *createWalletView;

// Brave Rewards not enabled
@property (nonatomic) RewardsDisabledView *rewardsDisabledView;

// Publisher
@property (nonatomic) PublisherSummaryView *publisherSummaryView;

@end

@implementation BraveRewardsPanelController

+ (UIImage *)batLogoImage
{
  return [UIImage imageNamed:@"bat" inBundle:[NSBundle bundleForClass:[CreateWalletView class]] compatibleWithTraitCollection:nil];
}

- (instancetype)initWithLedger:(BATBraveLedger *)ledger url:(NSURL *)url faviconURL:(NSURL *)faviconURL delegate:(id<BraveRewardsDelegate>)delegate dataSource:(id<BraveRewardsDataSource>)dataSource
{
  if ((self = [super initWithNibName:nil bundle:nil])) {
    self.ledger = ledger;
    self.url = url;
    self.faviconURL = faviconURL;
    self.dataSource = dataSource;
    self.delegate = delegate;
    
    self.walletController = [[WalletViewController alloc] init];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self reloadState];
  
  const auto minimumHeightConstraint = [self.view.heightAnchor constraintGreaterThanOrEqualToConstant:574.0];
  minimumHeightConstraint.priority = UILayoutPriorityDefaultHigh;
  minimumHeightConstraint.active = YES;
}

- (BOOL)isLocal
{
  return [self.url.host isEqualToString:@"127.0.0.1"] || [self.url.host isEqualToString:@"localhost"];
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
  [self.publisherSummaryView.tipButton addTarget:self action:@selector(tappedSendTip) forControlEvents:UIControlEventTouchUpInside];
  
  const auto publisherView = self.publisherSummaryView.publisherView;
  const auto attentionView = self.publisherSummaryView.attentionView;
  
  [publisherView setVerificationStatusHidden:self.isLocal];
  
  // FIXME: Remove fake data
  if (self.isLocal) {
    publisherView.publisherNameLabel.text = @"Brave Browser";
    publisherView.faviconImageView.contentMode = UIViewContentModeCenter;
    attentionView.valueLabel.text = @"–";
  } else {
    publisherView.publisherNameLabel.text = self.url.host;
    [publisherView setVerifiedStatus:YES];
    attentionView.valueLabel.text = @"19%";
  }
  
  const auto __weak weakSelf = self;
  [self.dataSource retrieveFaviconWithURL:self.faviconURL completion:^(UIImage * _Nullable image) {
    weakSelf.publisherSummaryView.publisherView.faviconImageView.image = image;
  }];
}

- (void)tappedSendTip
{
  const auto controller = [[BraveRewardsTippingViewController alloc] initWithLedger:self.ledger
                                                                        publisherId:@""]; // TODO: Pass publisher id
  [self.delegate presentBraveRewardsController:controller];
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
