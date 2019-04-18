/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import "TestFoo.h"
#import "CppTransformations.h"

@implementation TestFoo

- (instancetype)initWithCppFoo:(const CppFoo&)foo
{
  if ((self = [super init])) {
    self.boolean = foo.boolean;
    self.integer = foo.integer;
    self.numbers = NSArrayFromVector(foo.numbers);
    self.stringObject = [NSString stringWithUTF8String:foo.stringObject.c_str()];
  }
  return self;
}

@end
