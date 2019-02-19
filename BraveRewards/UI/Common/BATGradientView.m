/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATGradientView.h"
#import "UIColor+BATColors.h"

@implementation BATGradientView

NS_INLINE UIColor *UIColorFromRGB(UInt8 red, UInt8 green, UInt8 blue) {
  return [UIColor colorWithRed:(red / 255.0) green:(green / 255.0) blue:(blue / 255.0) alpha:1.0];
}

+ (Class)layerClass
{
  return [CAGradientLayer class];
}

- (CAGradientLayer *)gradientLayer
{
  return (CAGradientLayer *)self.layer;
}

+ (instancetype)purpleRewardsGradientView
{
  BATGradientView *view = [[self alloc] init];
  view.gradientLayer.colors = @[ (id)UIColorFromRGB(57, 45, 209).CGColor,
                                 (id)UIColorFromRGB(255, 26, 26).CGColor ];
  view.gradientLayer.startPoint = CGPointMake(0, 0.4);
  view.gradientLayer.endPoint = CGPointMake(1.0, 2.5);
  return view;
}

+ (instancetype)softBlueToClearGradientView
{
  BATGradientView *view = [[self alloc] init];
  view.gradientLayer.colors = @[ (id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor,
                                 (id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor,
                                 (id)UIColorFromRGB(233, 235, 255).CGColor ];
  view.gradientLayer.locations = @[ @0.0, @0.8, @1.0 ];
  return view;
}

@end
