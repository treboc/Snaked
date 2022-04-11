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
          Toggle("Show borders around snake / food.", isOn: $gameScene.gameSettings.showNodeBorders)
          Toggle("Enable walls.", isOn: $gameScene.gameSettings.wallsEnabled)
          Picker("Speed", selection: $gameScene.gameSettings.gameSpeedSelection) {
            ForEach(GameScene.GameSpeed.allCases, id: \.hashValue) { speed in
              Text("\(speed.description)")
                .tag(speed)
            }
          }
        } header: {
          Text("Game Settings")
        } footer: {
          Text("Caution: This will toggle a restart!")
        }

        Section {
          Button("Restart", role: .destructive) {
            gameScene.restartGame()
            dismiss()
          }
        }
      }
      .onChange(of: gameScene.gameSettings) { _ in
        gameScene.restartGame()
      }
      .onChange(of: gameScene.gameSettings) { _ in
        gameScene.saveSettings()
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button("Cancel") { dismiss() }
        }
      }
      .navigationTitle("Settings")
    }
    .tint(Color(uiColor: ColorManager.colorTheme.tintColor))
  }
}
