/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <UIKit/UIKit.h>

#import "BATRewardsSummaryRow.h"
#import "BATRewardsSummaryButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface BATRewardsSummaryView : UIView
@property (readonly) BATRewardsSummaryButton *rewardsSummaryButton;
@property (readonly) UILabel *monthYearLabel;
@property (readonly) UIScrollView *scrollView;
@property (nonatomic) NSArray<BATRewardsSummaryRow *> *rows;
@end

NS_ASSUME_NONNULL_END
