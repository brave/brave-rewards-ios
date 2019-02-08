/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#pragma once

#import <Foundation/Foundation.h>

template <class T>
static NSArray *NSArrayFromVector(std::vector<T> vector)
{
  NSMutableArray *result = [[NSMutableArray alloc] init];
  for (const auto& v : vector) {
    [result addObject:v];
  }
  return [result copy];
}

template <class T, class U>
static NSArray<U> *NSArrayFromVector(std::vector<T> vector, U(^mapValue)(const T))
{
  NSMutableArray *result = [[NSMutableArray alloc] init];
  for (T v : vector) {
    [result addObject:mapValue(v)];
  }
  return [result copy];
}

// Specializations

template <>
inline NSArray *NSArrayFromVector(std::vector<int> vector) {
  return NSArrayFromVector(vector, ^(const int v){ return @(v); });
}

template <>
inline NSArray *NSArrayFromVector(std::vector<double> vector) {
  return NSArrayFromVector(vector, ^(const double v){ return @(v); });
}

template <>
inline NSArray *NSArrayFromVector(std::vector<std::string> vector) {
  return NSArrayFromVector(vector, ^(const std::string v){
    return [NSString stringWithUTF8String:v.c_str()];
  });
}
