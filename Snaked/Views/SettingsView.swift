//
//  SettingsView.swift
//  Snaked
//
//  Created by Marvin Lee Kobert on 09.04.22.
//

import SwiftUI

struct SettingsView: View {
  @ObservedObject var gameScene: GameScene
  @State private var showResetHighscoreAlert = false
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    NavigationView {
      List {
        Section {
          Toggle("Show borders around snake / food", isOn: $gameScene.gameSettings.showNodeBorders)
          Toggle("Enable walls", isOn: $gameScene.gameSettings.wallsEnabled)
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
          Button("Reset Highscore", role: .destructive) {
            showResetHighscoreAlert.toggle()
          }
        }
      }
      .alert("Are you sure?", isPresented: $showResetHighscoreAlert) {
        Button("Cancel", role: .cancel) {}
        Button("Yes", role: .destructive) {
          gameScene.resetHighscore()
        }
      } message: {
        Text("This deletes your highscore!")
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
    .tint(Color(uiColor: UIColor.Dracula.tintColor))
  }
}
