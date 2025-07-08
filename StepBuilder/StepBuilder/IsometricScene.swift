//
//  IsometricScene.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 7/7/25.
//
import SpriteKit
import Foundation
import UIKit
import SnapKit

class IsometricScene: SKScene {
    /*let numRows = 5
    let numCols = 5
    let grassTexture = SKTexture(imageNamed: "grass_tile")
    let tileSize = CGSize(width: 60, height: 30)
    
    lazy var grassTileDefinition: SKTileDefinition = {
        let tileDefinition = SKTileDefinition(texture: self.grassTexture, size: self.tileSize)
        tileDefinition.name = "grass"
        return tileDefinition
    }()
    
    lazy var grassTileGroup: SKTileGroup = {
        let tileGroup = SKTileGroup(tileDefinition: self.grassTileDefinition)
        tileGroup.name = "grassGroup"
        return tileGroup
    }()

    lazy var tileGroup: SKTileSet = {
        let tileSet = SKTileSet(tileGroups: [self.grassTileGroup])
        tileSet.type = .isometric

        return tileSet
    }()
    
    lazy var isometricTileMap: SKTileMapNode = {
        let tileMap = SKTileMapNode(tileSet: self.tileGroup, columns: self.numCols, rows: self.numRows, tileSize: self.tileSize)
        tileMap.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        tileMap.fill(with: self.grassTileGroup)
        tileMap.zPosition = -1
        tileMap.enableAutomapping = true

        return tileMap
    }()
        
    func restartScene() {
        self.removeAllChildren()
        self.removeAllActions()
    }
    
    func createScene() {
        self.restartScene()
        self.backgroundColor = .blue
        addChild(self.isometricTileMap)
    }
    override func didMove(to view: SKView) {
        self.createScene()
    }*/
    
    var rotation = Rotation.defaultRotation
    let rootNode = SKNode()
    let fxRootNode = SKNode()
        
    func restartScene() {
        self.removeAllChildren()
        self.removeAllActions()
    }
    
    override func didMove(to view: SKView) {
        self.restartScene()
        self.backgroundColor = .blue
        size = view.frame.size
        scaleMode = .aspectFill
        
        rootNode.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        addChild(rootNode)
        //addChild(fxRootNode)
        
        redraw()
    }
    
    func redraw() {
        // cleanup old nodes
        for node in rootNode.children {
            node.removeFromParent()
        }
              
        let map = Map(heightMap: [
            [1,1,1,1,1],
            [1,1,1,1,1],
            [1,1,1,1,1],
            [1,1,1,1,1],
            [1,1,1,1,1],
        ])
                
        for y in 0 ..< map.rowCount {
            for x in 0 ..< map.colCount {
                let elevation = map[Vector2D(x: x, y: y)]
                for z in 0 ... elevation {
                    let sprite = SKSpriteNode(imageNamed: "grass_tile")
                    sprite.texture?.filteringMode = .nearest
                    let position = Vector3D(x: x, y: y, z: z)
                    print(position)
                    let color = SKColor.white
                    let screenPosition = convertWorldToScreen(position, direction: rotation)
                    sprite.position = CGPoint(x: screenPosition.x, y: screenPosition.y)
                    sprite.zPosition = CGFloat(convertWorldToZPosition(position, direction: rotation))
                    
                    sprite.colorBlendFactor = 1.0
                    sprite.color = color
                    
                    sprite.userData = ["coord": position] // associate the tile sprite with its coordinate
                    rootNode.addChild(sprite)
                }
            }
        }
    }
}
