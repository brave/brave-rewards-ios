/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "UIColor+BATColors.h"
#import "UIColor+RGB.h"

@implementation UIColor (BATColors)

+ (UIColor *)bat_textColor
{
  return UIColorFromRGB(74, 75, 96);
}

+ (UIColor *)bat_lightTextColor
{
  return UIColorFromRGB(131, 131, 146);
}

@end
