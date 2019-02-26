/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Protocol defining a few things the Client has to give to BraveRewards
 */
@protocol BraveRewardsDataSource <NSObject>
@required

/**
 The current pages URL
 */
- (NSURL *)currentPageURL;

/**
 The string to display given a URL (Usually eTLD+1). If `nil` is returned, `URL.host` will be used to display
 */
- (nullable NSString *)displayStringForURL:(NSURL *)URL;

/**
 Download or retrieve a cached version of the favicon given a URL. This should also return the default letter/color
 favicon if a website has no official favicon.
 
 Execute completionBlock with an image if possible when its available
 */
- (void)retrieveFaviconWithURL:(NSURL *)URL completion:(void (^)(UIImage * _Nullable image))completionBlock;

@end

NS_ASSUME_NONNULL_END
