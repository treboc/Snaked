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
  @StateObject var scene: GameScene = {
    let scene = GameScene()
    if UIDevice.current.hasNotch {
      scene.size = CGSize(width: 300, height: 500)
    } else {
      scene.size = CGSize(width: 300, height: 400)
    }
    scene.scaleMode = .aspectFit
    return scene
  }()

  let tintColor: UIColor = ColorManager.colorTheme.tintColor
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
      Color(uiColor: ColorManager.colorTheme.backgroundColor)
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
      .frame(maxWidth: sceneFrameWidth)

      if scene.gameOver {
        gameOverOverlay
          .navigationBarHidden(true)
      }
    }

    .sheet(isPresented: $scene.showOptions) {
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
          LinearGradient(colors: ColorManager.colorTheme.gradientColors, startPoint: .leading, endPoint: .trailing)
        )
        .mask(Text("Snaked").font(.largeTitle.bold()))
        .padding(.bottom)
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
      .frame(width: sceneFrameWidth, height: sceneFrameHeight)
      .overlay(
        Rectangle()
          .strokeBorder(Color(uiColor: .label), lineWidth: 1)
      )
      .shadow(color: isAnimating ? Color(uiColor: ColorManager.colorTheme.tintColor) : .clear, radius: 5, x: 0, y: 0)
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
    .tint(Color(uiColor: tintColor))
    .disabled(scene.state == .notStarted || scene.state == .ended)
  }

  private var menuButton: some View {
    Button {
      scene.showOptions.toggle()
      scene.timer?.invalidate()
      scene.state = .paused
    } label: {
      Image(systemName: "line.3.horizontal")
        .frame(width: 30, height: 20)
    }
    .buttonStyle(.borderedProminent)
    .tint(Color(uiColor: tintColor))
  }

  private var gameOverOverlay: some View {
    ZStack {
      Color(uiColor: ColorManager.colorTheme.backgroundColor)
        .ignoresSafeArea()

      VStack(spacing: 50) {
        Text("Congratulations, you scored \(scene.score)!")

        Button("Play Again") {
          scene.restartGame()
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.regular)
        .tint(Color(uiColor: tintColor))
      }
    }
  }

  struct OverlayLabel: View {
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
          .fill(Color(uiColor: ColorManager.colorTheme.tintColor))
          .overlay(RoundedRectangle(cornerRadius: 10)
            .strokeBorder(.gray))
      )
      .opacity(!isAnimated ? 1 : 0)
      .onAppear {
        if shouldAnimate {
          withAnimation(.easeInOut(duration: 1).repeatForever()) {
            isAnimated.toggle()
          }
        }
      }
    }
  }
}
