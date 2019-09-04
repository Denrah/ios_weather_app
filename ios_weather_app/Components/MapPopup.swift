//
//  MapPopup.swift
//  ios_weather_app
//
//  Created by iOS Intern on 03/09/2019.
//  Copyright © 2019 iOS Intern. All rights reserved.
//

import UIKit

class MapPopup: UIView {
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var showWeatherBtn: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    var title = "" {
        didSet {
            titleLabel.text = self.title
        }
    }
    
    var subtitle = "" {
        didSet {
            subtitleLabel.text = self.subtitle
        }
    }
    
    var onCloseButton: () -> Void = {}
    var onMainButton: () -> Void = {}
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        let nib = UINib(nibName: Constants.MapPopupName, bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        
        ShadowHelper.setStandartShadow(layer: contentView.layer)
        
        showWeatherBtn.layer.borderWidth = 1
        showWeatherBtn.layer.borderColor = showWeatherBtn.tintColor.cgColor
        showWeatherBtn.layer.cornerRadius = 22
        addSubview(contentView)
    }
    
    @IBAction private func onCloseBtn() {
        onCloseButton()
    }
    
    @IBAction private func onMainBtn() {
        onMainButton()
    }
    
}
