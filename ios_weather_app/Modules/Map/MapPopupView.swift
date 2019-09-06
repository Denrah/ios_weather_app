//
//  MapPopup.swift
//  ios_weather_app
//

import UIKit

class MapPopupView: UIView {
  @IBOutlet private weak var contentView: UIView!
  @IBOutlet private weak var showWeatherBtn: UIButton!
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
  
  func setup(viewModel: MapPopupViewModel) {
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
    
    showWeatherBtn.layer.borderWidth = 1
    showWeatherBtn.layer.borderColor = showWeatherBtn.tintColor.cgColor
    showWeatherBtn.layer.cornerRadius = 22
    addSubview(contentView)
  }
  
  @IBAction private func onCloseBtn() {
    viewModel?.onCloseButton()
  }
  
  @IBAction private func onMainBtn() {
    viewModel?.onMainButton()
  }
  
}
