/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "BATBraveAds.h"
#import "BATBraveAdsNotification.h"

#import "NativeAdsClient.h"

#import <Network/Network.h>
#import <UIKit/UIKit.h>

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
@property (nonatomic, copy) NSMutableDictionary<NSNumber *, NSTimer *> *timers; // {ID: Timer}
@property (nonatomic, copy) NSMutableArray<NSURLSessionDataTask *> *runningTasks;
@end

@implementation BATBraveAds

- (instancetype)initWithAppVersion:(NSString *)version
{
  return [self initWithAppVersion:version enabled:NO];
}

- (instancetype)initWithAppVersion:(NSString *)version enabled:(BOOL)enabled
{
  if ((self = [super init])) {
    _timers = [[NSMutableDictionary alloc] init];
    _runningTasks = [[NSMutableArray alloc] init];
    adsClient = new ads::NativeAdsClient(std::string(version.UTF8String));
    
    [self setupCppBridgeMethods];
    [self setupNetworkMonitoring];
    
    // Setup the ads directory for persistant storage
    const auto adsDirectory = [self adsParentDirectory];
    if (![NSFileManager.defaultManager fileExistsAtPath:adsDirectory isDirectory:nil]) {
      [NSFileManager.defaultManager createDirectoryAtPath:adsDirectory
                              withIntermediateDirectories:true
                                               attributes:nil
                                                    error:nil];
    }
    
    // Add notifications for standard app foreground/background
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(applicationDidBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    // Last thing we do is enable/disable it (since it will call `Initialize()` on the ads client)
    self.enabled = enabled;
  }
  return self;
}

- (void)setupCppBridgeMethods
{
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
  
  adsClient->loadFileBlock = ^std::string(const std::string& name) {
    const auto filename = [NSString stringWithUTF8String:name.c_str()];
    const auto contents = std::string([weakSelf loadAdsData:filename].UTF8String);
    return std::string(contents);
  };
  
  adsClient->saveFileBlock = ^BOOL(const std::string& name, const std::string& contents) {
    const auto filename = [NSString stringWithUTF8String:name.c_str()];
    const auto nscontents = [NSString stringWithUTF8String:contents.c_str()];
    return [weakSelf saveAdsData:filename contents:nscontents];
  };
  
  adsClient->removeFileBlock = ^BOOL(const std::string& name) {
    const auto filename = [NSString stringWithUTF8String:name.c_str()];
    return [weakSelf removeAdsData:filename];
  };
  
  adsClient->urlRequestBlock = ^(const std::string& url,
                                 const std::vector<std::string>& headers,
                                 const std::string& content,
                                 const std::string& content_type,
                                 const ads::URLRequestMethod method,
                                 ads::URLRequestCallback callback) {
    [weakSelf loadURLRequest:url
                     headers:headers
                     content:content
                content_type:content_type
                      method:method
                    callback:callback];
  };
}

- (void)dealloc
{
  [NSNotificationCenter.defaultCenter removeObserver:self];
  if (networkMonitor) { nw_path_monitor_cancel(networkMonitor); }
  [self.runningTasks makeObjectsPerformSelector:@selector(cancel)];
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

- (void)removeAllHistory
{
  adsClient->ads->RemoveAllHistory();
}

- (void)serveSampleAd
{
  adsClient->ads->ServeSampleAd();
}

#pragma mark -

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
  
  adsClient->ads->GenerateAdReportingNotificationShownEvent(info);
}

- (NSString *)adsParentDirectory
{
  const auto directories = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, true);
  return [directories.firstObject stringByAppendingPathComponent:@"brave_ads"];
}

- (NSString *)adsDataPathForFilename:(NSString *)filename
{
  return [[self adsParentDirectory] stringByAppendingPathComponent:filename];
}

- (void)loadURLRequest:(const std::string&)url headers:(const std::vector<std::string>&)headers content:(const std::string&)content content_type:(const std::string&)content_type method:(const ads::URLRequestMethod)method callback:(ads::URLRequestCallback)callback
{
  const auto session = NSURLSession.sharedSession;
  const auto nsurl = [NSURL URLWithString:[NSString stringWithUTF8String:url.c_str()]];
  const auto request = [[NSMutableURLRequest alloc] initWithURL:nsurl];
  
  // At the moment `headers` is ignored, as I'm not sure how to use an array of strings to setup HTTP headers...
  
  if (content_type.length() > 0) {
    [request setValue:[NSString stringWithUTF8String:content_type.c_str()] forHTTPHeaderField:@"Content-Type"];
  }
  
  switch (method) {
    case ads::GET:
      request.HTTPMethod = @"GET";
      break;
    case ads::POST:
      request.HTTPMethod = @"POST";
      break;
    case ads::PUT:
      request.HTTPMethod = @"PUT";
      break;
  }
  if (method != ads::GET && content.length() > 0) {
    // Assumed http body
    request.HTTPBody = [[NSString stringWithUTF8String:content.c_str()] dataUsingEncoding:NSUTF8StringEncoding];
  }
  
  const auto __weak weakSelf = self;
  NSURLSessionDataTask *task = nil;
  task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable urlResponse, NSError * _Nullable error) {
    const auto strongSelf = weakSelf;
    if (!strongSelf) { return; };
    [strongSelf.runningTasks removeObject:task];
    
    const auto response = (NSHTTPURLResponse *)urlResponse;
    std::string json;
    if (data) {
      // Might be no reason to convert to an NSString back to a UTF8 pointer...
      json = std::string([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding].UTF8String);
    }
    // For some reason I couldn't just do `std::map<std::string, std::string> responseHeaders;` due to std::map's
    // non-const key insertion
    auto responseHeaders = new std::map<std::string, std::string>();
    [response.allHeaderFields enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
      if (![key isKindOfClass:NSString.class] || ![obj isKindOfClass:NSString.class]) { return; }
      std::string stringKey(((NSString *)key).UTF8String);
      std::string stringValue(((NSString *)obj).UTF8String);
      responseHeaders->insert(std::make_pair(stringKey, stringValue));
    }];
    callback((int)response.statusCode, json, *responseHeaders);
    delete responseHeaders;
  }];
  // dataTaskWithRequest returns _Nonnull, so no need to worry about initialized variable being nil
  [self.runningTasks addObject:task];
  [task resume];
}

- (BOOL)saveAdsData:(NSString *)filename contents:(NSString *)contents
{
  NSError *error = nil;
  const auto path = [self adsDataPathForFilename:filename];
  const auto result = [contents writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
  if (error) {
    NSLog(@"Failed to save ads data for %@: %@", filename, error.localizedDescription);
  }
  return result;
}

- (NSString *)loadAdsData:(NSString *)filename
{
  NSError *error = nil;
  const auto path = [self adsDataPathForFilename:filename];
  const auto contents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
  if (error) {
    NSLog(@"Failed to load ads data for %@: %@", filename, error.localizedDescription);
    return @"";
  }
  return contents;
}

- (BOOL)removeAdsData:(NSString *)filename
{
  NSError *error = nil;
  const auto path = [self adsDataPathForFilename:filename];
  const auto result = [NSFileManager.defaultManager removeItemAtPath:path error:&error];
  if (error) {
    NSLog(@"Failed to remove ads data for filename: %@", filename);
    return false;
  }
  return result;
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
