/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

public class PopoverNavigationController: UINavigationController {
  
  private class NavigationBar: UINavigationBar {
    override var frame: CGRect {
      get { return super.frame.with { $0.origin.y = 8 } }
      set { super.frame = newValue }
    }
    override var barPosition: UIBarPosition {
      return .topAttached
    }
  }
  
  init() {
    super.init(navigationBarClass: NavigationBar.self, toolbarClass: nil)
    modalPresentationStyle = .currentContext
  }
  
  public override init(rootViewController: UIViewController) {
    super.init(navigationBarClass: NavigationBar.self, toolbarClass: nil)
    modalPresentationStyle = .currentContext
    viewControllers = [rootViewController]
  }
  
  @available(*, unavailable)
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
    modalPresentationStyle = .currentContext
  }
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
  
  public override var additionalSafeAreaInsets: UIEdgeInsets {
    get { return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0) }
    set { }
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    if !isNavigationBarHidden {
      var navBarFrame = navigationBar.frame
      navBarFrame.origin.y = additionalSafeAreaInsets.top
      navigationBar.frame = navBarFrame
    }
  }
}
