/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <Foundation/Foundation.h>

#import "BraveRewardsDataSource.h"
#import "BraveRewardsDataDelegate.h"

static const CGFloat BATPreferredPanelWidth = 355.0;
static const CGFloat BATPreferredPanelHeight = 574.0;

@class BATBraveLedger;

NS_ASSUME_NONNULL_BEGIN

// Info that gets passed between each panel
@interface BATPanelState : NSObject

@property (nonatomic) BATBraveLedger *ledger;
@property (nonatomic, copy) NSURL *url;
@property (nonatomic, copy, nullable) NSURL *faviconURL;
@property (nonatomic, weak) id<BraveRewardsDelegate> delegate;
@property (nonatomic, weak) id<BraveRewardsDataSource> dataSource;

@end

NS_ASSUME_NONNULL_END
