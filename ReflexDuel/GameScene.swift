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
    
    enum GameSceneState {
        case Ready, Strike, GameOver, StrikeTempo, AllOut
    }
    
    var gameState: GameSceneState = .Ready
    var player1Timer: CFTimeInterval = 0
    var player2Timer: CFTimeInterval = 0
    let fixedDelta: CFTimeInterval = 1.000/60.000 //60 fps
    
    var tapGesture:UITapGestureRecognizer!
    
    let background = SKSpriteNode(imageNamed: "background")
    var player1 = SKSpriteNode(imageNamed: "player1")
    var player2 = SKSpriteNode(imageNamed: "player2")
    let fightRing = SKSpriteNode(imageNamed: "fightRing")

    var readyButton1 = ButtonNode(activeImageNamed: "readyButton1", selectedImageNamed: "readyButton1", hiddenImageNamed: "readyButton1", litImageNamed: "readyButton1")
    var readyButton2 = ButtonNode(activeImageNamed: "readyButton2", selectedImageNamed: "readyButton2", hiddenImageNamed: "readyButton2", litImageNamed: "readyButton2")
    
    var readyButton1Pressed: Bool = false
    var readyButton2Pressed: Bool = false
    var player1Tapped: Bool = false
    var player2Tapped: Bool = false
    var fightStart: Bool = false
    
    var player1Time: Double = 0.0
    var player2Time: Double = 0.0
    
    var prepareLabel = SKSpriteNode(imageNamed: "prepareLabel")
    var toLabel = SKSpriteNode(imageNamed: "toLabel")
    var fightLabel = SKSpriteNode(imageNamed: "fightLabel")
    
    var player1TapCount: Int!
    var player2TapCount: Int!
    
    let player1TapArea = SKSpriteNode(imageNamed: "playerTapArea")
    let player2TapArea = SKSpriteNode(imageNamed: "playerTapArea")
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        player1.setScale(1.5)
        player1.position = (CGPoint(x: 0, y: self.size.height * -0.10))
        player1.zPosition = 0
        self.addChild(player1)
        
        player2.setScale(1.5)
        player2.position = (CGPoint(x: 0, y: self.size.height * 0.10))
        player2.zPosition = 0
        self.addChild(player2)
        
        background.size = self.size
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = -2
        self.addChild(background)
        
        fightRing.setScale(2)
        fightRing.position = CGPoint(x: 0, y: 0)
        fightRing.zPosition = 1
        self.addChild(fightRing)
        
        readyButton1.setScale(1.5)
        readyButton1.position = CGPoint(x: 0, y: (self.size.height * -0.40) )
        readyButton1.zPosition = 1
        self.addChild(readyButton1)
        
        readyButton2.setScale(1.5)
        readyButton2.position = CGPoint(x: 0, y: (self.size.height * 0.40))
        readyButton2.zPosition = 1
        self.addChild(readyButton2)
        
        
        player1TapArea.setScale(2)
        player1TapArea.position = CGPoint(x: 0, y: self.size.height * -0.3)
        player1TapArea.zPosition = -3
        self.addChild(player1TapArea)
        
        player2TapArea.setScale(2)
        player2TapArea.position = CGPoint(x: 0, y: self.size.height * 0.3)
        player2TapArea.zPosition = -3
        self.addChild(player2TapArea)
        
        readyButton1.selectedHandler = {
            
            self.readyButton1Pressed = true
            self.readyButton1.isHidden = true
            print("Ready Player 1")
            if self.readyButton1Pressed && self.readyButton2Pressed {
                self.fightCountdown()
            }
        }
        readyButton2.selectedHandler = {
            
            self.readyButton2Pressed = true
            self.readyButton2.isHidden = true
            print("Ready Player 2")
            if self.readyButton1Pressed && self.readyButton2Pressed {
                self.fightCountdown()
            }
        }
        //enable taps func
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
    }
    
    func randomTime(range: Int) -> CGFloat {
        let rInt = Int(arc4random() % UInt32(range * 1000))
        return CGFloat(rInt) / 1000
    }
    
    func fightCountdown() {
        
        print("Both Players Ready")
        //initialFightTimer = 0
        
        let wait1 = SKAction.wait(forDuration: TimeInterval(randomTime(range: 1) + 1))
        let wait2 = SKAction.wait(forDuration: TimeInterval(randomTime(range: 2) + 1))
        let wait3 = SKAction.wait(forDuration: TimeInterval(randomTime(range: 6)))
        
        let prep = SKAction.run {
            self.view?.addGestureRecognizer(self.tapGesture)
            print("Prepare")
            self.prepareLabel.setScale(2)
            self.prepareLabel.position = CGPoint(x: 0, y: 0)
            self.addChild(self.prepareLabel)
            self.gameState = .Strike
        }
        
        let to = SKAction.run {
            print("to")
            self.prepareLabel.removeFromParent()
            self.toLabel.setScale(2)

            self.addChild(self.toLabel)
        }
        
        let fight = SKAction.run {
            print("Fight")
            self.toLabel.removeFromParent()
            self.fightLabel.setScale(2.5)
            self.addChild(self.fightLabel)
            self.fightStart = true
            self.player2Timer = 0
            self.player1Timer = 0
            print("Timers Enabled")
        }
        let countdown = SKAction.sequence([wait1, prep, wait2, to, wait3, fight])
        run(countdown)
        print("Countdown Start")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    func tap(_ sender:UITapGestureRecognizer) {
        print("Screen Tapped")
        var tapLocation: CGPoint = sender.location(in: sender.view)
        tapLocation = self.convertPoint(fromView: tapLocation)
        
        if gameState == .Strike {
            if player1TapArea.contains(tapLocation) && player1Tapped == false {
                print("Player 1 tapped")
                player1Tapped = true
                if fightStart == true {
                    player1Time = player1Timer
                } else {
                    //player1 false start
                    player1Time = 10
                     print("player1 false start")
                }
                print("Player 1 time:", player1Time)
            }
            if player2TapArea.contains(tapLocation) && player2Tapped == false{
                print("Player 2 tapped")
                player2Tapped = true
                if fightStart == true {
                    player2Time = player2Timer
                } else {
                    //player2 false start
                    player2Time = 10
                    print("player2 false start")
                }
                print("Player 2 time:", player2Time)
            }
            
            self.fightLabel.removeFromParent()
            
            if player1Time >= 0 && player2Time >= 0 {
                if player1Time < player2Time && player1Time != 0 {
                    //player1WinsLabel and animations
                    print("Player 1 Wins!")
                } else if player2Time < player1Time && player2Time != 0 {
                    //player2WinsLabel and animations
                    print("Player 2 Wins!")
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered        
        if player1Tapped == false {
            player1Timer += fixedDelta
        }
        
        if player2Tapped == false {
            player2Timer += fixedDelta
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
}
