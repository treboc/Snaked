//
//  SnakedApp.swift
//  Snaked
//
//  Created by Marvin Lee Kobert on 08.04.22.
//

import SwiftUI

@main
struct SnakedApp: App {
  @StateObject var scene: GameScene = GameScene()

  var body: some Scene {
    WindowGroup {
      GameView(scene: scene)
        .onAppear {
          UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        }
        .preferredColorScheme(.dark)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification),
                   perform: handleResignActive)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification),
                   perform: handleBecomeActive)
    }
  }

  func handleResignActive(_ note: Notification) {
    // when app goes into background state
    if scene.state == .playing {
      scene.togglePlayPause()
    }
  }

  func handleBecomeActive(_ note: Notification) {
    // when app becomes active
  }
}
