//
//  ThemeManager.swift
//  Snaked
//
//  Created by Marvin Lee Kobert on 10.04.22.
//
//
import Foundation
import SwiftUI
//
//protocol Theme {
//  var themeName: String { get }
//  var backgroundColor: UIColor { get }
//  var secondBackgroundColor: UIColor { get }
//  var foregroundColor: UIColor { get }
//  var snakeColor: UIColor { get }
//  var snakeBorderColor: UIColor { get }
//  var foodBorderColor: UIColor { get }
//  var tintColor: UIColor { get }
//  var gradientColors: [Color] { get }
//  var foodColors: [UIColor] { get }
//}
//
//enum Themes {
//  static let themes: [Theme] = [ColorManager.Dracula(), ColorManager.Monokai()]
//
//  static func getTheme(_ theme: Int) -> Theme {
//    Self.themes[theme]
//  }
//}
//
//class ThemeManager: ObservableObject {
//  static let shared = ThemeManager()
//  @Published var selectedTheme: Theme = ColorManager.Dracula()
//
//  init() {
//    updateTheme()
//  }
//
//  @AppStorage("selectedTheme") var selectedThemeAS = 0 {
//    didSet {
//      updateTheme()
//    }
//  }
//
//  func updateTheme() {
//    selectedTheme = Themes.getTheme(selectedThemeAS)
//  }
//
//}
//
extension UIColor {
  struct Dracula {
    static let background = UIColor(red: 40/255, green: 42/255, blue: 54/255, alpha: 1)
    static let secondaryBackground = UIColor(red: 68/255, green: 71/255, blue: 90/255, alpha: 1)
    static let foreground = UIColor(red: 248/255, green: 248/255, blue: 242/255, alpha: 1)
    static let cyan = UIColor(red: 139/255, green: 233/255, blue: 253/255, alpha: 1)
    static let green = UIColor(red: 80/255, green: 250/255, blue: 123/255, alpha: 1)
    static let orange = UIColor(red: 255/255, green: 184/255, blue: 108/255, alpha: 1)
    static let pink = UIColor(red: 255/255, green: 121/255, blue: 198/255, alpha: 1)
    static let purple = UIColor(red: 189/255, green: 147/255, blue: 249/255, alpha: 1)
    static let red = UIColor(red: 255/255, green: 80/255, blue: 80/255, alpha: 1)
    static let yellow = UIColor(red: 241/255, green: 250/255, blue: 140/255, alpha: 1)
    static let tintColor = purple

    let themeName: String = "Dracula"
    let backgroundColor = background
    let secondBackgroundColor = secondaryBackground
    let foregroundColor = foreground
    let snakeColor = green
    let snakeBorderColor = secondaryBackground
    let foodBorderColor = secondaryBackground
    let tintColor = purple
    let gradientColors: [Color] = [Color(uiColor: purple), Color(uiColor: yellow)]
    let foodColors = [cyan, orange, pink, purple, red, yellow]
  }

  struct Monokai {
    static let background = UIColor(red: 0.15, green: 0.16, blue: 0.13, alpha: 1.00)
    static let secondaryBackground = UIColor(red: 0.24, green: 0.24, blue: 0.20, alpha: 1.00)
    static let foreground = UIColor(red: 0.81, green: 0.81, blue: 0.76, alpha: 1.00)
    static let cyan = UIColor(red: 0.63, green: 0.94, blue: 0.89, alpha: 1.00)
    static let blue = UIColor(red: 0.40, green: 0.85, blue: 0.94, alpha: 1.00)
    static let green = UIColor(red: 0.65, green: 0.89, blue: 0.18, alpha: 1.00)
    static let orange = UIColor(red: 0.99, green: 0.59, blue: 0.12, alpha: 1.00)
    static let pink = UIColor(red: 0.99, green: 0.37, blue: 0.94, alpha: 1.00)
    static let purple = UIColor(red: 0.68, green: 0.51, blue: 1.00, alpha: 1.00)
    static let red = UIColor(red: 0.98, green: 0.15, blue: 0.45, alpha: 1.00)
    static let yellow = UIColor(red: 0.90, green: 0.86, blue: 0.45, alpha: 1.00)

    let themeName: String = "Monokai"
    let backgroundColor = background
    let secondBackgroundColor = secondaryBackground
    let foregroundColor = foreground
    let snakeColor = green
    let snakeBorderColor = secondaryBackground
    let foodBorderColor = secondaryBackground
    let tintColor = orange
    let gradientColors: [Color] = [Color(uiColor: yellow), Color(uiColor: red)]
    let foodColors = [cyan, blue, orange, pink, purple, red, yellow]
  }
}
