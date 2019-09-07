//
//  ShadowHelper.swift
//  ios_weather_app
//

import UIKit

extension CALayer {
  func setStandartShadow() {
    self.shadowColor = UIColor.black.cgColor
    self.shadowOffset = CGSize(width: 0.0, height: 0.0)
    self.shadowRadius = 16.0
    self.shadowOpacity = 0.31
    self.masksToBounds = false
  }
}
