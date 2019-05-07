/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <CoreData/CoreData.h>

@class BATActivityInfo;

NS_ASSUME_NONNULL_BEGIN

@interface BATPublisher : NSManagedObject
@property (nonatomic) BOOL excluded;
@property (nonatomic, copy) NSURL *faviconURL;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *provider;
@property (nonatomic, copy) NSString *publisherId;
@property (nonatomic, copy) NSURL *url;
@property (nonatomic) BOOL verified;
@property (nonatomic) BATActivityInfo *activity;
@end

NS_ASSUME_NONNULL_END
