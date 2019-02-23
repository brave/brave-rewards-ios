/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATWalletHeaderView.h"
@import BraveRewardsUI;
#import "UIImage+Convenience.h"
#import "NSBundle+Convenience.h"

@interface BATWalletHeaderView ()
@property (nonatomic) UIImageView *backgroundImageView;
@property (nonatomic) UILabel *titleLabel; // "Your Wallet"
@property (nonatomic) UIStackView *altcurrencyContainerView;
@property (nonatomic) UILabel *balanceLabel; // "30.0"
@property (nonatomic) UILabel *altcurrencyTypeLabel; // "BAT"
@property (nonatomic) UILabel *usdBalanceLabel; // "15.50 USD"
@property (nonatomic) ActionButton *grantsButton;
@property (nonatomic) UIButton *addFundsButton;
@property (nonatomic) UIButton *settingsButton;
@property (nonatomic) UIStackView *buttonsContainerView;
@end

@implementation BATWalletHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.backgroundColor = [UIColor clearColor];
    
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage bat_imageNamed:@"header"]]; {
      self.backgroundImageView.clipsToBounds = YES;
      self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    self.titleLabel = [[UILabel alloc] init]; {
      self.titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
      self.titleLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.65];
      self.titleLabel.text = BATLocalizedString(@"BraveRewardsWalletHeaderTitle", @"Your Wallet");
      self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.altcurrencyContainerView = [[UIStackView alloc] init]; {
      self.altcurrencyContainerView.translatesAutoresizingMaskIntoConstraints = NO;
      self.altcurrencyContainerView.spacing = 4.0;
      self.altcurrencyContainerView.alignment = UIStackViewAlignmentLastBaseline;
    }
    
    self.balanceLabel = [[UILabel alloc] init]; {
      self.balanceLabel.textColor = [UIColor whiteColor];
      self.balanceLabel.font = [UIFont systemFontOfSize:36.0];
      self.balanceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.altcurrencyTypeLabel = [[UILabel alloc] init]; {
      self.altcurrencyTypeLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.65];
      self.altcurrencyTypeLabel.font = [UIFont systemFontOfSize:18.0];
      self.altcurrencyTypeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.usdBalanceLabel = [[UILabel alloc] init]; {
      self.usdBalanceLabel.textAlignment = NSTextAlignmentCenter;
      self.usdBalanceLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.65];
      self.usdBalanceLabel.font = [UIFont systemFontOfSize:12.0];
      self.usdBalanceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.grantsButton = [ActionButton buttonWithType:UIButtonTypeSystem]; {
      self.grantsButton.translatesAutoresizingMaskIntoConstraints = NO;
      self.grantsButton.flipImageOrigin = YES;
      self.grantsButton.titleLabel.font = [UIFont systemFontOfSize:10.0 weight:UIFontWeightSemibold];
      [self.grantsButton setImage:[UIImage bat_imageNamed:@"down-arrow"] forState:UIControlStateNormal];
      [self.grantsButton setTitle:BATLocalizedString(@"BraveRewardsWalletHeaderGrants", @"Grants") forState:UIControlStateNormal];
      [self.grantsButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.75] forState:UIControlStateNormal];
      self.grantsButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5.0);
      self.grantsButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    }
    
    self.addFundsButton = [UIButton buttonWithType:UIButtonTypeSystem]; {
      self.addFundsButton.translatesAutoresizingMaskIntoConstraints = NO;
      [self.addFundsButton setTitle:BATLocalizedString(@"BraveRewardsAddFunds", @"Add Funds") forState:UIControlStateNormal];
      [self.addFundsButton setImage:[UIImage bat_imageNamed:@"wallet-icon"].bat_original forState:UIControlStateNormal];
      self.addFundsButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8.0);
      self.addFundsButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -8.0);
      self.addFundsButton.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
      self.addFundsButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
      [self.addFundsButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.75] forState:UIControlStateNormal];
      [self.addFundsButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    
    self.settingsButton = [UIButton buttonWithType:UIButtonTypeSystem]; {
      self.settingsButton.translatesAutoresizingMaskIntoConstraints = NO;
      [self.settingsButton setTitle:BATLocalizedString(@"BraveRewardsSettings", @"Settings") forState:UIControlStateNormal];
      [self.settingsButton setImage:[UIImage bat_imageNamed:@"bat"].bat_original forState:UIControlStateNormal];
      self.settingsButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
      self.settingsButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8.0);
      self.settingsButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -8.0);
      self.settingsButton.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
      [self.settingsButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.75] forState:UIControlStateNormal];
      [self.settingsButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    
    self.buttonsContainerView = [[UIStackView alloc] init]; {
      self.buttonsContainerView.translatesAutoresizingMaskIntoConstraints = NO;
      self.buttonsContainerView.spacing = 20.0;
      self.buttonsContainerView.alignment = UIStackViewAlignmentCenter;
      self.buttonsContainerView.distribution = UIStackViewDistributionFillEqually;
      [self.buttonsContainerView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.altcurrencyContainerView];
    [self.altcurrencyContainerView addArrangedSubview:self.balanceLabel];
    [self.altcurrencyContainerView addArrangedSubview:self.altcurrencyTypeLabel];
    [self addSubview:self.usdBalanceLabel];
    [self addSubview:self.grantsButton];
    [self addSubview:self.buttonsContainerView];
    [self.buttonsContainerView addArrangedSubview:self.addFundsButton];
    [self.buttonsContainerView addArrangedSubview:self.settingsButton];
    
    [NSLayoutConstraint activateConstraints:@[
      
      [self.titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:15.0],
      [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:15.0],
      [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-15.0],
      
      [self.altcurrencyContainerView.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:10.0],
      [self.altcurrencyContainerView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
      [self.altcurrencyContainerView.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.leadingAnchor constant:20.0],
      [self.altcurrencyContainerView.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor constant:-20.0],
      
      [self.usdBalanceLabel.topAnchor constraintEqualToAnchor:self.altcurrencyContainerView.bottomAnchor constant:4.0],
      [self.usdBalanceLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
      [self.usdBalanceLabel.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.leadingAnchor constant:20.0],
      [self.usdBalanceLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor constant:-20.0],
      
      [self.grantsButton.topAnchor constraintEqualToAnchor:self.usdBalanceLabel.bottomAnchor constant:12.0],
      [self.grantsButton.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
      [self.grantsButton.heightAnchor constraintEqualToConstant:26.0],
      [self.grantsButton.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.leadingAnchor constant:20.0],
      [self.grantsButton.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor constant:-20.0],
      
      [self.buttonsContainerView.topAnchor constraintEqualToAnchor:self.grantsButton.bottomAnchor constant:20.0],
      [self.buttonsContainerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:30.0],
      [self.buttonsContainerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-30.0],
      [self.buttonsContainerView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-30.0],
    ]];
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  self.backgroundImageView.frame = self.bounds;
}

@end
