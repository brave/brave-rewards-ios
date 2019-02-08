/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATPublisherView.h"
#import "UIColor+BATColors.h"

@interface BATPublisherView ()
@property (nonatomic) UIImageView *faviconImageView;
@property (nonatomic) UIStackView *stackView;
@property (nonatomic) UILabel *publisherNameLabel; // "reddit.com" / "Bart Baker on YouTube"
@property (nonatomic) UIStackView *verifiedStackView;
@property (nonatomic) UIImageView *verificationSymbolImageView; // ✓ or ?
@property (nonatomic) UILabel *verifiedLabel; // "Brave Verified Publisher" / "Not yet verified"
@end

@implementation BATPublisherView

- (instancetype)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.faviconImageView = [[UIImageView alloc] init]; {
      self.faviconImageView.translatesAutoresizingMaskIntoConstraints = NO;
      self.faviconImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    self.stackView = [[UIStackView alloc] init]; {
      self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
      self.stackView.axis = UILayoutConstraintAxisVertical;
      self.stackView.spacing = 4.0;
    }
    
    self.publisherNameLabel = [[UILabel alloc] init]; {
      self.publisherNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
      self.publisherNameLabel.textColor = [UIColor bat_textColor];
      self.publisherNameLabel.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
      self.publisherNameLabel.numberOfLines = 0;
    }
    
    self.verifiedStackView = [[UIStackView alloc] init]; {
      self.verifiedStackView.translatesAutoresizingMaskIntoConstraints = NO;
      self.verifiedStackView.spacing = 4.0;
    }
    
    self.verificationSymbolImageView = [[UIImageView alloc] init]; {
      self.verificationSymbolImageView.translatesAutoresizingMaskIntoConstraints = NO;
      [self.verificationSymbolImageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    
    self.verifiedLabel = [[UILabel alloc] init]; {
      self.verifiedLabel.textColor = [UIColor bat_lightTextColor];
      self.verifiedLabel.font = [UIFont systemFontOfSize:12.0];
      self.verifiedLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    [self addSubview:self.faviconImageView];
    [self addSubview:self.stackView];
    [self.stackView addArrangedSubview:self.publisherNameLabel];
    [self.stackView addArrangedSubview:self.verifiedStackView];
    [self.verifiedStackView addArrangedSubview:self.verificationSymbolImageView];
    [self.verifiedStackView addArrangedSubview:self.verifiedLabel];
    
    [NSLayoutConstraint activateConstraints:@[
      [self.faviconImageView.topAnchor constraintEqualToAnchor:self.topAnchor],
      [self.faviconImageView.leftAnchor constraintEqualToAnchor:self.leftAnchor],
      [self.faviconImageView.widthAnchor constraintEqualToConstant:48.0],
      [self.faviconImageView.heightAnchor constraintEqualToAnchor:self.faviconImageView.widthAnchor],
      
      [self.stackView.topAnchor constraintEqualToAnchor:self.topAnchor],
      [self.stackView.leftAnchor constraintEqualToAnchor:self.faviconImageView.rightAnchor constant:8.0],
      [self.stackView.rightAnchor constraintEqualToAnchor:self.rightAnchor],
      [self.stackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
  }
  return self;
}

@end
