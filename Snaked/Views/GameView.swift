//
//  ContentView.swift
//  Snaked
//
//  Created by Marvin Lee Kobert on 08.04.22.
//

import SwiftUI
import SpriteKit
import UIKit

struct GameView: View {
  @ObservedObject var scene: GameScene
  var colorTheme = UIColor.Dracula()

  var isAnimating: Bool {
    scene.state == .playing
  }

  let sceneFrameWidth = UIScreen.main.bounds.width * 0.9
  var sceneFrameHeight: CGFloat {
    if UIDevice.current.hasNotch {
      return sceneFrameWidth * 1.667
    } else {
      return sceneFrameWidth * 1.33
    }
  }

  var body: some View {
    ZStack(alignment: .center) {
      Color(uiColor: colorTheme.secondBackgroundColor)
        .ignoresSafeArea()

      VStack {
        HStack(spacing: 5) {
          Spacer()
          menuButton
          pauseButton
        }
        title
        scoreHeader
        spriteKitScene
          .overlay((scene.state == .notStarted) ?
                   OverlayLabel(title: "Welcome!",
                                message: "1. Tap anywhere to start\n2. Control the snake with swiping\n(left, up, down, right)",
                                shouldAnimate: false)
                   : nil)
          .overlay((scene.state == .paused) ?
                   OverlayLabel(title: "Paused",
                                message: "Tap anywhere to resume",
                                shouldAnimate: true)
                   : nil)
      }
      .padding(.vertical)
      .padding(.horizontal)

      if scene.state == .gameOver {
        gameOverOverlay
          .navigationBarHidden(true)
      }
    }
    .sheet(isPresented: $scene.settingsAreShown) {
      SettingsView(gameScene: scene)
    }
  }
}

extension GameView {
  private var title: some View {
    HStack {
      Text("Snaked")
        .font(.largeTitle.bold())
        .overlay(
          LinearGradient(colors: colorTheme.gradientColors, startPoint: .leading, endPoint: .trailing)
        )
        .mask(Text("Snaked").font(.largeTitle.bold()))
      Spacer()
    }
  }

  private var scoreHeader: some View {
    HStack {
      VStack(alignment: .leading) {
        HStack {
          Text("Score:")
            .font(.headline)
            .bold()
          Spacer()
          Text("\(scene.score)")
        }
        HStack {
          Text("Highscore:")
            .font(.headline)
            .bold()
          Spacer()
          Text("\(scene.highscore)")
        }
      }
    }
    .monospacedDigit()
  }

  private var spriteKitScene: some View {
    SpriteView(scene: scene)
      .overlay(
        Rectangle()
          .stroke(Color(uiColor: colorTheme.foregroundColor), lineWidth: scene.gameSettings.wallsEnabled ? 2 : 0)
      )
      .shadow(color: (isAnimating && scene.gameSettings.wallsEnabled) ? Color(uiColor: colorTheme.foodColors[2]) : .clear, radius: 10, x: 0, y: 0)
      .animation(.easeInOut(duration: 2).repeatForever(), value: isAnimating)
  }

  private var pauseButton: some View {
    Button {
      scene.togglePlayPause()
    } label: {
      Image(systemName: scene.state == .playing ? "pause" : "play")
        .frame(width: 30, height: 20)
    }
    .buttonStyle(.borderedProminent)
    .tint(Color(uiColor: colorTheme.tintColor))
    .foregroundColor(Color(uiColor: colorTheme.backgroundColor))
    .disabled(scene.state == .notStarted || scene.state == .gameOver)
  }

  private var menuButton: some View {
    Button {
      scene.showSettings()
    } label: {
      Image(systemName: "line.3.horizontal")
        .frame(width: 30, height: 20)
    }
    .buttonStyle(.borderedProminent)
    .tint(Color(uiColor: colorTheme.tintColor))
    .foregroundColor(Color(uiColor: colorTheme.backgroundColor))
  }

  private var gameOverOverlay: some View {
    ZStack {
      Color(uiColor: colorTheme.backgroundColor)
        .ignoresSafeArea()

      VStack(spacing: 50) {
        Text("Congratulations, you scored \(scene.score)!")

        Button("Play Again") {
          scene.restartGame()
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.regular)
        .tint(Color(uiColor: colorTheme.tintColor))
      }
    }
  }

  struct OverlayLabel: View {
    private let colorTheme = UIColor.Dracula()
    let title: String
    let message: String
    let shouldAnimate: Bool
    @State var isAnimated: Bool = false

    var body: some View {
      VStack(spacing: 10) {
        Text(title)
          .font(.headline.bold())
        Text(message)
      }
      .padding()
      .background(
        RoundedRectangle(cornerRadius: 10)
          .fill(Color(uiColor: !isAnimated ? colorTheme.tintColor : colorTheme.secondBackgroundColor))
      )
      .padding()
      .onAppear {
        if shouldAnimate {
          withAnimation(.easeInOut(duration: 2).repeatForever()) {
            isAnimated.toggle()
          }
        }
      }
    }
  }
}
