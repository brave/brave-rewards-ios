/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BraveRewardsPanelController.h"
#import <BraveRewardsUI/BraveRewardsUI-Swift.h>

#import <BraveRewards/BATBraveLedger.h>
#import "BATBraveLedger+Private.h"

#import "bat/ledger/wallet_info.h"

#import "BATCreateWalletViewController.h"
#import "BATPublisherViewController.h"

@interface BraveRewardsPanelController ()
@end

@implementation BraveRewardsPanelController

+ (UIImage *)batLogoImage
{
  return [UIImage imageNamed:@"bat" inBundle:[NSBundle bundleForClass:[CreateWalletView class]] compatibleWithTraitCollection:nil];
}

- (instancetype)initWithLedger:(BATBraveLedger *)ledger url:(NSURL *)url faviconURL:(NSURL *)faviconURL delegate:(id<BraveRewardsDelegate>)delegate dataSource:(id<BraveRewardsDataSource>)dataSource
{
  if ((self = [super init])) {
    const auto panelState = [[BATPanelState alloc] init];
    panelState.ledger = ledger;
    panelState.url = url;
    panelState.faviconURL = faviconURL;
    panelState.delegate = delegate;
    panelState.dataSource = dataSource;
    
    if (!ledger.walletCreated) {
      self.viewControllers = @[ [[BATCreateWalletViewController alloc] initWithPanelState:panelState] ];
    } else {
      self.viewControllers = @[ [[BATPublisherViewController alloc] initWithPanelState:panelState] ];
    }
  }
  return self;
}

@end
