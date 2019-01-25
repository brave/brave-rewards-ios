/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATWalletHeaderView.h"
#import "BATActionButton.h"
#import "UIImage+Convenience.h"
#import "NSBundle+Convenience.h"

@interface BATWalletHeaderView ()
@property (nonatomic) UIImageView *backgroundImageView;
@property (nonatomic) UILabel *titleLabel; // "Your Wallet"
@property (nonatomic) UILabel *batBalanceLabel; // "30.0 BAT"
@property (nonatomic) UILabel *usdBalanceLabel; // "15.50 USD"
@property (nonatomic) BATActionButton *grantsButton;
@property (nonatomic) UIButton *addFundsButton;
@property (nonatomic) UIButton *settingsButton;
@property (nonatomic) UIStackView *buttonsContainerView;
@end

@implementation BATWalletHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage bat_imageNamed:@"header"]]; {
      self.backgroundImageView.clipsToBounds = YES;
      self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
      self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
      [self.backgroundImageView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
      [self.backgroundImageView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }
    
    self.titleLabel = [[UILabel alloc] init]; {
      self.titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
      self.titleLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.65];
      self.titleLabel.text = BATLocalizedString(@"BraveRewardsWalletHeaderTitle", @"Your Wallet", @"Wallet Header Title");
      self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.batBalanceLabel = [[UILabel alloc] init]; {
      self.batBalanceLabel.text = @"20.0 BAT";
      self.batBalanceLabel.textAlignment = NSTextAlignmentCenter;
      self.batBalanceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.usdBalanceLabel = [[UILabel alloc] init]; {
      self.usdBalanceLabel.text = @"20.0 USD";
      self.usdBalanceLabel.textAlignment = NSTextAlignmentCenter;
      self.usdBalanceLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.65];
      self.usdBalanceLabel.font = [UIFont systemFontOfSize:12.0];
      self.usdBalanceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.grantsButton = [BATActionButton buttonWithType:UIButtonTypeSystem]; {
      self.grantsButton.translatesAutoresizingMaskIntoConstraints = NO;
      self.grantsButton.semanticContentAttribute = UIApplication.sharedApplication.userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft ? UISemanticContentAttributeForceLeftToRight : UISemanticContentAttributeForceRightToLeft;
      self.grantsButton.titleLabel.font = [UIFont systemFontOfSize:10.0 weight:UIFontWeightSemibold];
      [self.grantsButton setImage:[UIImage bat_imageNamed:@"down-arrow"] forState:UIControlStateNormal];
      [self.grantsButton setTitle:BATLocalizedString(@"BraveRewardsWalletHeaderGrants", @"Grants", @"Grants down arrow") forState:UIControlStateNormal];
      self.grantsButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5.0);
      self.grantsButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5.0);
      self.grantsButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    }
    
    self.addFundsButton = [UIButton buttonWithType:UIButtonTypeSystem]; {
      self.addFundsButton.translatesAutoresizingMaskIntoConstraints = NO;
      [self.addFundsButton setTitle:BATLocalizedString(@"BraveRewardsAddFunds", @"Add Funds", @"Add Funds") forState:UIControlStateNormal];
      [self.addFundsButton setImage:[UIImage bat_imageNamed:@"wallet-icon"].bat_original forState:UIControlStateNormal];
      self.addFundsButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5.0);
      self.addFundsButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5.0);
      self.addFundsButton.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
      self.addFundsButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
      [self.addFundsButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.75] forState:UIControlStateNormal];
      [self.addFundsButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    
    self.settingsButton = [UIButton buttonWithType:UIButtonTypeSystem]; {
      self.settingsButton.translatesAutoresizingMaskIntoConstraints = NO;
      [self.settingsButton setTitle:BATLocalizedString(@"BraveRewardsSettings", @"Settings", @"Settings") forState:UIControlStateNormal];
      [self.settingsButton setImage:[UIImage bat_imageNamed:@"bat"].bat_original forState:UIControlStateNormal];
      self.settingsButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
      self.settingsButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5.0);
      self.settingsButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5.0);
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
    [self addSubview:self.batBalanceLabel];
    [self addSubview:self.usdBalanceLabel];
    [self addSubview:self.grantsButton];
    [self addSubview:self.buttonsContainerView];
    [self.buttonsContainerView addArrangedSubview:self.addFundsButton];
    [self.buttonsContainerView addArrangedSubview:self.settingsButton];
    
    [NSLayoutConstraint activateConstraints:@[
      [self.backgroundImageView.topAnchor constraintEqualToAnchor:self.topAnchor],
      [self.backgroundImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [self.backgroundImageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
      [self.backgroundImageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
      
      [self.titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:10.0],
      [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:10.0],
      [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-10.0],
      
      [self.batBalanceLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:20.0],
      [self.batBalanceLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20.0],
      [self.batBalanceLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-20.0],
      
      [self.usdBalanceLabel.topAnchor constraintEqualToAnchor:self.batBalanceLabel.bottomAnchor constant:8.0],
      [self.usdBalanceLabel.leadingAnchor constraintEqualToAnchor:self.batBalanceLabel.leadingAnchor],
      [self.usdBalanceLabel.trailingAnchor constraintEqualToAnchor:self.batBalanceLabel.trailingAnchor],
      
      [self.grantsButton.topAnchor constraintEqualToAnchor:self.usdBalanceLabel.bottomAnchor constant:8.0],
      [self.grantsButton.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
      [self.grantsButton.heightAnchor constraintEqualToConstant:26.0],
      [self.grantsButton.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.leadingAnchor constant:20.0],
      [self.grantsButton.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor constant:-20.0],
      
      [self.buttonsContainerView.topAnchor constraintEqualToAnchor:self.grantsButton.bottomAnchor constant:20.0],
      [self.buttonsContainerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20.0],
      [self.buttonsContainerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-20.0],
      [self.buttonsContainerView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-20.0],
    ]];
  }
  return self;
}

@end
