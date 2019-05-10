/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATBraveAds.h"
#import "BATAdsNotification.h"

#import "NativeAdsClient.h"
#import "CppTransformations.h"

#import <Network/Network.h>
#import <UIKit/UIKit.h>

// Create a getter/setter that syncs with a given property in the NativeAdsClient C++ object
#define BATNativeBasicPropertyBridge(__type, __objc_getter, __objc_setter, cpp_name) \
  - (__type)__objc_getter { return adsClient->cpp_name; } \
  - (void)__objc_setter:(__type)newValue { adsClient->cpp_name = newValue; }

@interface BATAdsNotification ()
- (instancetype)initWithNotificationInfo:(const ads::NotificationInfo&)info;
@end

@interface BATBraveAds () {
  ads::NativeAdsClient *adsClient;
  nw_path_monitor_t networkMonitor;
  dispatch_queue_t monitorQueue;
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
    adsClient = new ads::NativeAdsClient(self, std::string(version.UTF8String));
    
    [self setupNetworkMonitoring];
    
    // Add notifications for standard app foreground/background
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(applicationDidBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    // Last thing we do is enable/disable it (since it will call `Initialize()` on the ads client)
    self.enabled = enabled;
  }
  return self;
}

- (void)dealloc
{
  [NSNotificationCenter.defaultCenter removeObserver:self];
  if (networkMonitor) { nw_path_monitor_cancel(networkMonitor); }
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
  return NSArrayFromVector(adsClient->GetLocales());
}

- (void)removeAllHistory
{
  adsClient->ads->RemoveAllHistory();
}

- (void)serveSampleAd
{
  adsClient->ads->ServeSampleAd();
}

#pragma mark -

- (void)showNotification:(const ads::NotificationInfo&)info
{
  const auto notification = [[BATAdsNotification alloc] initWithNotificationInfo:info];
  [self.delegate braveAds:self showNotification:notification];
  
  adsClient->ads->GenerateAdReportingNotificationShownEvent(info);
}

#pragma mark - Confirmations

- (void)setConfirmationsIsReady:(BOOL)isReady
{
  adsClient->ads->SetConfirmationsIsReady(isReady);
}

#pragma mark - Observers

- (void)applicationDidBecomeActive
{
  adsClient->ads->OnForeground();
}

- (void)applicationDidBackground
{
  adsClient->ads->OnBackground();
}

#pragma mark - Reporting

- (void)reportLoadedPageWithURL:(NSURL *)url html:(NSString *)html
{
  const auto urlString = std::string(url.absoluteString.UTF8String);
  adsClient->ads->ClassifyPage(urlString, std::string(html.UTF8String));
}

- (void)reportMediaStartedWithTabId:(NSInteger)tabId
{
  adsClient->ads->OnMediaPlaying((int32_t)tabId);
}

- (void)reportMediaStoppedWithTabId:(NSInteger)tabId
{
  adsClient->ads->OnMediaStopped((int32_t)tabId);
}

- (void)reportTabUpdated:(NSInteger)tabId url:(NSURL *)url isSelected:(BOOL)isSelected isPrivate:(BOOL)isPrivate
{
  const auto urlString = std::string(url.absoluteString.UTF8String);
  adsClient->ads->TabUpdated((int32_t)tabId, urlString, isSelected, isPrivate);
}

- (void)reportTabClosedWithTabId:(NSInteger)tabId
{
  adsClient->ads->TabClosed((int32_t)tabId);
}

@end
