//
//  UIDevice+Extension.swift
//  Snaked
//
//  Created by Marvin Lee Kobert on 10.04.22.
//

import Foundation
import UIKit
import DeviceKit

// Use DeviceKit to check if current device has notch, to get the layout right
extension UIDevice {
  var hasNotch: Bool {
    let device = Device.current
    let noNotchDevices: [Device] = [.iPhoneSE, .iPhoneSE2, .iPhoneSE3, .iPhone6, .iPhone6Plus, .iPhone6s, .iPhone6sPlus, .iPhone7, .iPhone7Plus, .iPhone8, .iPhone8Plus]
    return !device.isOneOf(noNotchDevices)
  }
}
