// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

#import <Foundation/Foundation.h>
#import "bat/ads/ads_client.h"
#include <string>
#include <iostream>

class LogStreamImpl : public ads::LogStream {
public:
  LogStreamImpl(
                const char* file,
                const int line,
                const ads::LogLevel log_level) {
    std::map<ads::LogLevel, std::string> map {
      {ads::LOG_ERROR, "ERROR"},
      {ads::LOG_WARNING, "WARNING"},
      {ads::LOG_INFO, "INFO"}
    };
    
    log_message_ = map[log_level] + ": in " + file + " on line "
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
