//
//  MapPopup.swift
//  ios_weather_app
//
//  Created by iOS Intern on 03/09/2019.
//  Copyright © 2019 iOS Intern. All rights reserved.
//

import UIKit

class MapPopup: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var showWeatherBtn: UIButton!
    @IBOutlet weak var cityLabel: UILabel!
    
    var city = "" {
        didSet {
            cityLabel.text = self.city
        }
    }
    
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
        
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        contentView.layer.shadowRadius = 16.0
        contentView.layer.shadowOpacity = 0.31
        contentView.layer.masksToBounds = false
        
        showWeatherBtn.layer.borderWidth = 1
        showWeatherBtn.layer.borderColor = showWeatherBtn.tintColor.cgColor
        showWeatherBtn.layer.cornerRadius = 22
        addSubview(contentView)
    }

}
