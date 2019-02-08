/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <Foundation/Foundation.h>

#import <iostream>
#import "NativeLedgerClient.h"
#import "BATLedgerGrant+Private.h"
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

namespace ledger {
  NativeLedgerClient::NativeLedgerClient(BATBraveLedger *objcLedger)
  : ledger(Ledger::CreateInstance(this)),
    objcLedger(objcLedger),
    common([[BATCommonOperations alloc] initWithStoragePath:@"brave_ledger"]) {
  }
  
  NativeLedgerClient::~NativeLedgerClient() {
    objcLedger = nil;
    common = nil;
  }
  
  std::string NativeLedgerClient::GenerateGUID() const {
    return [common generateUUID];
  }
  
  void NativeLedgerClient::OnWalletInitialized(Result result) {
    if (walletInitializedBlock != nullptr) {
      walletInitializedBlock(result);
    }
  }
  
  void NativeLedgerClient::OnWalletProperties(Result result, std::unique_ptr<WalletInfo> info) {
    [objcLedger handleUpdatedWallet:result walletInfo:std::move(info)];
  }
  
  void NativeLedgerClient::OnRecoverWallet(Result result, double balance, const std::vector<Grant>& grants) {
    if (walletRecoveredBlock != nullptr) {
      NSArray<BATLedgerGrant *> *grantList = NSArrayFromVector(grants, ^BATLedgerGrant *(const Grant grant){
        return [[BATLedgerGrant alloc] initWithGrant:grant];
      });
      walletRecoveredBlock(result, balance, grantList);
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
  void NativeLedgerClient::SetTimer(uint64_t time_offset, uint32_t& timer_id) {
    const auto createdTimerID = [common createTimerWithOffset:time_offset timerFired:^(uint32_t firedTimerID) {
      if (!common) { return; }
      ledger->OnTimer(firedTimerID);
    }];
    timer_id = createdTimerID;
  }
  
  void NativeLedgerClient::LoadNicewareList(GetNicewareListCallback callback) { }
  
  void NativeLedgerClient::LoadURL(const std::string& url,
               const std::vector<std::string>& headers,
               const std::string& content,
               const std::string& contentType,
               const URL_METHOD& method,
               LoadURLCallback callback) {
    std::map<ledger::URL_METHOD, std::string> methodMap {
      {ledger::GET, "GET"},
      {ledger::POST, "POST"},
      {ledger::PUT, "PUT"}
    };
    return [common loadURLRequest:url headers:headers content:content content_type:contentType method:methodMap[method] callback:^(int statusCode, const std::string &response, const std::map<std::string, std::string> &headers) {
      callback(statusCode, response, headers);
    }];
  }
  
  void NativeLedgerClient::OnExcludedSitesChanged(const std::string& publisher_id) { }
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
  void NativeLedgerClient::FetchGrant(const std::string& lang, const std::string& paymentId) { }
  void NativeLedgerClient::GetGrantCaptcha() { }
  
  std::string NativeLedgerClient::URIEncode(const std::string& value) {
    return std::string();
  }
  
  void NativeLedgerClient::SetContributionAutoInclude(const std::string& publisher_key,
                                  bool excluded, uint64_t windowId) { }
  
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
}
