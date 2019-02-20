/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATTippingView.h"
#import "NSBundle+Convenience.h"
#import "UIColor+BATColors.h"
#import "UIImage+Convenience.h"
#import "BATTippingAmountView.h"

@interface BATTippingView ()
@property (nonatomic) UILabel *titleLabel; // "Tip amount"
@property (nonatomic) UIStackView *walletBalanceStackView;
@property (nonatomic) UILabel *walletBalanceTitleLabel; // "wallet balance"
@property (nonatomic) UILabel *walletBalanceValueLabel; // "25"
@property (nonatomic) UILabel *walletBalanceCryptoLabel; // "BAT"
@property (nonatomic) UIStackView *amountStackView;
@property (nonatomic) BATButton *monthlyToggleButton;
@property (nonatomic) BATSendTipButton *sendTipButton;
@end

@implementation BATTippingView

- (instancetype)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.backgroundColor = [UIColor bat_blurple500];
    
    self.titleLabel = [[UILabel alloc] init]; {
      self.titleLabel.textColor = [UIColor whiteColor];
      self.titleLabel.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightBold];
      self.titleLabel.text = BATLocalizedString(@"BraveRewardsTippingAmountTitle", @"Tip amount");
      self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.walletBalanceStackView = [[UIStackView alloc] init]; {
      self.walletBalanceStackView.alignment = UIStackViewAlignmentFirstBaseline;
      self.walletBalanceStackView.spacing = 2.0;
      self.walletBalanceStackView.translatesAutoresizingMaskIntoConstraints = NO;
      [self.walletBalanceStackView setContentCompressionResistancePriority:850 forAxis:UILayoutConstraintAxisHorizontal];
      [self.walletBalanceStackView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    
    self.walletBalanceTitleLabel = [[UILabel alloc] init]; {
      self.walletBalanceTitleLabel.textColor = [UIColor bat_blurple700];
      self.walletBalanceTitleLabel.font = [UIFont systemFontOfSize:12.0];
      self.walletBalanceTitleLabel.text = BATLocalizedString(@"BraveRewardsTippingWalletBalanceTitle", @"wallet balance");
      self.walletBalanceTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.walletBalanceValueLabel = [[UILabel alloc] init]; {
      self.walletBalanceValueLabel.textColor = [UIColor whiteColor];
      self.walletBalanceValueLabel.font = [UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium];
      self.walletBalanceValueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.walletBalanceCryptoLabel = [[UILabel alloc] init]; {
      self.walletBalanceCryptoLabel.textColor = [UIColor whiteColor];
      self.walletBalanceCryptoLabel.font = [UIFont systemFontOfSize:10.0 weight:UIFontWeightMedium];
      self.walletBalanceCryptoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.amountStackView = [[UIStackView alloc] init]; {
      self.amountStackView.distribution = UIStackViewDistributionFillEqually;
      self.amountStackView.spacing = 10.0;
      self.amountStackView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.monthlyToggleButton = [BATButton buttonWithType:UIButtonTypeSystem]; {
      [self.monthlyToggleButton setTitle:BATLocalizedString(@"BraveRewardsTippingMakeMonthly", @"Make this monthly") forState:UIControlStateNormal];
      [self.monthlyToggleButton setImage:[UIImage bat_imageNamed:@"checkbox"].bat_original forState:UIControlStateNormal];
      self.monthlyToggleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
      self.monthlyToggleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
      self.monthlyToggleButton.tintColor = [UIColor whiteColor];
      self.monthlyToggleButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.sendTipButton = [[BATSendTipButton alloc] init]; {
      self.sendTipButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.walletBalanceStackView];
    [self.walletBalanceStackView addArrangedSubview:self.walletBalanceTitleLabel];
    [self.walletBalanceStackView addArrangedSubview:self.walletBalanceValueLabel];
    [self.walletBalanceStackView addArrangedSubview:self.walletBalanceCryptoLabel];
    [self addSubview:self.amountStackView];
    [self addSubview:self.monthlyToggleButton];
    [self addSubview:self.sendTipButton];
    
    [self.walletBalanceStackView setCustomSpacing:6.0 afterView:self.walletBalanceTitleLabel];
    
    [NSLayoutConstraint activateConstraints:@[
      [self.titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:20.0],
      [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:25.0],
      [self.titleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.walletBalanceStackView.leadingAnchor constant:-15.0],
      
      [self.walletBalanceStackView.firstBaselineAnchor constraintEqualToAnchor:self.titleLabel.firstBaselineAnchor],
      [self.walletBalanceStackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-25.0],
      
      [self.amountStackView.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:20.0],
      [self.amountStackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:15.0],
      [self.amountStackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-15.0],
      
      [self.monthlyToggleButton.topAnchor constraintEqualToAnchor:self.amountStackView.bottomAnchor constant:20.0],
      [self.monthlyToggleButton.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.leadingAnchor constant:25.0],
      [self.monthlyToggleButton.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor constant:-25.0],
      [self.monthlyToggleButton.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
      
      [self.sendTipButton.topAnchor constraintEqualToAnchor:self.monthlyToggleButton.bottomAnchor constant:15.0],
      [self.sendTipButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [self.sendTipButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
      [self.sendTipButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
  }
  return self;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
  [super traitCollectionDidChange:previousTraitCollection];
  
  BOOL wideLayout = self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular;
  self.amountStackView.axis = wideLayout ? UILayoutConstraintAxisVertical : UILayoutConstraintAxisHorizontal;
  self.amountStackView.distribution = wideLayout ? UIStackViewDistributionFill : UIStackViewDistributionFillEqually;
}

@end
