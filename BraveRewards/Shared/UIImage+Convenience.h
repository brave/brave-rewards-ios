/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Convenience)

/// Get an image from the BraveRewardsUI bundle
+ (instancetype)bat_imageNamed:(NSString *)name;
+ (instancetype)bat_imageNamed:(NSString *)name compatibleWithTraitCollection:(nullable UITraitCollection *)collection;

@property (readonly) UIImage *bat_template;
@property (readonly) UIImage *bat_original;

@end

NS_ASSUME_NONNULL_END
