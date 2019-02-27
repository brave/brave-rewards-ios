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
 The string to display given a URL (Usually eTLD+1). If `nil` is returned, `URL.host` will be used to display
 */
- (nullable NSString *)displayStringForURL:(NSURL *)url;

/**
 Download or retrieve a cached version of the favicon given a URL. This should also return the default letter/color
 favicon if a website has no official favicon.
 
 Execute completionBlock with an image (or nil) when its available
 */
- (void)retrieveFaviconWithURL:(NSURL *)url completion:(void (^)(UIImage * _Nullable image))completionBlock;

@end

NS_ASSUME_NONNULL_END
