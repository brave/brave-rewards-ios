/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// A Brave styled action button
///
/// Border, corner radius, bold text. Color controlled by `tintColor` (defaulting to white)
@interface BATActionButton : UIButton
/// Whether or not to flip the image origin from left to right in LTR languages and vice-versa
@property (nonatomic, assign) BOOL flipImageOrigin;
@end

NS_ASSUME_NONNULL_END
