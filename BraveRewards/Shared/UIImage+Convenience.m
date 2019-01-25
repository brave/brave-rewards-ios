/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "UIImage+Convenience.h"
#import "NSBundle+Convenience.h"

@implementation UIImage (Bundle)

+ (instancetype)bat_imageNamed:(NSString *)name
{
  return [self bat_imageNamed:name compatibleWithTraitCollection:nil];
}

+ (instancetype)bat_imageNamed:(NSString *)name compatibleWithTraitCollection:(nullable UITraitCollection *)collection
{
  return [UIImage imageNamed:name inBundle:[NSBundle bat_current] compatibleWithTraitCollection:collection];
}

- (UIImage *)bat_template
{
  return [self imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (UIImage *)bat_original
{
  return [self imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
