//
//  ColorManager.swift
//  Snaked
//
//  Created by Marvin Lee Kobert on 10.04.22.
//

import Foundation
import SwiftUI

struct ColorManager {
  static let colorTheme = Dracula()

  struct BaseTheme {
    let backgroundColor: Color = Color(uiColor: .tertiarySystemBackground)
    let snakeColor: UIColor = .label
    let snakeBorderColor: UIColor = .black
    let foodColor: UIColor = .red
    let foodBorderColor: UIColor = .black
  }

  struct Dracula {
    let backgroundColor: UIColor = UIColor.init(red: 40/255, green: 42/255, blue: 54/255, alpha: 1)
    let secondBackgroundColor: UIColor = UIColor.init(red: 68/255, green: 71/255, blue: 90/255, alpha: 1) // 68 71 90  
    let snakeColor: UIColor = UIColor.init(red: 80/255, green: 250/255, blue: 123/255, alpha: 1)
    let snakeBorderColor: UIColor = .black
    let foodBorderColor: UIColor = .black

    let tintColor: UIColor = UIColor.init(red: 189/255, green: 147/255, blue: 249/255, alpha: 1) // purple

    let gradientColors = [
      Color(uiColor: UIColor.init(red: 189/255, green: 147/255, blue: 249/255, alpha: 1)), // purple
      Color(uiColor: UIColor.init(red: 241/255, green: 250/255, blue: 140/255, alpha: 1)), // yellow 241 250 140
    ]

    let foodColors: [UIColor] = [
      UIColor.init(red: 255/255, green: 85/255, blue: 85/255, alpha: 1), // red
      UIColor.init(red: 255/255, green: 121/255, blue: 198/255, alpha: 1), // pink
      UIColor.init(red: 189/255, green: 147/255, blue: 249/255, alpha: 1), // purple
      UIColor.init(red: 241/255, green: 250/255, blue: 140/255, alpha: 1), // yellow 241 250 140
    ]
  }
}
