/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <Foundation/Foundation.h>

#include <iostream>
#include "NativeLedgerClient.h"

class LogStreamImpl : public ledger::LogStream {
public:
  LogStreamImpl(
                const char* file,
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
  NativeLedgerClient::NativeLedgerClient() : ledger(Ledger::CreateInstance(this)) {
    
  }
  
  std::string NativeLedgerClient::GenerateGUID() const {
    return std::string([NSUUID UUID].UUIDString.UTF8String);
  }
  
  void NativeLedgerClient::OnWalletInitialized(ledger::Result result) {
    
  }
  void NativeLedgerClient::OnWalletProperties(ledger::Result result,
                          std::unique_ptr<ledger::WalletInfo> info) { }
  void NativeLedgerClient::OnGrant(ledger::Result result, const ledger::Grant& grant) { }
  void NativeLedgerClient::OnGrantCaptcha(const std::string& image, const std::string& hint) { }
  void NativeLedgerClient::OnRecoverWallet(ledger::Result result,
                       double balance,
                       const std::vector<ledger::Grant>& grants) { }
  void NativeLedgerClient::OnReconcileComplete(ledger::Result result,
                           const std::string& viewing_id,
                           ledger::REWARDS_CATEGORY category,
                           const std::string& probi) { }
  void NativeLedgerClient::OnGrantFinish(ledger::Result result,
                     const ledger::Grant& grant) { }
  void NativeLedgerClient::LoadLedgerState(ledger::LedgerCallbackHandler* handler) { }
  void NativeLedgerClient::LoadPublisherState(ledger::LedgerCallbackHandler* handler) { }
  void NativeLedgerClient::SaveLedgerState(const std::string& ledger_state,
                       ledger::LedgerCallbackHandler* handler) { }
  void NativeLedgerClient::SavePublisherState(const std::string& publisher_state,
                          ledger::LedgerCallbackHandler* handler) { }
  
  void NativeLedgerClient::SavePublisherInfo(std::unique_ptr<ledger::PublisherInfo> publisher_info,
                         ledger::PublisherInfoCallback callback) { }
  void NativeLedgerClient::LoadPublisherInfo(const std::string& publisher_key,
                         ledger::PublisherInfoCallback callback) { }
  void NativeLedgerClient::LoadPanelPublisherInfo(ledger::ActivityInfoFilter filter,
                              ledger::PublisherInfoCallback callback) { }
  void NativeLedgerClient::SavePublishersList(const std::string& publishers_list,
                          ledger::LedgerCallbackHandler* handler) { }
  void NativeLedgerClient::SetTimer(uint64_t time_offset, uint32_t& timer_id) { }
  void NativeLedgerClient::LoadPublisherList(ledger::LedgerCallbackHandler* handler) { }
  
  void NativeLedgerClient::LoadNicewareList(ledger::GetNicewareListCallback callback) { }
  
  void NativeLedgerClient::LoadURL(const std::string& url,
               const std::vector<std::string>& headers,
               const std::string& content,
               const std::string& contentType,
               const ledger::URL_METHOD& method,
               ledger::LoadURLCallback callback) { }
  
  void NativeLedgerClient::OnExcludedSitesChanged(const std::string& publisher_id) { }
  void NativeLedgerClient::OnPublisherActivity(ledger::Result result,
                           std::unique_ptr<ledger::PublisherInfo> info,
                           uint64_t windowId) { }
  void NativeLedgerClient::FetchFavIcon(const std::string& url,
                    const std::string& favicon_key,
                    ledger::FetchIconCallback callback) { }
  void NativeLedgerClient::SaveContributionInfo(const std::string& probi,
                            const int month,
                            const int year,
                            const uint32_t date,
                            const std::string& publisher_key,
                            const ledger::REWARDS_CATEGORY category) { }
  void NativeLedgerClient::GetRecurringDonations(ledger::PublisherInfoListCallback callback) { }
  std::unique_ptr<ledger::LogStream> NativeLedgerClient::Log(const char* file, int line, ledger::LogLevel level) const {
    return std::make_unique<LogStreamImpl>(file, line, level);
  }
  void NativeLedgerClient::LoadMediaPublisherInfo(
                              const std::string& media_key,
                              ledger::PublisherInfoCallback callback) { }
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
                               const ledger::PendingContributionList& list) { }
  
  void NativeLedgerClient::LoadActivityInfo(ledger::ActivityInfoFilter filter,
                        ledger::PublisherInfoCallback callback) { }
  
  void NativeLedgerClient::SaveActivityInfo(std::unique_ptr<ledger::PublisherInfo> publisher_info,
                        ledger::PublisherInfoCallback callback) { }
  
  void NativeLedgerClient::OnRestorePublishers(ledger::OnRestoreCallback callback) { }
  
  void NativeLedgerClient::GetActivityInfoList(uint32_t start,
                           uint32_t limit,
                           ledger::ActivityInfoFilter filter,
                           ledger::PublisherInfoListCallback callback) { }
  
  void NativeLedgerClient::OnRemoveRecurring(const std::string& publisher_key,
                         ledger::RecurringRemoveCallback callback) {
    
  }
}
