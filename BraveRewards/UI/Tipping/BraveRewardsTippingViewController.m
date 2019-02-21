/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BraveRewardsTippingViewController.h"
#import "BATTippingView.h"
#import "BATTippingOverviewView.h"

// Temp:
#import "BATTippingAmountView.h"
#import "UIImage+Convenience.h"

@interface BraveRewardsTippingViewController ()
@property (nonatomic) UIView *backgroundView;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) BATTippingOverviewView *overviewView;
@property (nonatomic) BATTippingView *tippingView;
@end

@implementation BraveRewardsTippingViewController

- (instancetype)init
{
  if ((self = [super initWithNibName:nil bundle:nil])) {
    self.backgroundView = [[UIView alloc] init]; {
      self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
      self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.scrollView = [[UIScrollView alloc] init]; {
      self.scrollView.alwaysBounceVertical = YES;
      self.scrollView.showsVerticalScrollIndicator = NO;
      self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.overviewView = [[BATTippingOverviewView alloc] init];
    self.overviewView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.tippingView = [[BATTippingView alloc] init]; {
      self.tippingView.layer.shadowRadius = 8.0;
      self.tippingView.layer.shadowOffset = CGSizeMake(0, -2);
      self.tippingView.layer.shadowOpacity = 0.35;
      self.tippingView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
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
  
  [self.view addSubview:self.backgroundView];
  [self.view addSubview:self.scrollView];
  [self.scrollView addSubview:self.overviewView];
  [self.view addSubview:self.tippingView];
  
  [NSLayoutConstraint activateConstraints:@[
    [self.backgroundView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
    [self.backgroundView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    [self.backgroundView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
    [self.backgroundView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                                            
    [self.tippingView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    [self.tippingView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
    [self.tippingView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
    
    [self.scrollView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
    [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
    [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
    [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    [self.scrollView.contentLayoutGuide.widthAnchor constraintEqualToAnchor:self.view.widthAnchor],
    
    [self.overviewView.topAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.topAnchor constant:20.0],
    [self.overviewView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:10.0],
    [self.overviewView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-10.0],
    [self.overviewView.bottomAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.bottomAnchor constant:-10.0]
  ]];
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  
  [self.tippingView layoutIfNeeded];
  self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, self.tippingView.bounds.size.height, 0);
}

@end
