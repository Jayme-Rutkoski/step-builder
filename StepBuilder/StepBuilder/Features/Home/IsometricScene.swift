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
    var isLoaded = false
    
    func restartScene() {
        self.removeAllChildren()
        self.removeAllActions()
    }
    
    override func didMove(to view: SKView) {
        self.restartScene()
        self.backgroundColor = .white
        size = view.frame.size
        scaleMode = .aspectFill
        
        rootNode.position = CGPoint(x: self.frame.width / 2, y: (self.frame.height / 2) - ((self.frame.height / 2) / 2))
        addChild(rootNode)
    }
    
    public func load(date: Date, completion: ((Bool) -> ())? = nil) {
        redraw(date: date, completion: completion)
    }
    
    func redraw(date: Date, completion: ((Bool) -> ())?) {
        print("REDRAW")
        
        let changeContent = SKAction.run {
            if (!self.isLoaded) {
                self.rootNode.removeAllChildren()
            }
            
            for node in self.rootNode.children {
                if (node.name != "soil") {
                    let growDown = SKAction.scaleY(to: 0.0, duration: 0.5)
                    let remove = SKAction.removeFromParent()
                    let growDownAndRemove = SKAction.sequence([growDown, remove])
                    node.run(growDownAndRemove)
                }
            }
            
            Task.init {
                var hasData = true
                
                var mapData = await Factory.shared().stepProgressManager.getGridForDate(date)
                if (mapData == nil && Date().isSameDay(as: date)) {
                    mapData = Factory.shared().stepProgressManager.getCurrentGrid()
                } else if (mapData == nil) {
                    hasData = false
                    mapData = Factory.shared().stepProgressManager.createGrid(rows: 5, cols: 5, initialValue: 1)
                }
                DispatchQueue.main.async {
                    let map = Map(heightMap: mapData!)
                    
                    for y in 0 ..< map.rowCount {
                        for x in 0 ..< map.colCount {
                            let elevation = map[Vector2D(x: x, y: y)]
                            print("ELEVATION: \(elevation)")
                            for z in 0 ... 1 {
                                let spriteSize = CGSize(width: 60, height: 60)
                                var sprite = SKSpriteNode(imageNamed: "soil_tile")
                                sprite.name = "soil"
                                
                                if (z == 0 && self.isLoaded) {
                                    continue
                                }
                                
                                if (z == 1) {
                                    if (elevation == 1) {
                                        continue
                                    } else if (elevation == 2) {
                                        sprite = SKSpriteNode(imageNamed: "seedling_tile")
                                        sprite.name = "seedling"
                                        sprite.yScale = 0.0
                                        sprite.xScale = 1.0
                                    } else if (elevation == 3) {
                                        sprite = SKSpriteNode(imageNamed: "tree_tile")
                                        sprite.name = "tree"
                                        sprite.yScale = 0.0
                                        sprite.xScale = 1.0
                                    }
                                }
                                sprite.texture?.filteringMode = .nearest
                                let position = Vector3D(x: x, y: y, z: z)
                                
                                print(position)
                                
                                let color = SKColor.white
                                let screenPosition = convertWorldToScreen(position, spriteSize: spriteSize, direction: self.rotation)
                                sprite.position = CGPoint(x: screenPosition.x, y: screenPosition.y)
                                sprite.size = spriteSize
                                sprite.zPosition = CGFloat(convertWorldToZPosition(position, spriteSize: spriteSize, direction: self.rotation))
                                
                                sprite.colorBlendFactor = 1.0
                                sprite.color = color
                                
                                sprite.userData = ["coord": position] // associate the tile sprite with its coordinate
                                self.rootNode.addChild(sprite)
                                
                                if (sprite.name == "seedling" || sprite.name == "tree") {
                                    let growAction = SKAction.scaleY(to: 1.0, duration: 0.5)
                                    sprite.run(growAction)
                                }
                            }
                        }
                    }
                    self.isLoaded = true
                    completion?(hasData)
                }
            }
        }
        let sequence = SKAction.sequence([changeContent])
        self.rootNode.run(sequence)
    }
}
