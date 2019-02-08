//
//  BATPublisher.h
//  BraveRewards
//
//  Created by Kyle Hickinson on 2019-01-21.
//  Copyright © 2019 Kyle Hickinson. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BATPublisherExclude) {
  /// Excluding all publishers???
  BATPublisherExcludeAll = -1,
  /// This tell us that user did not manually changed exclude state
  BATPublisherExcludeDefault,
  /// User manually changed it to exclude
  BATPublisherExcludeExcluded,
  /// User manually changed it to include and is overriding server flags
  BATPublisherExcludeIncluded
};

@interface BATPublisher : NSObject

@property (nonatomic, readonly) BATPublisherExclude excluded;
@property (nonatomic, readonly, copy) NSURL *faviconURL;
@property (nonatomic, readonly, copy) NSString *publisherId;
@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, copy) NSString *provider;
@property (nonatomic, readonly, copy) NSURL *url;
@property (nonatomic, readonly) BOOL verified;

@end

NS_ASSUME_NONNULL_END
