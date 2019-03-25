/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATAdsNotification.h"
#include "bat/ads/notification_info.h"
#import <map>

BATAdsConfirmationType BATAdsConfirmationTypeForString(NSString *string)
{
  std::map<std::string, BATAdsConfirmationType> map {
    {std::string(ads::kConfirmationTypeClick), BATAdsConfirmationTypeClick},
    {std::string(ads::kConfirmationTypeDismiss), BATAdsConfirmationTypeDismiss},
    {std::string(ads::kConfirmationTypeView), BATAdsConfirmationTypeView},
    {std::string(ads::kConfirmationTypeLanded), BATAdsConfirmationTypeLanded}
  };
  const auto key = std::string(string.UTF8String);
  if (map.count(key) == 0) {
    return BATAdsConfirmationTypeUnknown;
  }
  return map[key];
}

@interface BATAdsNotification ()
@property (nonatomic, copy) NSString *creativeSetID;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *advertiser;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSURL *url;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic) BATAdsConfirmationType confirmationType;
@end

@implementation BATAdsNotification

- (instancetype)initWithNotificationInfo:(const ads::NotificationInfo&)info
{
  if ((self = [super init])) {
    self.creativeSetID = [NSString stringWithUTF8String:info.creative_set_id.c_str()];
    self.category = [NSString stringWithUTF8String:info.category.c_str()];
    self.advertiser = [NSString stringWithUTF8String:info.advertiser.c_str()];
    self.text = [NSString stringWithUTF8String:info.text.c_str()];
    self.url = [NSURL URLWithString:[NSString stringWithUTF8String:info.url.c_str()]];
    self.uuid = [NSString stringWithUTF8String:info.uuid.c_str()];
    self.confirmationType = (BATAdsConfirmationType)info.type;
  }
  return self;
}

@end
