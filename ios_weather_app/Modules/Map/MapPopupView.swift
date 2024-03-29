//
//  MapPopup.swift
//  ios_weather_app
//

import UIKit

class MapPopupView: UIView {
  @IBOutlet private weak var contentView: UIView!
  @IBOutlet private weak var showWeatherButton: UIButton!
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var subtitleLabel: UILabel!
  
  var viewModel: MapPopupViewModel?
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  // MARK: - Popup configuration
  
  func setup(with viewModel: MapPopupViewModel) {
    self.viewModel = viewModel
    bindToViewModel()
  }
  
  func bindToViewModel() {
    viewModel?.title.bind = {
      self.titleLabel.text = $0
    }
    
    viewModel?.subtitle.bind = {
      self.subtitleLabel.text = $0
    }
  }
  
  private func setupView() {
    let nib = UINib(nibName: "MapPopupView", bundle: nil)
    nib.instantiate(withOwner: self, options: nil)
    contentView.frame = bounds
    contentView.layer.setStandartShadow()
    
    showWeatherButton.layer.borderWidth = 1
    showWeatherButton.layer.borderColor = showWeatherButton.tintColor.cgColor
    showWeatherButton.layer.cornerRadius = 22
    addSubview(contentView)
  }
  
  // MARK: - Popup events
  
  @IBAction private func onCloseButton() {
    viewModel?.onCloseButton()
  }
  
  @IBAction private func onShowWeatherButton() {
    viewModel?.onShowWeatherButton()
  }
  
}
