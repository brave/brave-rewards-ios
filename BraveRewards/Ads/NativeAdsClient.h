/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#pragma once

#include "bat/ads/ads.h"

namespace ads {
  class NativeAdsClient : public AdsClient {
  public:
    NativeAdsClient(const std::string& applicationVersion);
    
#pragma mark - Obj-C bridge methods/properties
    
    void Initialize();
    /// Whether or not Brave Ads is enabled
    bool isEnabled = false;
    /// The number of ads that can be shown per hour
    uint64_t adsPerHour;
    /// The number of ads that can be shown per day
    uint64_t adsPerDay;
    /// Called to determine if newtork connectivity is available. By Default assume we have a connection
    bool isNetworkConnectivityAvailable = true;
    /// Called when the ads client wants to make a timer given the offset (1st arg)
    /// Should return the timer's unique id
    std::function<uint32_t(uint64_t)> makeTimerBlock;
    /// Called when the ads client wants to kill a timer given the timer id
    std::function<void(uint32_t)> killTimerBlock;
    /// Called on ShowNotification
    std::function<void(const NotificationInfo&)> showNotificationBlock;
    /// Called to load a URL request. Use callback when the call is completed.
    std::function<void(const std::string& url,
                       const std::vector<std::string>& headers,
                       const std::string& content,
                       const std::string& content_type,
                       const URLRequestMethod method,
                       URLRequestCallback callback)> urlRequestBlock;
    /// Called when the ads client wants to persist some data
    std::function<bool(const std::string& name, const std::string& contents)> saveFileBlock;
    /// Called when the ads client wants to load some saved data
    std::function<std::string(const std::string& name)> loadFileBlock;
    /// Called when the ads client wants to remove some persisted data
    std::function<bool(const std::string& name)> removeFileBlock;
    
#pragma mark - AdsClient methods
    
    std::unique_ptr<Ads> ads;
    
    /// Should return true if Brave Ads is enabled otherwise returns false
    bool IsAdsEnabled() const;
    
    /// Should return the operating system's locale, i.e. en, en_US or en_GB.UTF-8
    const std::string GetAdsLocale() const;
    
    /// Should return the number of ads that can be shown per hour
    uint64_t GetAdsPerHour() const;
    
    /// Should return the number of ads that can be shown per day
    uint64_t GetAdsPerDay() const;
    
    /// Sets the idle threshold specified in seconds, for how often OnIdle or
    /// OnUndle should be called
    void SetIdleThreshold(const int threshold);
    
    /// Should return true if there is a network connection otherwise returns false
    bool IsNetworkConnectionAvailable();
    
    /// Should get information about the client
    void GetClientInfo(ClientInfo* info) const;
    
    /// Should return a list of supported User Model locales
    const std::vector<std::string> GetLocales() const;
    
    /// Should load the User Model for the specified locale, user models are a
    /// dependency of the application and should be bundled accordingly, the
    /// following file structure could be used:
    void LoadUserModelForLocale(const std::string& locale,
                                OnLoadCallback callback) const;
    
    /// Should generate return a v4 UUID
    const std::string GenerateUUID() const;
    
    /// Should return true if the browser is in the foreground otherwise returns
    /// false
    bool IsForeground() const;
    
    /// Should return true if the operating system supports notifications otherwise
    /// returns false
    bool IsNotificationsAvailable() const;
    
    /// Should show a notification
    void ShowNotification(std::unique_ptr<ads::NotificationInfo> info);
    
    /// Should create a timer to trigger after the time offset specified in
    /// seconds. If the timer was created successfully a unique identifier should
    /// be returned, otherwise returns 0
    uint32_t SetTimer(const uint64_t time_offset);
    
    /// Should destroy the timer associated with the specified timer identifier
    void KillTimer(uint32_t timer_id);
    
    /// Should start a URL request
    void URLRequest(const std::string& url,
                    const std::vector<std::string>& headers,
                    const std::string& content,
                    const std::string& content_type,
                    const URLRequestMethod method,
                    URLRequestCallback callback);
    
    /// Should save a value to persistent storage
    void Save(const std::string& name,
              const std::string& value,
              OnSaveCallback callback);
    
    /// Should save the bundle state to persistent storage
    void SaveBundleState(std::unique_ptr<BundleState> state,
                         OnSaveCallback callback);
    
    /// Should load a value from persistent storage
    void Load(const std::string& name, OnLoadCallback callback);
    
    /// Should load a JSON schema from persistent storage, schemas are a dependency
    /// of the application and should be bundled accordingly
    const std::string LoadJsonSchema(const std::string& name);
    
    /// Should load the sample bundle from persistent storage
    void LoadSampleBundle(OnLoadSampleBundleCallback callback);
    
    /// Should reset a previously saved value, i.e. remove the file from persistent
    /// storage
    void Reset(const std::string& name, OnResetCallback callback);
    
    /// Should get ads for the specified region and category from the previously
    /// persisted bundle state
    void GetAds(const std::string& region,
                const std::string& category,
                OnGetAdsCallback callback);
    
    /// Should get the components of the specified URL
    bool GetUrlComponents(const std::string& url,
                          UrlComponents* components) const;
    
    /// Should log an event to persistent storage however as events may be queued
    /// they need an event name and timestamp adding as follows, replacing ... with
    /// the value of the "json" parameter:
    ///
    /// {
    ///   "time": "2018-11-19T15:47:43.634Z",
    ///   "eventName": "Event logged",
    ///   ...
    /// }
    void EventLog(const std::string& json);
    
    /// Should log diagnostic information
    std::unique_ptr<LogStream> Log(const char* file,
                                   const int line,
                                   const LogLevel log_level) const;
    
  private:
    const std::string& applicationVersion;
    
    std::unique_ptr<BundleState> bundleState;
    
    /// the idle threshold specified in seconds, TODO: Should notify the app about the change in idle time
    int idleThreshold;
  };
}
