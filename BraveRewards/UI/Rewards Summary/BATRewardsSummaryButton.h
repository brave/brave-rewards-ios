/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BATRewardsSummaryButton : UIControl
@property (readonly) UILabel *titleLabel;
/// Should be set to "slide-up"/"slide-down" image based on slide status; Defaults to "slide-up"
@property (readonly) UIImageView *slideToggleImageView;
@end

NS_ASSUME_NONNULL_END
