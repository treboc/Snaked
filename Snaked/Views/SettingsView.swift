//
//  SettingsView.swift
//  Snaked
//
//  Created by Marvin Lee Kobert on 09.04.22.
//

import SwiftUI

struct SettingsView: View {
  @ObservedObject var gameScene: GameScene
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    NavigationView {
      List {
        Section {
          Toggle("Show borders around food and snake", isOn: $gameScene.options.withBorders)
        } header: {
          Text("Game Settings")
        } footer: {
          Text("Caution: This will toggle a restart!")
        }
        .onChange(of: gameScene.options.withBorders) { _ in
          gameScene.restartGame()
        }

        Section {
          Picker("Speed", selection: $gameScene.options.gameSpeedSelection) {
            ForEach(GameScene.GameSpeed.allCases, id: \.hashValue) { speed in
              Text("\(speed.description)")
                .tag(speed)
            }
          }
        }

        Section {
          Button("Restart", role: .destructive) {
            gameScene.restartGame()
            dismiss()
          }
        }
      }
      .onChange(of: gameScene.options, perform: { _ in
        gameScene.saveSettings()
      })
      .navigationTitle("Settings")
    }
    .tint(Color(uiColor: ColorManager.colorTheme.tintColor))
  }
}
