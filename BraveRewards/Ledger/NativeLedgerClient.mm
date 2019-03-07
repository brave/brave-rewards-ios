/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <Foundation/Foundation.h>

#import <iostream>
#import "NativeLedgerClient.h"
#import "NSArray+Vector.h"

class LogStreamImpl : public ledger::LogStream {
public:
  LogStreamImpl(const char* file,
                const int line,
                const ledger::LogLevel log_level) {
    
    std::map<ledger::LogLevel, std::string> map {
      {ledger::LOG_ERROR, "ERROR"},
      {ledger::LOG_WARNING, "WARNING"},
      {ledger::LOG_INFO, "INFO"},
      {ledger::LOG_DEBUG, "DEBUG"},
      {ledger::LOG_RESPONSE, "RESPONSE"}
    };
    std::string level = map[log_level];
    //    log_message_ = level + ": in " + file + " on line " + std::to_string(line) + ": ";
    log_message_ = level + ": ";
  }
  
  LogStreamImpl(const char* file,
                const int line,
                const int vlog_level) {
    
    std::map<int, std::string> map {
      {ledger::LOG_ERROR, "ERROR"},
      {ledger::LOG_WARNING, "WARNING"},
      {ledger::LOG_INFO, "INFO"},
      {ledger::LOG_DEBUG, "DEBUG"},
      {ledger::LOG_RESPONSE, "RESPONSE"}
    };
    std::string level = map[vlog_level];
    //    log_message_ = level + ": in " + file + " on line " + std::to_string(line) + ": ";
    log_message_ = level + ": ";
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

namespace ledger {
  NativeLedgerClient::NativeLedgerClient(id<NativeLedgerBridge> bridge)
  : ledger(Ledger::CreateInstance(this)),
  bridge(bridge),
  common([[BATCommonOperations alloc] initWithStoragePath:@"brave_ledger"]) {
  }
  
  NativeLedgerClient::~NativeLedgerClient() {
    bridge = nil;
    common = nil;
  }
  
  std::string NativeLedgerClient::GenerateGUID() const {
    return [common generateUUID];
  }
  
  void NativeLedgerClient::OnWalletInitialized(Result result) {
    [bridge ledger:this walletInitialized:result];
  }
  
  //  void NativeLedgerClient::OnWalletProperties(Result result, std::unique_ptr<ledger::WalletInfo> info) {
  //    [bridge ledger:this onWalletProperties:result info:std::move(info)];
  //  }
  
  void NativeLedgerClient::OnRecoverWallet(Result result, double balance, const std::vector<Grant>& grants) {
    if (walletRecoveredBlock != nullptr) {
      //      NSArray<BATLedgerGrant *> *grantList = NSArrayFromVector(grants, ^BATLedgerGrant *(const Grant grant){
      //        return [[BATLedgerGrant alloc] initWithGrant:grant];
      //      });
      //      walletRecoveredBlock(result, balance, grantList);
    }
  }
  
  void NativeLedgerClient::OnGrant(Result result, const Grant& grant) { }
  void NativeLedgerClient::OnGrantCaptcha(const std::string& image, const std::string& hint) { }
  
  void NativeLedgerClient::OnReconcileComplete(Result result,
                                               const std::string& viewing_id,
                                               REWARDS_CATEGORY category,
                                               const std::string& probi) { }
  void NativeLedgerClient::OnGrantFinish(Result result,
                                         const Grant& grant) { }
  
  void NativeLedgerClient::LoadLedgerState(LedgerCallbackHandler* handler) {
    const auto contents = [common loadContentsFromFileWithName:"ledger_state.json"];
    if (contents.length() > 0) {
      handler->OnLedgerStateLoaded(LEDGER_OK, contents);
    } else {
      handler->OnLedgerStateLoaded(LEDGER_ERROR, contents);
    }
  }
  
  void NativeLedgerClient::SaveLedgerState(const std::string& ledger_state, LedgerCallbackHandler* handler) {
    const auto result = [common saveContents:ledger_state name:"ledger_state.json"];
    handler->OnLedgerStateSaved(result ? LEDGER_OK : LEDGER_ERROR);
  }
  
  void NativeLedgerClient::LoadPublisherState(LedgerCallbackHandler* handler) {
    const auto contents = [common loadContentsFromFileWithName:"publisher_state.json"];
    if (contents.length() > 0) {
      handler->OnPublisherStateLoaded(LEDGER_OK, contents);
    } else {
      handler->OnPublisherStateLoaded(LEDGER_ERROR, contents);
    }
  }
  
  void NativeLedgerClient::SavePublisherState(const std::string& publisher_state,
                                              LedgerCallbackHandler* handler) {
    const auto result = [common saveContents:publisher_state name:"publisher_state.json"];
    handler->OnPublisherStateSaved(result ? LEDGER_OK : LEDGER_ERROR);
  }
  
  void NativeLedgerClient::LoadPublisherList(LedgerCallbackHandler* handler) {
    const auto contents = [common loadContentsFromFileWithName:"publisher_list.json"];
    if (contents.length() > 0) {
      handler->OnPublisherListLoaded(LEDGER_OK, contents);
    } else {
      handler->OnPublisherListLoaded(LEDGER_ERROR, contents);
    }
  }
  
  void NativeLedgerClient::SavePublishersList(const std::string& publishers_list, LedgerCallbackHandler* handler) {
    const auto result = [common saveContents:publishers_list name:"publisher_list.json"];
    handler->OnPublishersListSaved(result ? LEDGER_OK : LEDGER_ERROR);
  }
  
  void NativeLedgerClient::SavePublisherInfo(std::unique_ptr<PublisherInfo> publisher_info,
                                             PublisherInfoCallback callback) { }
  void NativeLedgerClient::LoadPublisherInfo(const std::string& publisher_key,
                                             PublisherInfoCallback callback) { }
  void NativeLedgerClient::LoadPanelPublisherInfo(ActivityInfoFilter filter,
                                                  PublisherInfoCallback callback) { }
  void NativeLedgerClient::SetTimer(uint64_t time_offset, uint32_t* timer_id) {
    const auto createdTimerID = [common createTimerWithOffset:time_offset timerFired:^(uint32_t firedTimerID) {
      if (!common) { return; }
      ledger->OnTimer(firedTimerID);
    }];
    *timer_id = createdTimerID;
  }
  
  void NativeLedgerClient::KillTimer(const uint32_t timer_id) {
    [common removeTimerWithID:timer_id];
  }
  
  void NativeLedgerClient::LoadNicewareList(GetNicewareListCallback callback) { }
  
  void NativeLedgerClient::LoadURL(const std::string &url, const std::vector<std::string> &headers, const std::string &content, const std::string &contentType, const ledger::URL_METHOD method, ledger::LoadURLCallback callback) {
    std::map<ledger::URL_METHOD, std::string> methodMap {
      {ledger::GET, "GET"},
      {ledger::POST, "POST"},
      {ledger::PUT, "PUT"}
    };
    return [common loadURLRequest:url headers:headers content:content content_type:contentType method:methodMap[method] callback:^(int statusCode, const std::string &response, const std::map<std::string, std::string> &headers) {
      callback(statusCode, response, headers);
    }];
  }
  
  void NativeLedgerClient::OnPublisherActivity(Result result,
                                               std::unique_ptr<PublisherInfo> info,
                                               uint64_t windowId) { }
  void NativeLedgerClient::FetchFavIcon(const std::string& url,
                                        const std::string& favicon_key,
                                        FetchIconCallback callback) { }
  void NativeLedgerClient::SaveContributionInfo(const std::string& probi,
                                                const int month,
                                                const int year,
                                                const uint32_t date,
                                                const std::string& publisher_key,
                                                const REWARDS_CATEGORY category) { }
  void NativeLedgerClient::GetRecurringDonations(PublisherInfoListCallback callback) { }
  std::unique_ptr<LogStream> NativeLedgerClient::Log(const char* file, int line, LogLevel level) const {
    return std::make_unique<LogStreamImpl>(file, line, level);
  }
  void NativeLedgerClient::LoadMediaPublisherInfo(
                                                  const std::string& media_key,
                                                  PublisherInfoCallback callback) { }
  void NativeLedgerClient::SaveMediaPublisherInfo(const std::string& media_key, const std::string& publisher_id) { }
  
  void NativeLedgerClient::FetchWalletProperties() { }
  void NativeLedgerClient::GetGrantCaptcha() { }
  
  std::string NativeLedgerClient::URIEncode(const std::string& value) {
    const auto allowedCharacters = [NSMutableCharacterSet alphanumericCharacterSet];
    [allowedCharacters addCharactersInString:@"-._~"];
    const auto string = [NSString stringWithUTF8String:value.c_str()];
    const auto encoded = [string stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return std::string(encoded.UTF8String);
  }
  
  void NativeLedgerClient::SavePendingContribution(
                                                   const PendingContributionList& list) { }
  
  void NativeLedgerClient::LoadActivityInfo(ActivityInfoFilter filter,
                                            PublisherInfoCallback callback) { }
  
  void NativeLedgerClient::SaveActivityInfo(std::unique_ptr<PublisherInfo> publisher_info,
                                            PublisherInfoCallback callback) { }
  
  void NativeLedgerClient::OnRestorePublishers(OnRestoreCallback callback) { }
  
  void NativeLedgerClient::GetActivityInfoList(uint32_t start,
                                               uint32_t limit,
                                               ActivityInfoFilter filter,
                                               PublisherInfoListCallback callback) { }
  
  void NativeLedgerClient::OnRemoveRecurring(const std::string& publisher_key,
                                             RecurringRemoveCallback callback) {
    
  }
  
  std::unique_ptr<LogStream> NativeLedgerClient::VerboseLog(const char* file, int line, int vlog_level) const {
    return std::make_unique<LogStreamImpl>(file, line, vlog_level);
  }
  void NativeLedgerClient::SaveNormalizedPublisherList(const ledger::PublisherInfoListStruct& normalized_list) {}
  void NativeLedgerClient::SaveState(const std::string& name, const std::string& value, ledger::OnSaveCallback callback) {}
  void NativeLedgerClient::LoadState(const std::string& name, ledger::OnLoadCallback callback) {}
  void NativeLedgerClient::ResetState(const std::string& name, ledger::OnResetCallback callback) {}
  void NativeLedgerClient::SetConfirmationsIsReady(const bool is_ready) {}
  void NativeLedgerClient::FetchGrants(const std::string &lang, const std::string &paymentId) {}
  
  void NativeLedgerClient::OnPanelPublisherInfo(Result result, std::unique_ptr<ledger::PublisherInfo>, uint64_t windowId) {}
  void NativeLedgerClient::OnExcludedSitesChanged(const std::string& publisher_id, ledger::PUBLISHER_EXCLUDE exclude) {}
  
  void NativeLedgerClient::ConfirmationsTransactionHistoryDidChange() {}
  void NativeLedgerClient::GetExcludedPublishersNumberDB(GetExcludedPublishersNumberDBCallback callback) {}
}
