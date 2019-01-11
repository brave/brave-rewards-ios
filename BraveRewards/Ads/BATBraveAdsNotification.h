//
//  BATBraveAdsNotification.h
//  BraveRewards
//
//  Created by Kyle Hickinson on 2019-01-11.
//  Copyright © 2019 Kyle Hickinson. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(BraveAdsNotification)
@interface BATBraveAdsNotification : NSObject
@property (nonatomic, readonly, copy) NSString *creativeSetID;
@property (nonatomic, readonly, copy) NSString *category;
@property (nonatomic, readonly, copy) NSString *advertiser;
@property (nonatomic, readonly, copy) NSString *text;
@property (nonatomic, readonly, copy) NSURL *url;
@property (nonatomic, readonly, copy) NSString *uuid;
@end

NS_ASSUME_NONNULL_END
