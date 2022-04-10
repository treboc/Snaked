//
//  SnakedApp.swift
//  Snaked
//
//  Created by Marvin Lee Kobert on 08.04.22.
//

import SwiftUI

@main
struct SnakedApp: App {
  var body: some Scene {
    WindowGroup {
      GameView()
        .onAppear {
          UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        }
        .preferredColorScheme(.dark)
    }
  }
}
