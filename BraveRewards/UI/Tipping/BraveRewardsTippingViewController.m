/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BraveRewardsTippingViewController.h"
#import "BATTippingView.h"

// Temp:
#import "BATTippingAmountView.h"
#import "UIImage+Convenience.h"

@interface BraveRewardsTippingViewController ()
@property (nonatomic) BATTippingView *tippingView;
@end

@implementation BraveRewardsTippingViewController

- (instancetype)init
{
  if ((self = [super initWithNibName:nil bundle:nil])) {
    self.tippingView = [[BATTippingView alloc] init];
    self.tippingView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // FIXME: Remove fake data
    self.tippingView.walletBalanceCryptoLabel.text = @"BAT";
    self.tippingView.walletBalanceValueLabel.text = @"30";
    
    for (NSNumber *value in @[ @(1), @(5), @(10) ]) {
      BATTippingAmountView *view = [[BATTippingAmountView alloc] init];
      view.cryptoLabel.text = @"BAT";
      view.cryptoLogoImageView.image = [UIImage bat_imageNamed:@"bat"];
      view.valueLabel.text = value.stringValue;
      view.dollarLabel.text = @"0.00 USD";
      [self.tippingView.amountStackView addArrangedSubview:view];
      
      if (value.integerValue == 5) {
        view.selected = YES;
      }
    }
  }
  return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
  [self.view addSubview:self.tippingView];
  
  [NSLayoutConstraint activateConstraints:@[
    [self.tippingView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    [self.tippingView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
    [self.tippingView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
  ]];
}


@end
