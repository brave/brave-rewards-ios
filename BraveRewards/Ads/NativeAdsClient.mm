/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <iostream>

#include "NativeAdsClient.h"

// Simply for pulling the NSBundle
@interface _BATBundleClass : NSObject
@end
@implementation _BATBundleClass
@end

class LogStreamImpl : public ads::LogStream {
public:
  LogStreamImpl(
                    const char* file,
                    const int line,
                    const ads::LogLevel log_level) {
    std::string level;
    
    switch (log_level) {
      case ads::LogLevel::LOG_ERROR: {
        level = "ERROR";
        break;
      }
      case ads::LogLevel::LOG_WARNING: {
        level = "WARNING";
        break;
      }
      case ads::LogLevel::LOG_INFO: {
        level = "INFO";
        break;
      }
    }
    
    log_message_ = level + ": in " + file + " on line "
    + std::to_string(line) + ": ";
  }
  
  std::ostream& stream() override {
    std::cout << std::endl << log_message_;
    return std::cout;
  }
  
private:
  std::string log_message_;
  
  // Not copyable, not assignable
  LogStreamImpl(const LogStreamImpl&) = delete;
  LogStreamImpl& operator=(const LogStreamImpl&) = delete;
};

namespace ads {
  NativeAdsClient::NativeAdsClient(const std::string& applicationVersion)
    : ads(Ads::CreateInstance(this)),
      applicationVersion(applicationVersion) {
  };
  
  void NativeAdsClient::Initialize() {
    ads->Initialize();
  }
  
  // Should return true if Brave Ads is enabled otherwise returns false
  bool NativeAdsClient::IsAdsEnabled() const {
    return isEnabled;
  }
  
  // Should return the operating system's locale, i.e. en, en_US or en_GB.UTF-8
  const std::string NativeAdsClient::GetAdsLocale() const {
    return std::string([NSLocale currentLocale].localeIdentifier.UTF8String);
  }
  
  // Should return the number of ads that can be shown per hour
  uint64_t NativeAdsClient::GetAdsPerHour() const {
    return adsPerHour;
  }
  
  // Should return the number of ads that can be shown per day
  uint64_t NativeAdsClient::GetAdsPerDay() const {
    return adsPerDay;
  }
  
  // Sets the idle threshold specified in seconds, for how often OnIdle or
  // OnUndle should be called
  void NativeAdsClient::SetIdleThreshold(const int threshold) {
    idleThreshold = threshold;
  }
  
  // Should return true if there is a network connection otherwise returns false
  bool NativeAdsClient::IsNetworkConnectionAvailable() {
    return isNetworkConnectivityAvailable;
  }
  
  // Should get information about the client
  void NativeAdsClient::GetClientInfo(ClientInfo* info) const {
    info->application_version = "1.0";
    info->platform = IOS;
    info->platform_version = std::string(UIDevice.currentDevice.systemVersion.UTF8String);
  }
  
  // Should return a list of supported User Model locales
  const std::vector<std::string> NativeAdsClient::GetLocales() const {
    std::vector<std::string> locales = { "en", "fr", "de" };
    return locales;
  }
  
