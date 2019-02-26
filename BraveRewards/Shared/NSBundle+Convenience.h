/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (Convenience)

/// Get the BraveRewards bundle
@property (nonatomic, readonly, class) NSBundle *bat_current;

/// Get the BraveRewardsUI bundle
@property (nonatomic, readonly, class) NSBundle *bat_interfaceBundle;

#define BATLocalizedString(key, val) \
  NSLocalizedStringWithDefaultValue(key, nil, [NSBundle bat_current], val, nil)

@end

NS_ASSUME_NONNULL_END
