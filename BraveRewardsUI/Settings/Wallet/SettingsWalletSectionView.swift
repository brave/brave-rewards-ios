/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

public class SettingsWalletSectionView: SettingsSectionView {
  @objc public func setWalletBalance(_ value: String, crypto: String, dollarValue: String) {
    balanceLabel.text = value
    altcurrencyTypeLabel.text = crypto
    usdBalanceLabel.text = dollarValue
  }
  
  private let backgroundView = GradientView().then {
    $0.gradientLayer.colors = [ UIColor(57, 45, 209).cgColor,
                                UIColor(87, 19, 166).cgColor ]
    $0.gradientLayer.startPoint = CGPoint(x: 0.2, y: 0)
    $0.gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.5)
  }
  
  private let watermarkImageView = UIImageView(image: UIImage(frameworkResourceNamed: "bat-watermark"))
  
  private let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 4.0
    $0.alignment = .center
  }
  
  let titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14.0, weight: .medium)
    $0.textColor = UIColor(white: 1.0, alpha: 0.65)
    $0.text = BATLocalizedString("BraveRewardsWalletHeaderTitle", "Your Wallet")
  }
  
  let altcurrencyContainerView = UIStackView().then {
    $0.spacing = 4.0
    $0.alignment = .lastBaseline
  }
  
  public let balanceLabel = UILabel().then {
    $0.textColor = .white
    $0.font = .systemFont(ofSize: 30.0)
  }
  
  public let altcurrencyTypeLabel = UILabel().then {
    $0.textColor = UIColor(white: 1.0, alpha: 0.65)
    $0.font = .systemFont(ofSize: 16.0)
  }
  
  public let usdBalanceLabel = UILabel().then {
    $0.textAlignment = .center
    $0.textColor = UIColor(white: 1.0, alpha: 0.65)
    $0.font = .systemFont(ofSize: 12.0)
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    clippedContentView.addSubview(backgroundView)
    clippedContentView.addSubview(watermarkImageView)
    clippedContentView.addSubview(titleLabel)
    clippedContentView.addSubview(stackView)
    stackView.addArrangedSubview(altcurrencyContainerView)
    stackView.addArrangedSubview(usdBalanceLabel)
    altcurrencyContainerView.addArrangedSubview(balanceLabel)
    altcurrencyContainerView.addArrangedSubview(altcurrencyTypeLabel)
    
    backgroundView.snp.makeConstraints {
      $0.edges.equalTo(self)
    }
    watermarkImageView.snp.makeConstraints {
      $0.top.equalTo(self)
      $0.leading.equalTo(self).offset(10.0)
    }
    titleLabel.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(self).inset(10.0)
    }
    stackView.snp.makeConstraints {
      $0.top.equalTo(self.titleLabel.snp.bottom)
      $0.leading.trailing.bottom.equalTo(self).inset(15.0)
    }
  }
}
