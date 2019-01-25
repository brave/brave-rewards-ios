/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#pragma once

#import <UIKit/UIKit.h>

NS_INLINE UIColor *UIColorFromRGBA(UInt8 red, UInt8 green, UInt8 blue, CGFloat alpha) {
  return [UIColor colorWithRed:(red / 255.0) green:(green / 255.0) blue:(blue / 255.0) alpha:alpha];
}

NS_INLINE UIColor *UIColorFromRGB(UInt8 red, UInt8 green, UInt8 blue) {
  return UIColorFromRGBA(red, green, blue, 1.0);
}
