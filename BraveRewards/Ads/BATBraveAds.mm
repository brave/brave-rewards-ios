/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATBraveAds.h"
#import "BATBraveAdsNotification.h"

#import "NativeAdsClient.h"

#import <Network/Network.h>

// Create a getter/setter that syncs with a given property in the NativeAdsClient C++ object
#define BATNativeBasicPropertyBridge(__type, __objc_getter, __objc_setter, cpp_name) \
  - (__type)__objc_getter { return adsClient->cpp_name; } \
  - (void)__objc_setter:(__type)newValue { adsClient->cpp_name = newValue; }

@interface BATBraveAdsNotification ()
- (instancetype)initWithNotificationInfo:(const ads::NotificationInfo&)info;
@end

@interface BATBraveAds () {
  ads::NativeAdsClient *adsClient;
  nw_path_monitor_t networkMonitor;
  dispatch_queue_t monitorQueue;
}
@property (nonatomic, assign) uint32_t currentTimerID;
@property (nonatomic, copy) NSMutableDictionary<NSNumber *, NSTimer *> *timers; // ID: Timer
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
    self.timers = [[NSMutableDictionary alloc] init];
    
    [self setupNetworkMonitoring];
    
    auto const __weak weakSelf = self;
    adsClient->makeTimerBlock = ^uint32_t(uint64_t offset){
      if (!weakSelf) { return 0; }
      return [weakSelf createTimerForOffset:offset];
    };
    
    adsClient->killTimerBlock = ^(uint32_t timerID){
      [weakSelf killTimerForID:timerID];
    };
    
    adsClient->showNotificationBlock = ^(const ads::NotificationInfo& info){
      [weakSelf showNotification:info];
    };
  }
  return self;
}

- (void)dealloc
{
  nw_path_monitor_cancel(networkMonitor);
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

- (void)setupNetworkMonitoring
{
  auto const __weak weakSelf = self;
  
  monitorQueue = dispatch_queue_create("bat.nw.monitor", DISPATCH_QUEUE_SERIAL);
  networkMonitor = nw_path_monitor_create();
  nw_path_monitor_set_queue(networkMonitor, monitorQueue);
  nw_path_monitor_set_update_handler(networkMonitor, ^(nw_path_t  _Nonnull path) {
    const auto strongSelf = weakSelf;
    if (!strongSelf) { return; }
    strongSelf->adsClient->isNetworkConnectivityAvailable = (nw_path_get_status(path) == nw_path_status_satisfied ||
                                                             nw_path_get_status(path) == nw_path_status_satisfiable);
  });
  nw_path_monitor_start(networkMonitor);
}

- (NSArray<NSString *> *)supportedLocales
{
  auto locales = [[NSMutableArray alloc] init];
  for (const auto& l : adsClient->GetLocales()) {
    [locales addObject:[NSString stringWithUTF8String:l.c_str()]];
  }
  return [locales copy];
}

- (uint32_t)createTimerForOffset:(uint64_t)offset
{
  self.currentTimerID++;
  const auto timerID = self.currentTimerID;
  
  auto const __weak weakSelf = self;
  self.timers[[NSNumber numberWithUnsignedInt:timerID]] =
  [NSTimer scheduledTimerWithTimeInterval:offset repeats:true block:^(NSTimer * _Nonnull timer) {
    const auto strongSelf = weakSelf;
    if (!strongSelf) { return; }
    strongSelf->adsClient->ads->OnTimer(timerID);
  }];
  return timerID;
}

- (void)killTimerForID:(uint32_t)timerID
{
  const auto key = [NSNumber numberWithUnsignedInteger:timerID];
  const auto timer = self.timers[key];
  [timer invalidate];
  [self.timers removeObjectForKey:key];
}

- (void)showNotification:(const ads::NotificationInfo&)info
{
  const auto notification = [[BATBraveAdsNotification alloc] initWithNotificationInfo:info];
  [self.delegate braveAds:self showNotification:notification];
}

@end
