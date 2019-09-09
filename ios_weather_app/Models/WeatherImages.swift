//
//  WeatherImages.swift
//  ios_weather_app
//

import UIKit

struct WeatherImages {
  var ranges: [CountableClosedRange<Int>]
  var images: [UIImage]
  
  init() {
    ranges = []
    images = []
  }
  
  mutating func append(range: CountableClosedRange<Int>, image: UIImage) {
    self.ranges.append(range)
    self.images.append(image)
  }
  
  subscript(value: Int) -> UIImage? {
    for (index, range) in self.ranges.enumerated() where range ~= value {
        return images[index]
    }
    
    return nil
  }
}
