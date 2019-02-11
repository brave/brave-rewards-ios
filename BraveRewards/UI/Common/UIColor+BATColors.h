/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (BATColors)

@property (readonly, class) UIColor *bat_textColor;
@property (readonly, class) UIColor *bat_darkTextColor;
@property (readonly, class) UIColor *bat_lightTextColor;
@property (readonly, class) UIColor *bat_rewardsSummaryButtonColor;
@property (readonly, class) UIColor *bat_rewardsSummaryTextColor;

@end

NS_ASSUME_NONNULL_END
