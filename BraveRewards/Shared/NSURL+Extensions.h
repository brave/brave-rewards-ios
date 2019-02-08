//
//  NSURL+Extensions.h
//  BraveRewards
//
//  Created by Kyle Hickinson on 2019-01-22.
//  Copyright © 2019 Kyle Hickinson. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (Extensions)

@property (nonatomic, nullable, readonly) NSString *bat_normalizedHost;

@end

NS_ASSUME_NONNULL_END
