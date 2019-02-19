/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <UIKit/UIKit.h>

#ifndef BATDefineColor
#define BATDefineColor(__name) @property (readonly, class) UIColor *bat_##__name;
#endif

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (BATColors)

BATDefineColor(grey000);
BATDefineColor(grey100);
BATDefineColor(grey200);
BATDefineColor(neutral600);
BATDefineColor(neutral800);
BATDefineColor(blue500);
BATDefineColor(blurple400);
BATDefineColor(blurple600);
BATDefineColor(blurple800);
BATDefineColor(purple400);

@end

NS_ASSUME_NONNULL_END

#undef BATDefineColor
