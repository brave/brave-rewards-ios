/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATAddFundsViewController.h"
#import <BraveRewardsUI/BraveRewardsUI-Swift.h>

@interface BATAddFundsViewController ()
@property (nonatomic) AddFundsView *view;
@property (nonatomic) BATBraveLedger *ledger;
@end

@implementation BATAddFundsViewController
@dynamic view;

- (instancetype)initWithLedger:(BATBraveLedger *)ledger
{
  if ((self = [super initWithNibName:nil bundle:nil])) {
    self.ledger = ledger;
  }
  return self;
}

- (void)loadView
{
  self.view = [[AddFundsView alloc] init];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(tappedDone)];
  
  const auto __weak weakSelf = self;
  auto tokenViews = [[NSMutableArray alloc] init];
  if ([self.ledger.BTCAddress length] > 0) {
    auto view = [[TokenAddressView alloc] initWithTokenKind:TokenKindBitcoin];
    view.addressTextView.text = self.ledger.BTCAddress;
    view.viewQRCodeButtonTapped = ^(TokenAddressView * _Nonnull tokenView) {
      [weakSelf tappedViewTokenQRCode:tokenView];
    };
    [tokenViews addObject:view];
  }
  if ([self.ledger.ETHAddress length] > 0) {
    auto view = [[TokenAddressView alloc] initWithTokenKind:TokenKindEthereum];
    view.addressTextView.text = self.ledger.ETHAddress;
    view.viewQRCodeButtonTapped = ^(TokenAddressView * _Nonnull tokenView) {
      [weakSelf tappedViewTokenQRCode:tokenView];
    };
    [tokenViews addObject:view];
  }
  if ([self.ledger.BATAddress length] > 0) {
    auto view = [[TokenAddressView alloc] initWithTokenKind:TokenKindBasicAttentionToken];
    view.addressTextView.text = self.ledger.BATAddress;
    view.viewQRCodeButtonTapped = ^(TokenAddressView * _Nonnull tokenView) {
      [weakSelf tappedViewTokenQRCode:tokenView];
    };
    [tokenViews addObject:view];
  }
  if ([self.ledger.LTCAddress length] > 0) {
    auto view = [[TokenAddressView alloc] initWithTokenKind:TokenKindLitecoin];
    view.addressTextView.text = self.ledger.LTCAddress;
    view.viewQRCodeButtonTapped = ^(TokenAddressView * _Nonnull tokenView) {
      [weakSelf tappedViewTokenQRCode:tokenView];
    };
    [tokenViews addObject:view];
  }
  self.view.tokenViews = tokenViews;
}

- (void)tappedDone
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tappedViewTokenQRCode:(TokenAddressView *)sender
{
  for (TokenAddressView *tokenView in self.view.tokenViews) {
    if (tokenView != sender) {
      [tokenView setQRCodeWithImage:nil];
    }
  }
  NSString *qrCodeString;
  switch (sender.tokenKind) {
    case TokenKindBitcoin:
      qrCodeString = [NSString stringWithFormat:@"bitcoin:%@", self.ledger.BTCAddress];
      break;
    case TokenKindEthereum:
      qrCodeString = [NSString stringWithFormat:@"ethereum:%@", self.ledger.ETHAddress];
      break;
    case TokenKindLitecoin:
      qrCodeString = [NSString stringWithFormat:@"litecoin:%@", self.ledger.LTCAddress];
      break;
    case TokenKindBasicAttentionToken:
      qrCodeString = [NSString stringWithFormat:@"ethereum:%@", self.ledger.BATAddress];
      break;
  }
  [sender setQRCodeWithImage:[BATQRCode imageFor:qrCodeString size:CGSizeMake(90, 90)]];
}

@end
