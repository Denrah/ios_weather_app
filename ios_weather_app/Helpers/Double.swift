//
//  Double.swift
//  ios_weather_app
//

import Foundation

extension Double {
  var compassDirection: String {
    if self > 337.5 {return "N"}
    if self > 292.5 {return "NW"}
    if self > 247.5 {return "W"}
    if self > 202.5 {return "SW"}
    if self > 157.5 {return "S"}
    if self > 122.5 {return "SE"}
    if self > 67.5 {return "E"}
    if self > 22.5 {return "NE"}
    return "N"
  }
}
