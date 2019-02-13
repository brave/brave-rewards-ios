/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <UIKit/UIKit.h>
#import "BATWalletContentView.h"

#import "BATPublisherView.h"
#import "BATAttentionView.h"

@class BATActionButton;

NS_ASSUME_NONNULL_BEGIN

@interface BATPublisherSummaryView : UIView <BATWalletContentView>
@property (readonly) UIScrollView *scrollView;
@property (readonly) UIStackView *stackView;
@property (readonly) BATPublisherView *publisherView;
@property (readonly) BATAttentionView *attentionView;
@property (readonly) BATActionButton *tipButton;
@end

NS_ASSUME_NONNULL_END
