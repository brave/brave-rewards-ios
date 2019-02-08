//
//  NSURL+Extensions.m
//  BraveRewards
//
//  Created by Kyle Hickinson on 2019-01-22.
//  Copyright © 2019 Kyle Hickinson. All rights reserved.
//

#import "NSURL+Extensions.h"

@implementation NSURL (Extensions)

- (NSString *)bat_normalizedHost
{
  const auto host = self.host;
  const auto range = [host rangeOfString:@"^(www|mobile|m)\\." options:NSRegularExpressionSearch];
  if (range.length > 0) {
    return [host stringByReplacingCharactersInRange:range withString:@""];
  }
  return host;
}

@end
