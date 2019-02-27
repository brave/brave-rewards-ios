/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

public class TippingOption: NSObject {
  var value: String
  var crypto: String
  var cryptoImage: UIImage
  var dollarValue: String
  
  fileprivate var view: TippingOptionView?
  
  public init(value: String, crypto: String, cryptoImage: UIImage, dollarValue: String) {
    self.value = value
    self.crypto = crypto
    self.cryptoImage = cryptoImage
    self.dollarValue = dollarValue
    
    super.init()
  }
  
  @objc public class func batAmount(_ value: String, dollarValue: String) -> TippingOption {
    return TippingOption(
      value: value,
      crypto: "BAT",
      cryptoImage: UIImage(frameworkResourceNamed: "bat"),
      dollarValue: dollarValue
    )
  }
}

public class TippingSelectionView: UIView {
  let titleLabel = UILabel().then {
    $0.textColor = .white
    $0.font = .systemFont(ofSize: 18.0, weight: .bold)
    $0.text = BATLocalizedString("BraveRewardsTippingAmountTitle", "Tip amount")
  }
  private let walletBalanceView = WalletBalanceView()
  private let optionsStackView = UIStackView().then {
    $0.spacing = 10.0
    $0.distribution = .fillEqually
  }
  private let monthlyToggleButton = Button(type: .system).then {
    $0.setTitle(BATLocalizedString("BraveRewardsTippingMakeMonthly", "Make this monthly"), for: .normal)
    $0.setImage(UIImage(frameworkResourceNamed: "checkbox"), for: .normal)
    $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    $0.tintColor = .white
  }
  let sendTipButton = SendTipButton()
  
  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError()
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = Colors.blurple500
    
    monthlyToggleButton.addTarget(self, action: #selector(tappedMonthlyToggle), for: .touchUpInside)
    
    addSubview(titleLabel)
    addSubview(walletBalanceView)
    addSubview(optionsStackView)
    addSubview(monthlyToggleButton)
    addSubview(sendTipButton)
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(self).offset(20.0)
      $0.leading.equalTo(self).offset(25.0)
      $0.trailing.lessThanOrEqualTo(self.walletBalanceView.snp.leading).offset(-15.0)
    }
    walletBalanceView.snp.makeConstraints {
      $0.firstBaseline.equalTo(self.titleLabel)
      $0.trailing.equalTo(self).offset(-25.0)
    }
    optionsStackView.snp.makeConstraints {
      $0.top.equalTo(self.titleLabel.snp.bottom).offset(20.0)
      $0.leading.trailing.equalTo(self).inset(15.0)
    }
    monthlyToggleButton.snp.makeConstraints {
      $0.top.equalTo(self.optionsStackView.snp.bottom).offset(20.0)
      $0.leading.greaterThanOrEqualTo(self).offset(25.0)
      $0.trailing.lessThanOrEqualTo(self).offset(25.0)
      $0.centerX.equalTo(self)
    }
    sendTipButton.snp.makeConstraints {
      $0.top.equalTo(self.monthlyToggleButton.snp.bottom).offset(15.0)
      $0.leading.trailing.bottom.equalTo(self)
    }
  }
  
  public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    
    let isWideLayout = traitCollection.horizontalSizeClass == .regular
    optionsStackView.axis = isWideLayout ? .vertical : .horizontal
    optionsStackView.distribution = isWideLayout ? .fill : .fillEqually
  }
  
  @objc private func tappedMonthlyToggle() {
    isMonthly.toggle()
  }
  
  // MARK: - Wallet Balance
  
  @objc public func setWalletBalance(_ value: String, crypto: String) {
    walletBalanceView.valueLabel.text = value
    walletBalanceView.cryptoLabel.text = crypto
  }
  
  // MARK: - Options
  
  @objc public var isMonthly: Bool = false {
    didSet {
      monthlyToggleButton.setImage(UIImage(frameworkResourceNamed: isMonthly ? "checkbox-checked" : "checkbox").alwaysOriginal, for: .normal)
    }
  }
  
  @objc public var selectedOptionIndex: Int {
    get {
      return options.firstIndex(where: { $0.view?.isSelected == true }) ?? -1
    }
    set {
      if newValue < options.count {
        options[newValue].view?.isSelected = true
      }
    }
  }
  
  @objc public var options: [TippingOption] = [] {
    willSet {
      options.forEach { $0.view?.removeFromSuperview() }
    }
    didSet {
      for option in options {
        let view = TippingOptionView()
        view.cryptoLabel.text = option.crypto
        view.cryptoLogoImageView.image = option.cryptoImage
        view.valueLabel.text = option.value
        view.dollarLabel.text = option.dollarValue
        option.view = view
        
        view.addTarget(self, action: #selector(tappedOption(_:)), for: .touchUpInside)
        optionsStackView.addArrangedSubview(view)
      }
    }
  }
  
  @objc private func tappedOption(_ optionView: TippingOptionView) {
    for option in options {
      option.view?.isSelected = option.view === optionView
    }
  }
}

extension TippingSelectionView {
  // "wallet balance X BAT"
  fileprivate class WalletBalanceView: UIStackView {
    let titleLabel = UILabel().then {
      $0.textColor = Colors.blurple700
      $0.font = .systemFont(ofSize: 12.0)
      $0.text = BATLocalizedString("BraveRewardsTippingWalletBalanceTitle", "wallet balance")
    }
    let valueLabel = UILabel().then {
      $0.textColor = .white
      $0.font = .systemFont(ofSize: 12.0, weight: .medium)
    }
    let cryptoLabel = UILabel().then {
      $0.textColor = .white
      $0.font = .systemFont(ofSize: 12.0, weight: .medium)
    }
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      
      spacing = 2.0
      alignment = .firstBaseline
      setContentCompressionResistancePriority(UILayoutPriority(rawValue: 850), for: .horizontal)
      setContentHuggingPriority(.required, for: .horizontal)
      
      addArrangedSubview(titleLabel)
      addArrangedSubview(valueLabel)
      addArrangedSubview(cryptoLabel)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
      fatalError()
    }
  }
}
