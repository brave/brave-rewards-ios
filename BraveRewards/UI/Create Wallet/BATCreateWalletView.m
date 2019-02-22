/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATCreateWalletView.h"
#import "BATActionButton.h"
#import "BATGradientView.h"
#import "NSBundle+Convenience.h"
#import "UIImage+Convenience.h"
#import "UIColor+BATColors.h"

@interface BATCreateWalletView ()
@property (nonatomic) BATGradientView *backgroundView;
@property (nonatomic) UIImageView *watermarkImageView;
@property (nonatomic) UILabel *prefixLabel; // "Get ready for the next experience"
@property (nonatomic) UIImageView *batLogoImageView;
@property (nonatomic) UILabel *titleLabel; // "Brave Rewards™"
@property (nonatomic) UILabel *descriptionLabel; // "Get paid for viewing ads and pay it forward to support..."
@property (nonatomic) BATActionButton *createWalletButton;
@property (nonatomic) UIButton *learnMoreButton;
@end

@implementation BATCreateWalletView

- (instancetype)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.backgroundView = [BATGradientView purpleRewardsGradientView]; {
      self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.watermarkImageView = [[UIImageView alloc] initWithImage:[UIImage bat_imageNamed:@"bat-watermark"]]; {
      self.watermarkImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.prefixLabel = [[UILabel alloc] init]; {
      self.prefixLabel.translatesAutoresizingMaskIntoConstraints = NO;
      self.prefixLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.75];
      self.prefixLabel.font = [UIFont systemFontOfSize:16.0];
      self.prefixLabel.textAlignment = NSTextAlignmentCenter;
      self.prefixLabel.text = BATLocalizedString(@"RewardsOptInPrefix", @"Get ready to experience the next Internet.");
      self.prefixLabel.numberOfLines = 0;
    }
    
    self.batLogoImageView = [[UIImageView alloc] initWithImage:[UIImage bat_imageNamed:@"bat-logo"]]; {
      self.batLogoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.titleLabel = [[UILabel alloc] init]; {
      self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
      self.titleLabel.textColor = [UIColor whiteColor];
      self.titleLabel.font = [UIFont systemFontOfSize:28.0 weight:UIFontWeightMedium];
      self.titleLabel.textAlignment = NSTextAlignmentCenter;
      NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:BATLocalizedString(@"RewardsOptInTitle", @"Brave Rewards™")];
      NSRange trademarkRange = [title.string rangeOfString:@"™"]; // Logic may need alteration based on localization
      [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:trademarkRange];
      [title addAttribute:NSBaselineOffsetAttributeName value:@(10.0) range:trademarkRange];
      self.titleLabel.attributedText = title;
    }
    
    self.descriptionLabel = [[UILabel alloc] init]; {
      self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
      self.descriptionLabel.textColor = [UIColor whiteColor];
      self.descriptionLabel.font = [UIFont systemFontOfSize:16.0];
      self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
      self.descriptionLabel.text = BATLocalizedString(@"RewardsOptInDescription", @"Get paid for viewing ads and pay it forward to support your favorite content creators.");
      self.descriptionLabel.numberOfLines = 0;
    }
    
    self.createWalletButton = [BATActionButton buttonWithType:UIButtonTypeSystem]; {
      self.createWalletButton.translatesAutoresizingMaskIntoConstraints = NO;
      [self.createWalletButton setTitle:BATLocalizedString(@"RewardsOptInJoinTitle", @"Join Rewards").uppercaseString forState:UIControlStateNormal];
      [self.createWalletButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      self.createWalletButton.titleLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightBold];
    }
    
    self.learnMoreButton = [UIButton buttonWithType:UIButtonTypeSystem]; {
      self.learnMoreButton.translatesAutoresizingMaskIntoConstraints = NO;
      [self.learnMoreButton setTitle:BATLocalizedString(@"RewardsOptInLearnMore", @"Learn More").uppercaseString forState:UIControlStateNormal];
      [self.learnMoreButton setTitleColor:[UIColor bat_blue500] forState:UIControlStateNormal];
      self.learnMoreButton.titleLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
    }
    
    [self addSubview:self.backgroundView];
    [self addSubview:self.watermarkImageView];
    [self addSubview:self.prefixLabel];
    [self addSubview:self.batLogoImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.descriptionLabel];
    [self addSubview:self.createWalletButton];
    [self addSubview:self.learnMoreButton];
    
    [NSLayoutConstraint activateConstraints:@[
      [self.backgroundView.topAnchor constraintEqualToAnchor:self.topAnchor],
      [self.backgroundView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [self.backgroundView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
      [self.backgroundView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
      
      [self.watermarkImageView.topAnchor constraintEqualToAnchor:self.topAnchor],
      [self.watermarkImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:10.0],
                                              
      [self.prefixLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:30.0],
      [self.prefixLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:30.0],
      [self.prefixLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-30.0],
      
      [self.batLogoImageView.topAnchor constraintEqualToAnchor:self.prefixLabel.bottomAnchor constant:10.0],
      [self.batLogoImageView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
      
      [self.titleLabel.topAnchor constraintEqualToAnchor:self.batLogoImageView.bottomAnchor constant:10.0],
      [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:30.0],
      [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-30.0],
      
      [self.descriptionLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:15.0],
      [self.descriptionLabel.leadingAnchor constraintEqualToAnchor:self.titleLabel.leadingAnchor],
      [self.descriptionLabel.trailingAnchor constraintEqualToAnchor:self.titleLabel.trailingAnchor],
      
      [self.createWalletButton.topAnchor constraintEqualToAnchor:self.descriptionLabel.bottomAnchor constant:25.0],
      [self.createWalletButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:50.0],
      [self.createWalletButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-50.0],
      [self.createWalletButton.heightAnchor constraintEqualToConstant:40.0],
      
      [self.learnMoreButton.topAnchor constraintEqualToAnchor:self.createWalletButton.bottomAnchor constant:30.0],
      [self.learnMoreButton.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
      [self.learnMoreButton.heightAnchor constraintEqualToConstant:30.0],
      [self.learnMoreButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-20.0]
    ]];
  }
  return self;
}

@end
