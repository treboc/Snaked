//
//  GameScene.swift
//  Snaked
//
//  Created by Marvin Lee Kobert on 09.04.22.
//

import Foundation
import SpriteKit
import SwiftUI

struct Options: Codable, Equatable {
  var withBorders = false
  var gameSpeedSelection: GameScene.GameSpeed = .normal
}

class GameScene: SKScene, ObservableObject {
  // MARK: - Properties
  @Published var gameOver: Bool = false
  @Published var dir: Direction = .up
  @Published var state: gameState = .notStarted
  @Published var snake: [SKSpriteNode] = []
  @Published var food: SKSpriteNode!

  // GameOptions
  struct OptionKeys {
    static let withBordersKey = "withBordersKey"
    static let gameSpeedKey = "gameSpeedKey"
  }

  @Published var options = Options()
  @Published var showOptions: Bool = false

  let snakeLength: CGFloat = 10
  var snakeHeadSize: CGSize {
    return CGSize(width: snakeLength, height: snakeLength)
  }

  var startTouchLocation: CGPoint = .zero

  var timer: Timer? = nil
  var score: Int { snake.count - 1 }
  @Published var highscore: Int = 0

  enum gameState {
    case notStarted, playing, paused, ended
  }


  enum GameSpeed: TimeInterval, CaseIterable, Codable {
    case superSlow = 1
    case slow = 0.50
    case normal = 0.25
    case lightningFast = 0.08

    var description: String {
      switch self {
      case .superSlow:
        return "Super Slow"
      case .slow:
        return "Slow"
      case .normal:
        return "Normal"
      case .lightningFast:
        return "Lightning Fast"
      }
    }
  }

  enum Direction {
    case left, up, right, down
  }

  override func didMove(to view: SKView) {
    self.scaleMode = .fill
    if UIDevice.current.hasNotch {
      self.size = CGSize(width: 300, height: 500)
    } else {
      self.size = CGSize(width: 300, height: 400)
    }
    highscore = UserDefaults.standard.integer(forKey: "highscore")
    loadSettings()
    initialSetup()
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let position = touches.first?.location(in: self) else { return }
    changeDirection(position)
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    startTouchLocation = touch.location(in: self)
    if self.state != .playing {
      self.state = .playing
      startGame()
    }
  }

  func startGame() {
    self.timer?.invalidate()
    self.timer = Timer.scheduledTimer(withTimeInterval: options.gameSpeedSelection.rawValue, repeats: true, block: { [weak self] _ in
      guard let self = self else { return }
      if !self.gameOver {
        self.moveSnake()
      }
    })
  }

  func endGame() {
    HapticManager.shared.notification(type: .error)
    gameOver.toggle()
    self.timer?.invalidate()
  }

  func restartGame() {
    self.gameOver = false
    self.snake.removeAll()
    self.removeAllChildren()

    setupSnake()
    setupFood()

    state = .notStarted
  }

  func togglePlayPause() {
    if state == .paused {
      self.timer?.invalidate()
      self.startGame()
      state = .playing
    } else {
      self.timer?.invalidate()
      state = .paused
    }
  }

  func loadSettings() {
    let decoder = JSONDecoder()
    do {
      if let optionsData = UserDefaults.standard.data(forKey: "options") {
        options = try decoder.decode(Options.self, from: optionsData)
      }
    } catch {
      print("Error loading options from user defaults, \(error)")
    }
  }

  func saveSettings() {
    let encoder = JSONEncoder()
    do {
      let encodedOptions = try encoder.encode(options)
      UserDefaults.standard.set(encodedOptions, forKey: "options")
    } catch {
      print("Coudn't encode options.")
    }
  }


}

// MARK: - GameSetup Methods
extension GameScene {
  func initialSetup() {
    self.backgroundColor = ColorManager.colorTheme.backgroundColor
    setupSnake()
    setupFood()
  }

  func setupSnake() {
    let snakeXPosition = frame.midX + (snakeLength)
    let snakeYPosition = frame.midY + (snakeLength)

    let snakeHead = SKSpriteNode(color: ColorManager.colorTheme.snakeColor, size: snakeHeadSize)
    if options.withBorders {
      snakeHead.drawBorder(color: ColorManager.colorTheme.snakeBorderColor, width: 1)
    }
    snakeHead.position = CGPoint(x: snakeXPosition, y: snakeYPosition)
    snakeHead.anchorPoint = CGPoint(x: 0, y: 0)
    self.snake.insert(snakeHead, at: 0)
    self.addChild(snakeHead)
  }

