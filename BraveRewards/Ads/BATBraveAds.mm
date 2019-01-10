/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATBraveAds.h"

#import "NativeAdsClient.h"

// Create a getter/setter that syncs with a given property in the NativeAdsClient C++ object
#define BATNativeBasicPropertyBridge(__type, __objc_getter, __objc_setter, cpp_name) \
  - (__type)__objc_getter { return adsClient->cpp_name; } \
  - (void)__objc_setter:(__type)newValue { adsClient->cpp_name = newValue; }

@interface BATBraveAds () {
  ads::NativeAdsClient *adsClient;
}
@end

@implementation BATBraveAds

- (instancetype)initWithAppVersion:(NSString *)version
{
  return [self initWithAppVersion:version enabled:NO];
}

- (instancetype)initWithAppVersion:(NSString *)version enabled:(BOOL)enabled
{
  if ((self = [super init])) {
    adsClient = new ads::NativeAdsClient(std::string(version.UTF8String));
    self.enabled = enabled;
  }
  return self;
}

- (void)dealloc
{
  delete adsClient;
}

- (BOOL)isEnabled
{
  return adsClient->isEnabled;
}

- (void)setEnabled:(BOOL)enabled
{
  adsClient->isEnabled = enabled;
  adsClient->Initialize();
}

BATNativeBasicPropertyBridge(NSInteger, numberOfAllowableAdsPerHour, setNumberOfAllowableAdsPerHour, adsPerHour);
BATNativeBasicPropertyBridge(NSInteger, numberOfAllowableAdsPerDay, setNumberOfAllowableAdsPerDay, adsPerDay);

- (NSArray<NSString *> *)supportedLocales
{
  auto locales = [[NSMutableArray alloc] init];
  for (const auto& l : adsClient->GetLocales()) {
    [locales addObject:[NSString stringWithUTF8String:l.c_str()]];
  }
  return [locales copy];
}

@end
