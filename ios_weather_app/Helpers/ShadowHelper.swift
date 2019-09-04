//
//  ShadowHelper.swift
//  ios_weather_app
//
//  Created by iOS Intern on 04/09/2019.
//  Copyright © 2019 iOS Intern. All rights reserved.
//

import UIKit

class ShadowHelper {
    
    static func setStandartShadow(layer: CALayer) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius = 16.0
        layer.shadowOpacity = 0.31
        layer.masksToBounds = false
    }
}
