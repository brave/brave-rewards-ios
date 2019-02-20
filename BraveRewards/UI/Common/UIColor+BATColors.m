/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "UIColor+BATColors.h"

@implementation UIColor (BATColors)

NS_INLINE UIColor *UIColorFromHex(UInt32 hex) {
  CGFloat r = ((hex & 0xFF0000) >> 16) / 255.0;
  CGFloat g = ((hex & 0x00FF00) >> 8) / 255.0;
  CGFloat b = (hex & 0x0000FF) / 255.0;
  return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
};

#define BATColorWithHex(__name, __hex) \
+ (UIColor *)bat_##__name { return UIColorFromHex(__hex); }

BATColorWithHex(grey000, 0x1E2029);
BATColorWithHex(grey100, 0x3B3E4F);
BATColorWithHex(grey200, 0x5E6175);
BATColorWithHex(neutral600, 0xDEE2E6);
BATColorWithHex(neutral800, 0xF1F3F5);
BATColorWithHex(blue500, 0x5DB5FC);
BATColorWithHex(blurple400, 0x4C54D2);
BATColorWithHex(blurple500, 0x737ADE);
BATColorWithHex(blurple600, 0xA0A5EB);
BATColorWithHex(blurple700, 0xD0D2F7);
BATColorWithHex(blurple800, 0xF0F1FF);
BATColorWithHex(purple400, 0x845EF7);

@end