  // Should load the User Model for the specified locale, user models are a
  // dependency of the application and should be bundled accordingly, the
  // following file structure could be used:
  void NativeAdsClient::LoadUserModelForLocale(const std::string& locale, OnLoadCallback callback) const {
    const auto bundle = [NSBundle bundleForClass:[_BATBundleClass class]];
    const auto localeKey = [[[NSString stringWithUTF8String:locale.c_str()] substringToIndex:2] lowercaseString];
    const auto path = [[bundle pathForResource:@"locales" ofType:nil]
                       stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/user_model.json", localeKey]];
    if (!path || path.length == 0) {
      callback(FAILED, "");
      return;
    }
    
    NSError *error = nil;
    const auto contents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (!contents || error) {
      callback(FAILED, "");
      return;
    }
    callback(SUCCESS, std::string(contents.UTF8String));
  }
  
  // Should generate return a v4 UUID
  const std::string NativeAdsClient::GenerateUUID() const {
    return std::string([NSUUID UUID].UUIDString.UTF8String);
  }
  
  // Should return true if the browser is in the foreground otherwise returns
  // false
  bool NativeAdsClient::IsForeground() const {
    return UIApplication.sharedApplication.applicationState == UIApplicationStateActive;
  }
  
  // Should return true if the operating system supports notifications otherwise
  // returns false
  bool NativeAdsClient::IsNotificationsAvailable() const {
    return true;
  }
  
  // Should show a notification
  void NativeAdsClient::ShowNotification(std::unique_ptr<NotificationInfo> info) {
    const auto& notification = info.get();
    if (notification != nullptr) {
      showNotificationBlock(*notification);
    }
  }
  
  // Should create a timer to trigger after the time offset specified in
  // seconds. If the timer was created successfully a unique identifier should
  // be returned, otherwise returns 0
  uint32_t NativeAdsClient::SetTimer(const uint64_t time_offset) {
    return makeTimerBlock(time_offset);
  }
  
  // Should destroy the timer associated with the specified timer identifier
  void NativeAdsClient::KillTimer(uint32_t timer_id) {
    killTimerBlock(timer_id);
  }
  
  // Should start a URL request
  void NativeAdsClient::URLRequest(const std::string& url,
                                   const std::vector<std::string>& headers,
                                   const std::string& content,
                                   const std::string& content_type,
                                   const URLRequestMethod method,
                                   URLRequestCallback callback) {
    urlRequestBlock(url, headers, content, content_type, method, callback);
  }
  
  // Should save a value to persistent storage
  void NativeAdsClient::Save(const std::string& name, const std::string& value, OnSaveCallback callback) {
    if (saveFileBlock(name, value)) {
      callback(SUCCESS);
    } else {
      callback(FAILED);
    }
  }
  
  // Should save the bundle state to persistent storage
  void NativeAdsClient::SaveBundleState(std::unique_ptr<BundleState> state, OnSaveCallback callback) {
    bundleState.reset(state.release());
    if (saveFileBlock("bundle.json", bundleState->ToJson())) {
      callback(SUCCESS);
    } else {
      callback(FAILED);
    }
  }
  
  // Should load a value from persistent storage
  void NativeAdsClient::Load(const std::string& name, OnLoadCallback callback) {
    const auto contents = loadFileBlock(name);
    if (contents.empty()) {
      callback(FAILED, "");
    } else {
      callback(SUCCESS, contents);
    }
  }
  
  // Should load a JSON schema from persistent storage, schemas are a dependency
  // of the application and should be bundled accordingly
  const std::string NativeAdsClient::LoadJsonSchema(const std::string& name) {
    const auto bundle = [NSBundle bundleForClass:[_BATBundleClass class]];
    const auto path = [bundle pathForResource:[NSString stringWithUTF8String:name.c_str()] ofType:nil];
    if (!path || path.length == 0) {
      return "";
    }
    NSError *error = nil;
    const auto contents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (!contents || error) {
      return "";
    }
    return std::string(contents.UTF8String);
  }
  
  // Should load the sample bundle from persistent storage
  void NativeAdsClient::LoadSampleBundle(OnLoadSampleBundleCallback callback) {
    const auto bundle = [NSBundle bundleForClass:[_BATBundleClass class]];
    const auto path = [bundle pathForResource:@"sample_bundle" ofType:@"json"];
    if (!path || path.length == 0) {
      callback(FAILED, "");
      return;
    }
    NSError *error = nil;
    const auto contents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (!contents || error) {
      callback(FAILED, "");
      return;
    }
    callback(SUCCESS, std::string(contents.UTF8String));
  }
  
  // Should reset a previously saved value, i.e. remove the file from persistent
  // storage
  void NativeAdsClient::Reset(const std::string& name, OnResetCallback callback) {
    if (removeFileBlock(name)) {
      callback(SUCCESS);
    } else {
      callback(FAILED);
    }
  }
  
  // Should get ads for the specified region and category from the previously
  // persisted bundle state
  void NativeAdsClient::GetAds(const std::string& region, const std::string& category, OnGetAdsCallback callback) {
    auto categories = bundleState->categories.find(category);
    if (categories == bundleState->categories.end()) {
      callback(FAILED, region, category, {});
      return;
    }
    
    callback(SUCCESS, region, category, categories->second);
  }
  
  // Should get the components of the specified URL
  bool NativeAdsClient::GetUrlComponents(const std::string& url, UrlComponents* components) const {
    const auto nsurl = [NSURL URLWithString:[NSString stringWithUTF8String:url.c_str()]];
    if (!nsurl) {
      return false;
    }
    components->url = url;
    if (nsurl.scheme) components->scheme = std::string(nsurl.scheme.UTF8String);
    if (nsurl.user) components->user = std::string(nsurl.user.UTF8String);
    if (nsurl.host) components->hostname = std::string(nsurl.host.UTF8String);
    if (nsurl.port) components->port = std::to_string(nsurl.port.intValue);
    if (nsurl.query) components->query = std::string(nsurl.query.UTF8String);
    if (nsurl.fragment) components->fragment = std::string(nsurl.fragment.UTF8String);
    return true;
  }
  
  // Should log an event to persistent storage however as events may be queued
  // they need an event name and timestamp adding as follows, replacing ... with
  // the value of the "json" parameter:
  //
  // {
  //   "time": "2018-11-19T15:47:43.634Z",
  //   "eventName": "Event logged",
  //   ...
  // }
  void NativeAdsClient::EventLog(const std::string& json) {
  }
  
  // Should log diagnostic information
  std::unique_ptr<LogStream> NativeAdsClient::Log(const char* file, const int line, const LogLevel log_level) const {
    return std::make_unique<LogStreamImpl>(file, line, log_level);
  }
}