  func setupFood() {
    self.food = SKSpriteNode(color: ColorManager.colorTheme.foodColors.randomElement()!, size: snakeHeadSize)
    if options.withBorders {
      food.drawBorder(color: ColorManager.colorTheme.foodBorderColor, width: 1)
    }
    self.food.position = randomFoodPosition(in: self.frame, with: snakeLength)
    self.food.anchorPoint = .zero
    self.food.zPosition = -1
    addChild(food)
  }
}


// MARK: - Snake Control and Movement
extension GameScene {

  // Set direction based on touch distance and movement
  func changeDirection(_ currentTouchLocation: CGPoint) {
    let xDist = abs(currentTouchLocation.x - self.startTouchLocation.x)
    let yDist = abs(currentTouchLocation.y - self.startTouchLocation.y)

    if self.startTouchLocation.y > currentTouchLocation.y && yDist > xDist && self.dir != .up {
      self.dir = Direction.down
    }
    else if self.startTouchLocation.y < currentTouchLocation.y && yDist > xDist && self.dir != .down {
      self.dir = Direction.up
    }
    else if self.startTouchLocation.x < currentTouchLocation.x && yDist < xDist && self.dir != .left {
      self.dir = Direction.right
    }
    else if self.startTouchLocation.x > currentTouchLocation.x && yDist < xDist && self.dir != .right {
      self.dir = Direction.left
    }
  }

  func moveSnake() {
    let snakePosition = self.snake[0].position
    let sceneFrame = self.frame

    // Check if the snakeHead is on any of the snake body parts -> GameOver
    let snakeBody: ArraySlice<SKSpriteNode>
    if snake.count > 2 {
      snakeBody = snake.dropFirst()
      for bodyPart in snakeBody {
        if bodyPart.position == snakePosition {
          gameOver.toggle()
          return
        }
      }
    }

    var positionInFront: CGPoint {
      var pos = snakePosition
      switch dir {
      case .left:
        pos.x -= snakeLength
        return pos
      case .up:
        pos.y += snakeLength
        return pos
      case .right:
        pos.x += snakeLength
        return pos
      case .down:
        pos.y -= snakeLength
        return pos
      }
    }

    // Check if snakeHead is on food -> let snake grow
    if positionInFront == food.position  && !gameOver {
      grow()
    }

    // save the position before movement, to pass it to the body part behind the head
    var prevPosition = snake[0].position

    // actual movement of the head
    switch dir {
    case .left:
      self.snake[0].position.x -= snakeLength
    case .up:
      self.snake[0].position.y += snakeLength
    case .right:
      self.snake[0].position.x += snakeLength
    case .down:
      self.snake[0].position.y -= snakeLength
    }

    // for every body part beside the head, set it to the correct position
    for index in 1..<snake.count {
      let currentPosition = snake[index].position
      snake[index].position = prevPosition
      prevPosition = currentPosition
    }

    // "Collision" check on the walls
    switch dir {
    case .left:
      if snakePosition.x == sceneFrame.minX && !gameOver {
        endGame()
        return
      }
    case .up:
      if snakePosition.y + snakeLength == sceneFrame.maxY && !gameOver {
        endGame()
        return
      }
    case .right:
      if snakePosition.x + snakeLength == sceneFrame.maxX && !gameOver {
        endGame()
        return
      }
    case .down:
      if snakePosition.y == sceneFrame.minY && !gameOver {
        endGame()
        return
      }
    }
  }
}

// MARK: - Generate FoodPosition && Snake Growth
extension GameScene {
  func randomFoodPosition(in rect: CGRect, with length: CGFloat) -> CGPoint {
    let rows = Int(rect.maxX / length)
    let cols = Int(rect.maxY / length)

    let randomX = Int.random(in: 1..<rows) * Int(length)
    let randomY = Int.random(in: 1..<cols) * Int(length)

    var randomPosition = CGPoint(x: randomX, y: randomY)
    for node in snake {
      if node.position == randomPosition {
        randomPosition = randomFoodPosition(in: rect, with: length)
      }
    }
    return randomPosition
  }

  func grow() {
    self.food?.position = randomFoodPosition(in: self.frame, with: snakeLength)
    self.food?.color = ColorManager.colorTheme.foodColors.randomElement()!

    let snakeBodyPart = SKSpriteNode(color: ColorManager.colorTheme.snakeColor, size: snakeHeadSize)
    snakeBodyPart.anchorPoint = .zero
    if options.withBorders { snakeBodyPart.drawBorder(color: ColorManager.colorTheme.snakeBorderColor, width: 1) }
    self.snake.append(snakeBodyPart)
    self.addChild(snakeBodyPart)

    if score > highscore {
      highscore = score
      UserDefaults.standard.set(highscore, forKey: "highscore")
    }

    HapticManager.shared.notification(type: .success)
  }
}

