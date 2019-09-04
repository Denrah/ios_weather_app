//
//  Constants.swift
//  ios_weather_app
//
//  Created by iOS Intern on 03/09/2019.
//  Copyright © 2019 iOS Intern. All rights reserved.
//

import UIKit
import MapKit

enum Constants {
    static let MapScreenName = String(describing: MapViewController.self)
    static let MapPopupName = String(describing: MapPopup.self)
    static let MapPopupBottomOpenMargin: CGFloat = 16
    static let MapPopupBottomCloseMargin: CGFloat = -200
    static let MapInitialCoordinate = CLLocationCoordinate2D(latitude: 41.82665680566723, longitude: -87.59588323647132)
}
