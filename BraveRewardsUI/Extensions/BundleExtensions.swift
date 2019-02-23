/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation

private class _BundleClass {}

func BATLocalizedString(_ key: String, _ defaultValue: String, _ comment: String = "") -> String {
  return NSLocalizedString(key, bundle: Bundle(for: _BundleClass.self), value: defaultValue, comment: comment)
}
