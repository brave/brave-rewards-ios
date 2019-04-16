/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#pragma once

#import <Foundation/Foundation.h>
#import <iostream>

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
