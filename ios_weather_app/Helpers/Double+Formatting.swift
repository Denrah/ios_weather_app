//
//  Double.swift
//  ios_weather_app
//

import Foundation

extension Double {
  var compassDirection: String {
    switch self {
    case 337.5...360, 0...22.5:
      return "N"
    case 22.5...67.5:
      return "NE"
    case 67.5...122.5:
      return "E"
    case 122.5...157.5:
      return "SE"
    case 157.5...202.5:
      return "S"
    case 202.5...247.5:
      return "SW"
    case 247.5...292.5:
      return "W"
    case 292.5...337.5:
      return "NW"
    default:
      return ""
    }
  }
  
  func removeZerosFromEnd() -> String {
    let formatter = NumberFormatter()
    let number = NSNumber(value: self)
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 16
    var formattedString = String(formatter.string(from: number) ?? "")
    if formattedString[formattedString.startIndex] == "." {
      formattedString = "0" + formattedString
    }
    return formattedString
  }
}
