/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATGradientView.h"

@interface BATGradientView ()
@property (readonly) CAGradientLayer *gradientLayer;
@end

@implementation BATGradientView

+ (Class)layerClass
{
  return [CAGradientLayer class];
}

- (CAGradientLayer *)gradientLayer
{
  return (CAGradientLayer *)self.layer;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.gradientLayer.colors = @[ (id)[UIColor colorWithRed:57/255.0 green:45/255.0 blue:209/255.0 alpha:1.0].CGColor,
                                   (id)[UIColor colorWithRed:1.0 green:26/255.0 blue:26/255.0 alpha:1.0].CGColor ];
    self.gradientLayer.startPoint = CGPointMake(0, 0.4);
    self.gradientLayer.endPoint = CGPointMake(1.0, 2.5);
  }
  return self;
}

@end
