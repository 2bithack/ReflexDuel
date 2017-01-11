//
//  GameScene.swift
//  ReflexDuel
//
//  Created by enzo bot on 1/2/17.
//  Copyright © 2017 madJOKERstudios. All rights reserved.
//
import Foundation
import SpriteKit
import GameplayKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var initialFightTimer: CFTimeInterval = 0
    var beginFightTimer: CFTimeInterval = 0
    var player1Timer: CFTimeInterval = 0
    var player2Timer: CFTimeInterval = 0
    let fixedDelta: CFTimeInterval = 1.000/60.000 //60 fps
    
    let background = SKSpriteNode(imageNamed: "background")
    var player1 = SKSpriteNode(imageNamed: "player1")
    var player2 = SKSpriteNode(imageNamed: "player2")
    let fightRing = SKSpriteNode(imageNamed: "fightRing")
    //how do i set msbuttonnode to image asset? it's an skspritenode
    var readyButton1 = MSButtonNode(imageNamed: "readyButton1")
    var readyButton2 = MSButtonNode(imageNamed: "readyButton2")
    
    var readyButton1Pressed: Bool = false
    var readyButton2Pressed: Bool = false
    var player1Tapped: Bool = false
    var player2Tapped: Bool = false
    
    var player1Time: Double = 0.0
    var player2Time: Double = 0.0
    
    var prepareLabel: SKLabelNode!
    var toLabel: SKLabelNode!
    var fightLabel: SKLabelNode!
    
    var player1TapCount: Int!
    var player2TapCount: Int!
    
    let player1TapArea = SKSpriteNode(imageNamed: "playerTapArea")
    let player2TapArea = SKSpriteNode(imageNamed: "playerTapArea")
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        player1.setScale(1)
        player1.position = (CGPoint(x: self.size.width/2, y: ((self.size.height/2)-(self.size.height/5))))
        player1.zPosition = 0
        self.addChild(player1)
        player2.setScale(1)
        player2.position = (CGPoint(x: self.size.width/2, y: ((self.size.height/2)+(self.size.height/5))))
        player2.zPosition = 0
        self.addChild(player2)
        
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: size.self.height/2)
        background.zPosition = -2
        self.addChild(background)
        
        fightRing.setScale(1)
        fightRing.position = CGPoint(x: self.size.width/2, y: size.self.height/2)
        fightRing.zPosition = -2
        self.addChild(fightRing)
        
        readyButton1.setScale(1)
        readyButton1.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.05)
        readyButton1.zPosition = 1
        self.addChild(readyButton1)
        
        readyButton2.setScale(1)
        readyButton2.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.95)
        readyButton2.zPosition = 1
        self.addChild(readyButton2)
        
        player1TapArea.setScale(4)
        player1TapArea.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.25)
        player1TapArea.zPosition = -3
        self.addChild(player1TapArea)
        
        player2TapArea.setScale(4)
        player2TapArea.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.75)
        player2TapArea.zPosition = -3
        self.addChild(player2TapArea)
        
        readyButton1.selectedHandler = {
            
            self.readyButton1Pressed = true
            self.readyButton1.isHidden = true
            
        }
        readyButton2.selectedHandler = {
            
            self.readyButton2Pressed = true
            self.readyButton2.isHidden = true
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if readyButton1Pressed && readyButton2Pressed == true {
            initialFightTimer = 0
            if initialFightTimer == 0 {
                prepareLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
                self.addChild(prepareLabel)
            }
            if initialFightTimer == 1 {
                prepareLabel.removeFromParent()
                toLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
                self.addChild(toLabel)
                beginFightTimer = Double(arc4random_uniform(5) + 1)
            }
            if beginFightTimer > 0 {
                toLabel.removeFromParent()
                beginFightTimer -= fixedDelta
                if beginFightTimer < 0 {
                    fightLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
                    self.addChild(fightLabel)
                    player1Timer = 0
                    player2Timer = 0
                }
                
            }
        }
    }
    
    func tap(sender:UITapGestureRecognizer){
        
        var tapLocation: CGPoint = sender.location(in: sender.view)
        tapLocation = self.convertPoint(fromView: tapLocation)
        
        if beginFightTimer < 0 {
            if player1TapArea.contains(tapLocation){
                player1Tapped = true
                player1Time = Double(player1Timer)
                print(player1Timer)
            }
            if player2TapArea.contains(tapLocation){
                player2Tapped = true
                player2Time = Double(player2Timer)
                print(player2Timer)
            }
        }
    
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        initialFightTimer += fixedDelta
        
        if player1Tapped == false {
            player1Timer += fixedDelta
        }
        
        if player2Tapped == false {
            player2Timer += fixedDelta
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if player1Time > 0 && player2Time > 0 {
            if player1Time > player2Time {
                //player1WinsLabel and animations
                print("Player 1 Wins!")
            } else {
                //player2WinsLabel and animations
                print("Player 2 Wins!")
            }
        }
    }
}
