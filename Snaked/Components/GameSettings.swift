//
//  GameSettings.swift
//  Snaked
//
//  Created by Marvin Lee Kobert on 11.04.22.
//

import Foundation

struct GameSettings: Codable, Equatable {
  var showNodeBorders = true
  var wallsEnabled = false
  var gameSpeedSelection: GameScene.GameSpeed = .normal
}
