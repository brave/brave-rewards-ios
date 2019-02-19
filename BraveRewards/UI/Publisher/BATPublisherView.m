/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATPublisherView.h"
#import "UIColor+BATColors.h"
#import "NSBundle+Convenience.h"
#import "BATDisclaimerView.h"

@interface BATPublisherView ()
@property (nonatomic) UIStackView *stackView; // For containing the favicon and publisherStackView (Always visible)
@property (nonatomic) UIImageView *faviconImageView;
@property (nonatomic) UIStackView *publisherStackView; // For containing the publisherNameLabel and verifiedLabelStackView (Always visible)
@property (nonatomic) UILabel *publisherNameLabel; // "reddit.com" / "Bart Baker on YouTube"
@property (nonatomic) UIStackView *verifiedLabelStackView; // For containing verificationSymbolImageView and verifiedLabel
@property (nonatomic) UIImageView *verificationSymbolImageView; // ✓ or ?
@property (nonatomic) UILabel *verifiedLabel; // "Brave Verified Publisher" / "Not yet verified"
@property (nonatomic) BATDisclaimerView *unverifiedDisclaimerView; // Only shown when unverified
@end

@implementation BATPublisherView

- (instancetype)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.axis = UILayoutConstraintAxisVertical;
    self.spacing = 10.0;
    
    self.stackView = [[UIStackView alloc] init]; {
      self.stackView.spacing = 10.0;
      self.stackView.alignment = UIStackViewAlignmentCenter;
      self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.faviconImageView = [[UIImageView alloc] init]; {
      self.faviconImageView.translatesAutoresizingMaskIntoConstraints = NO;
      self.faviconImageView.backgroundColor = [UIColor bat_neutral800];
      self.faviconImageView.contentMode = UIViewContentModeScaleAspectFill;
      [self.faviconImageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
      self.faviconImageView.accessibilityIdentifier = @"publisher.favicon";
    }
    
    self.publisherStackView = [[UIStackView alloc] init]; {
      self.publisherStackView.translatesAutoresizingMaskIntoConstraints = NO;
      self.publisherStackView.axis = UILayoutConstraintAxisVertical;
      self.publisherStackView.spacing = 4.0;
    }
    
    self.publisherNameLabel = [[UILabel alloc] init]; {
      self.publisherNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
      self.publisherNameLabel.textColor = [UIColor bat_grey000];
      self.publisherNameLabel.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
      self.publisherNameLabel.numberOfLines = 0;
      self.publisherNameLabel.accessibilityIdentifier = @"publisher.name";
    }
    
    self.verifiedLabelStackView = [[UIStackView alloc] init]; {
      self.verifiedLabelStackView.translatesAutoresizingMaskIntoConstraints = NO;
      self.verifiedLabelStackView.spacing = 4.0;
    }
    
    self.verificationSymbolImageView = [[UIImageView alloc] init]; {
      self.verificationSymbolImageView.translatesAutoresizingMaskIntoConstraints = NO;
      self.verificationSymbolImageView.accessibilityIdentifier = @"publisher.verified-image";
      [self.verificationSymbolImageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    
    self.verifiedLabel = [[UILabel alloc] init]; {
      self.verifiedLabel.textColor = [UIColor bat_grey200];
      self.verifiedLabel.font = [UIFont systemFontOfSize:12.0];
      self.verifiedLabel.adjustsFontSizeToFitWidth = YES;
      self.verifiedLabel.accessibilityIdentifier = @"publisher.verified-label";
    }
    
    self.unverifiedDisclaimerView = [[BATDisclaimerView alloc] initWithText:BATLocalizedString(@"BraveRewardsUnverifiedPublisherDisclaimer", @"This creator has not yet signed up to receive contributions from Brave users. Any tips you send will remain in your wallet until they verify.")]; {
      self.unverifiedDisclaimerView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    [self addArrangedSubview:self.stackView];
    [self addArrangedSubview:self.unverifiedDisclaimerView];
    [self.stackView addArrangedSubview:self.faviconImageView];
    [self.stackView addArrangedSubview:self.publisherStackView];
    [self.publisherStackView addArrangedSubview:self.publisherNameLabel];
    [self.publisherStackView addArrangedSubview:self.verifiedLabelStackView];
    [self.verifiedLabelStackView addArrangedSubview:self.verificationSymbolImageView];
    [self.verifiedLabelStackView addArrangedSubview:self.verifiedLabel];
    
    [NSLayoutConstraint activateConstraints:@[
      [self.faviconImageView.widthAnchor constraintEqualToConstant:48.0],
      [self.faviconImageView.heightAnchor constraintEqualToAnchor:self.faviconImageView.widthAnchor],
    ]];
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  // This techically will always be 24
  self.faviconImageView.layer.cornerRadius = 24.0;
}

@end
