/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#pragma once

#import <Foundation/Foundation.h>

#import "BATBraveAds.h"

/// Methods that will be called in C++
@interface BATBraveAds (Private)

// Note to self on monday:
//  - Figure out how to generalize some of these, since the timer, url request and file loading/saving can be shared
//  - Pick whether or not we should only want ObjC classes here or leave the converting to the ObjC++ methods
//    (i.e. no std::string usage in ObjC++ side)
//  - Do the same for ledger (make a private category with methods that get called from C++)

- (void)showNotification:(const ads::NotificationInfo&)info;

@end
