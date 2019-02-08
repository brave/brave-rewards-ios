/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BATPublisherView : UIView
@property (readonly) UIImageView *faviconImageView;
@property (readonly) UILabel *publisherNameLabel;
@property (readonly) UIStackView *verifiedStackView;
@property (readonly) UIImageView *verificationSymbolImageView;
@property (readonly) UILabel *verifiedLabel;
@end

NS_ASSUME_NONNULL_END
