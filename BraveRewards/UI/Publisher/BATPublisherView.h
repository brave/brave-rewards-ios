/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <UIKit/UIKit.h>

@class DisclaimerView;

NS_ASSUME_NONNULL_BEGIN

@interface BATPublisherView : UIStackView
@property (readonly) UIImageView *faviconImageView;
@property (readonly) UILabel *publisherNameLabel;
@property (readonly) UIStackView *verifiedLabelStackView;
@property (readonly) UIImageView *verificationSymbolImageView;
@property (readonly) UILabel *verifiedLabel;
@property (readonly) DisclaimerView *unverifiedDisclaimerView;
@end

NS_ASSUME_NONNULL_END
