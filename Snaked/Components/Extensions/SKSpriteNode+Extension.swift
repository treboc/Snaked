//
//  SKSpriteNode+Extension.swift
//  Snaked
//
//  Created by Marvin Lee Kobert on 10.04.22.
//

import SpriteKit

extension SKSpriteNode {
  func drawBorder(color: UIColor, width: CGFloat) {
    let shapeNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
    shapeNode.fillColor = .clear
    shapeNode.strokeColor = color
    shapeNode.lineWidth = width
    addChild(shapeNode)
  }
}

