/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BATActivityInfoFilter.h"

NS_ASSUME_NONNULL_BEGIN

@interface ActivityInfo : NSManagedObject

+ (void)deleteWithPublisherID:(NSString *)publisherID reconcileStamp:(uint64_t)reconcileStamp;

@end

NS_ASSUME_NONNULL_END

#import "PublisherInfo.h"
#import "ActivityInfo+CoreDataProperties.h"
