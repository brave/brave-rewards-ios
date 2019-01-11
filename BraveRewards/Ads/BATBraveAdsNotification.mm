//
//  BATBraveAdsNotification.m
//  BraveRewards
//
//  Created by Kyle Hickinson on 2019-01-11.
//  Copyright © 2019 Kyle Hickinson. All rights reserved.
//

#import "BATBraveAdsNotification.h"
#include "bat/ads/notification_info.h"

@interface BATBraveAdsNotification ()
@property (nonatomic, copy) NSString *creativeSetID;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *advertiser;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSURL *url;
@property (nonatomic, copy) NSString *uuid;
@end

@implementation BATBraveAdsNotification

- (instancetype)initWithNotificationInfo:(const ads::NotificationInfo&)info
{
  if ((self = [super init])) {
    self.creativeSetID = [NSString stringWithUTF8String:info.creative_set_id.c_str()];
    self.category = [NSString stringWithUTF8String:info.category.c_str()];
    self.advertiser = [NSString stringWithUTF8String:info.advertiser.c_str()];
    self.text = [NSString stringWithUTF8String:info.text.c_str()];
    self.url = [NSURL URLWithString:[NSString stringWithUTF8String:info.url.c_str()]];
    self.uuid = [NSString stringWithUTF8String:info.uuid.c_str()];
  }
  return self;
}

@end
