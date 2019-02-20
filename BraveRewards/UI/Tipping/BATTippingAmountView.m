/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATTippingAmountView.h"
#import "UIColor+BATColors.h"

static const CGFloat kAmountHeight = 40.0;
NS_INLINE UIColor *kSelectedAndBorderColor() { return [UIColor colorWithWhite:1.0 alpha:0.30]; }

@interface BATTippingAmountView ()
@property (nonatomic) UIStackView *containerStackView; // Thing that holds the BAT amount + USD label
@property (nonatomic) UIView *amountView;
@property (nonatomic) UIStackView *amountStackView;
@property (nonatomic) UIImageView *cryptoLogoImageView; // BAT logo
@property (nonatomic) UILabel *valueLabel; // "1"/"5"/"10"
@property (nonatomic) UILabel *cryptoLabel; // "BAT"
@property (nonatomic) UILabel *dollarLabel; // "0.30 USD"
@end

@implementation BATTippingAmountView

- (instancetype)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.containerStackView = [[UIStackView alloc] init]; {
      self.containerStackView.spacing = 6.0;
      self.containerStackView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.amountView = [[UIView alloc] init]; {
      self.amountView.layer.cornerRadius = kAmountHeight / 2.0;
      self.amountView.layer.borderColor = kSelectedAndBorderColor().CGColor;
      self.amountView.layer.borderWidth = 1.0;
      self.amountView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.amountStackView = [[UIStackView alloc] init]; {
      self.amountStackView.alignment = UIStackViewAlignmentCenter;
      self.amountStackView.spacing = 3.0;
      self.amountStackView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.cryptoLogoImageView = [[UIImageView alloc] init]; {
      self.cryptoLogoImageView.contentMode = UIViewContentModeScaleAspectFit;
      [self.cryptoLogoImageView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
      self.cryptoLogoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.valueLabel = [[UILabel alloc] init]; {
      self.valueLabel.textColor = [UIColor whiteColor];
      self.valueLabel.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightSemibold];
      self.valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.cryptoLabel = [[UILabel alloc] init]; {
      self.cryptoLabel.textColor = [UIColor whiteColor];
      self.cryptoLabel.font = [UIFont systemFontOfSize:12.0];
      self.cryptoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    self.dollarLabel = [[UILabel alloc] init]; {
      self.dollarLabel.textColor = [UIColor bat_blurple700];
      self.dollarLabel.font = [UIFont systemFontOfSize:12.0];
      self.dollarLabel.textAlignment = NSTextAlignmentCenter;
      self.dollarLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    [self addSubview:self.containerStackView];
    [self.containerStackView addArrangedSubview:self.amountView];
    [self.containerStackView addArrangedSubview:self.dollarLabel];
    
    [self.amountView addSubview:self.amountStackView];
    [self.amountStackView addArrangedSubview:self.cryptoLogoImageView];
    [self.amountStackView addArrangedSubview:self.valueLabel];
    [self.amountStackView addArrangedSubview:self.cryptoLabel];
    
    [self.amountStackView setCustomSpacing:6.0 afterView:self.cryptoLogoImageView];
    
    [NSLayoutConstraint activateConstraints:@[
      [self.containerStackView.topAnchor constraintEqualToAnchor:self.topAnchor],
      [self.containerStackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
      [self.containerStackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
      [self.containerStackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
      
      [self.amountView.heightAnchor constraintEqualToConstant:kAmountHeight],
      
      [self.amountStackView.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.amountView.leadingAnchor constant:10.0],
      [self.amountStackView.trailingAnchor constraintLessThanOrEqualToAnchor:self.amountView.trailingAnchor constant:-10.0],
      [self.amountStackView.centerYAnchor constraintEqualToAnchor:self.amountView.centerYAnchor],
      [self.amountStackView.centerXAnchor constraintEqualToAnchor:self.amountView.centerXAnchor]
    ]];
  }
  return self;
}

- (void)setSelected:(BOOL)selected
{
  [super setSelected:selected];
  
  self.amountView.layer.borderWidth = selected ? 0 : 1;
  self.amountView.backgroundColor = selected ? kSelectedAndBorderColor() : [UIColor clearColor];
  self.dollarLabel.textColor = selected ? [UIColor whiteColor] : [UIColor bat_blurple700];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
  [super traitCollectionDidChange:previousTraitCollection];
  
  BOOL wideLayout = self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular;
  self.containerStackView.axis = wideLayout ? UILayoutConstraintAxisHorizontal : UILayoutConstraintAxisVertical;
  self.containerStackView.alignment = wideLayout ? UIStackViewAlignmentCenter : UIStackViewAlignmentFill;
}

@end
