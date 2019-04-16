/* WARNING: THIS FILE IS GENERATED. ANY CHANGES TO THIS FILE WILL BE OVERWRITTEN
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <Foundation/Foundation.h>
#import "bat/ledger/ledger_client.h"

@protocol NativeLedgerClientBridge
@required

- (void)confirmationsTransactionHistoryDidChange;
- (void)fetchFavIcon:(const std::string &)url faviconKey:(const std::string &)favicon_key callback:(ledger::FetchIconCallback)callback;
- (void)fetchGrants:(const std::string &)lang paymentId:(const std::string &)paymentId;
- (std::string)generateGUID;
- (void)getActivityInfoList:(uint32_t)start limit:(uint32_t)limit filter:(ledger::ActivityInfoFilter)filter callback:(ledger::PublisherInfoListCallback)callback;
- (void)getExcludedPublishersNumberDB:(ledger::GetExcludedPublishersNumberDBCallback)callback;
- (void)getGrantCaptcha:(const std::string &)promotion_id promotionType:(const std::string &)promotion_type;
- (void)getOneTimeTips:(ledger::PublisherInfoListCallback)callback;
- (void)getRecurringTips:(ledger::PublisherInfoListCallback)callback;
- (void)killTimer:(const uint32_t)timer_id;
- (void)loadActivityInfo:(ledger::ActivityInfoFilter)filter callback:(ledger::PublisherInfoCallback)callback;
- (void)loadLedgerState:(ledger::LedgerCallbackHandler *)handler;
- (void)loadMediaPublisherInfo:(const std::string &)media_key callback:(ledger::PublisherInfoCallback)callback;
- (void)loadNicewareList:(ledger::GetNicewareListCallback)callback;
- (void)loadPanelPublisherInfo:(ledger::ActivityInfoFilter)filter callback:(ledger::PublisherInfoCallback)callback;
- (void)loadPublisherInfo:(const std::string &)publisher_key callback:(ledger::PublisherInfoCallback)callback;
- (void)loadPublisherList:(ledger::LedgerCallbackHandler *)handler;
- (void)loadPublisherState:(ledger::LedgerCallbackHandler *)handler;
- (void)loadState:(const std::string &)name callback:(ledger::OnLoadCallback)callback;
- (void)loadURL:(const std::string &)url headers:(const std::vector<std::string> &)headers content:(const std::string &)content contentType:(const std::string &)contentType method:(const ledger::URL_METHOD)method callback:(ledger::LoadURLCallback)callback;
- (std::unique_ptr<ledger::LogStream>)log:(const char *)file line:(int)line logLevel:(const ledger::LogLevel)log_level;
- (void)onExcludedSitesChanged:(const std::string &)publisher_id exclude:(ledger::PUBLISHER_EXCLUDE)exclude;
- (void)onGrant:(ledger::Result)result grant:(const ledger::Grant &)grant;
- (void)onGrantCaptcha:(const std::string &)image hint:(const std::string &)hint;
- (void)onGrantFinish:(ledger::Result)result grant:(const ledger::Grant &)grant;
- (void)onPanelPublisherInfo:(ledger::Result)result arg1:(std::unique_ptr<ledger::PublisherInfo>)arg1 windowId:(uint64_t)windowId;
- (void)onReconcileComplete:(ledger::Result)result viewingId:(const std::string &)viewing_id category:(ledger::REWARDS_CATEGORY)category probi:(const std::string &)probi;
- (void)onRecoverWallet:(ledger::Result)result balance:(double)balance grants:(const std::vector<ledger::Grant> &)grants;
- (void)onRemoveRecurring:(const std::string &)publisher_key callback:(ledger::RecurringRemoveCallback)callback;
- (void)onRestorePublishers:(ledger::OnRestoreCallback)callback;
- (void)onWalletInitialized:(ledger::Result)result;
- (void)onWalletProperties:(ledger::Result)result arg1:(std::unique_ptr<ledger::WalletInfo>)arg1;
- (void)resetState:(const std::string &)name callback:(ledger::OnResetCallback)callback;
- (void)saveActivityInfo:(std::unique_ptr<ledger::PublisherInfo>)publisher_info callback:(ledger::PublisherInfoCallback)callback;
- (void)saveContributionInfo:(const std::string &)probi month:(const int)month year:(const int)year date:(const uint32_t)date publisherKey:(const std::string &)publisher_key category:(const ledger::REWARDS_CATEGORY)category;
- (void)saveLedgerState:(const std::string &)ledger_state handler:(ledger::LedgerCallbackHandler *)handler;
- (void)saveMediaPublisherInfo:(const std::string &)media_key publisherId:(const std::string &)publisher_id;
- (void)saveNormalizedPublisherList:(const ledger::PublisherInfoListStruct &)normalized_list;
- (void)savePendingContribution:(const ledger::PendingContributionList &)list;
- (void)savePublisherInfo:(std::unique_ptr<ledger::PublisherInfo>)publisher_info callback:(ledger::PublisherInfoCallback)callback;
- (void)savePublisherState:(const std::string &)publisher_state handler:(ledger::LedgerCallbackHandler *)handler;
- (void)savePublishersList:(const std::string &)publisher_state handler:(ledger::LedgerCallbackHandler *)handler;
- (void)saveState:(const std::string &)name value:(const std::string &)value callback:(ledger::OnSaveCallback)callback;
- (void)setConfirmationsIsReady:(const bool)is_ready;
- (void)setTimer:(uint64_t)time_offset timerId:(uint32_t *)timer_id;
- (std::string)URIEncode:(const std::string &)value;
- (std::unique_ptr<ledger::LogStream>)verboseLog:(const char *)file line:(int)line vlogLevel:(int)vlog_level;

@end
