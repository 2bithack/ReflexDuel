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
//    var player1Timer: CFTimeInterval = 0
//    var player2Timer: CFTimeInterval = 0
//    let superDelta: CFTimeInterval = 1.000/1200.0
//    let fixedDelta: CFTimeInterval = 1.000/60.000 //60 fps
    
    var tapGesture:UITapGestureRecognizer!
    
    let background = SKSpriteNode(imageNamed: "background")
    var player1 = SKSpriteNode(imageNamed: "player1a")
    var player2 = SKSpriteNode(imageNamed: "player2a")
    let fightRing = SKSpriteNode(imageNamed: "fightRing")

    let readyButton1 = ButtonNode(activeImageNamed: "readyButton1", selectedImageNamed: "readyButton1", hiddenImageNamed: "readyButton1", litImageNamed: "readyButton1")
    let readyButton2 = ButtonNode(activeImageNamed: "readyButton2", selectedImageNamed: "readyButton2", hiddenImageNamed: "readyButton2", litImageNamed: "readyButton2")
    
    var readyButton1Pressed: Bool = false
    var readyButton2Pressed: Bool = false
    var player1Tapped: Bool = false
    var player2Tapped: Bool = false
    var fightStart: Bool = false
    var player1HasTime: Bool = false
    var player2HasTime: Bool = false

    var time: Double = 0.0
    var startTime: Double = 0.0
    weak var timer: Timer?
    var player1Time: Double = 0.0
    var player2Time: Double = 0.0
    var tappedTime: Double = 0.0
    var totalWait: Double = 0.0
    
    var player1TimeLabelNode = SKLabelNode()
    var player2TimeLabelNode = SKLabelNode()
    var timeLabel: String!
    
    let prepareLabel = SKSpriteNode(imageNamed: "prepareLabel")
    let toLabel = SKSpriteNode(imageNamed: "toLabel")
    let fightLabel = SKSpriteNode(imageNamed: "fightLabel")
    let youWinLabel = SKSpriteNode(imageNamed: "youWinLabel")
    let youLoseLabel = SKSpriteNode(imageNamed: "youLoseLabel")
    
    let wait = SKAction.wait(forDuration: 0.2)
    
    var player1TapCount: Int = 0
    var player2TapCount: Int = 0
    
    let player1TapArea = TapButtonNode(activeImageNamed: "playerTapArea",
                                       tappedImageNamed: "playerTapArea",
                                       hiddenImageNamed: "playerTapArea",
                                       litImageNamed: "playerTapArea")
    let player2TapArea = TapButtonNode(activeImageNamed: "playerTapArea",
                                       tappedImageNamed: "playerTapArea",
                                       hiddenImageNamed: "playerTapArea",
                                       litImageNamed: "playerTapArea")
    
    override func didMove(to view: SKView) {
        
        startTime = Date().timeIntervalSinceReferenceDate
        timer = Timer.scheduledTimer(timeInterval: 0.001,
                                     target: self,
                                     selector: #selector(calcTime(timer:)),
                                     userInfo: nil,
                                     repeats: true)
        
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
        background.zPosition = -4
        self.addChild(background)
        
        fightRing.setScale(2)
        fightRing.position = CGPoint(x: 0, y: 0)
        fightRing.zPosition = 1
        self.addChild(fightRing)
        
        readyButton1.setScale(2)
        readyButton1.position = CGPoint(x: 0, y: (self.size.height * -0.40) )
        readyButton1.zPosition = 1
        self.addChild(readyButton1)
        
        readyButton2.setScale(2)
        readyButton2.position = CGPoint(x: 0, y: (self.size.height * 0.40))
        readyButton2.zPosition = 1
        self.addChild(readyButton2)
        
        
        player1TapArea.setScale(2)
        player1TapArea.position = CGPoint(x: 0, y: self.size.height * -0.3)
        player1TapArea.zPosition = 3
        self.addChild(player1TapArea)
        
        player2TapArea.setScale(2)
        player2TapArea.position = CGPoint(x: 0, y: self.size.height * 0.3)
        player2TapArea.zPosition = 3
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
        
        player1TapArea.selectedHandler = {
            self.player1TapCount += 1
            print("Player 1 tapped")
            self.player1Tapped = true
            if self.gameState == .Strike {
                if self.fightStart == true {
                    self.player1Time = (self.tappedTime - self.totalWait - 1)
                    self.player1Strike()
                    
                    self.player1TimeLabelNode.fontName = "Roman"
                    self.player1TimeLabelNode.fontSize = 20
                    self.player1TimeLabelNode.position = CGPoint(x: 0, y: self.size.height * 0.2)
                    self.player1TimeLabelNode.zPosition = 2
                    self.player1TimeLabelNode.isHidden = true
                    self.addChild(self.player1TimeLabelNode)
                    self.player1TimeLabelNode.text = "Player1: \(String(self.player1Time))"
                    
                    self.fightLabel.removeFromParent()
                    self.player1HasTime = true
                } else {
                    //player1 false start
                    self.player1Time = 10
                    print("player1 false start")
                }
            }
            if self.player1HasTime == true && self.player2HasTime == true || self.player1Time >= 10 {
                self.round1Winner()
            }
            print("Player 1 time:", self.player1Time)
        }
        
        player2TapArea.selectedHandler = {
            self.player2TapCount += 1
            print("Player 2 tapped")
            self.player2Tapped = true
            if self.gameState == .Strike {
                if self.fightStart == true {
                    self.player2Time = (self.tappedTime - self.totalWait - 1)
                    self.player2Strike()
                    
                    self.player2TimeLabelNode.fontName = "Roman"
                    self.player2TimeLabelNode.fontSize = 20
                    self.player2TimeLabelNode.position = CGPoint(x: 0, y: self.size.height * -0.2)
                    self.player2TimeLabelNode.zPosition = 2
                    self.player2TimeLabelNode.isHidden = true
                    self.addChild(self.player2TimeLabelNode)
                    self.player2TimeLabelNode.text = "Player2: \(String(self.player2Time))"
                    
                    self.fightLabel.removeFromParent()
                    self.player2HasTime = true
                } else {
                    //player2 false start
                    self.player2Time = 10
                    self.player2TimeLabelNode.text = String(self.player2Time)
                    
                    print("player2 false start")
                }
            }
            if self.player1HasTime == true && self.player2HasTime == true || self.player2Time >= 10 {
                self.round1Winner()
            }
            print("Player 2 time:", self.player2Time)
        }
    }
    
    func calcTime(timer: Timer){
        time = Date().timeIntervalSinceReferenceDate - startTime
        //timeLabel = String(format: "%.3f", time)
        
        tappedTime = time
    }
    
    func randomTime(range: Int) -> CGFloat {
        let rInt = Int(arc4random() % UInt32(range * 1000))
        return CGFloat(rInt) / 1000
    }
    
    func player1Strike(){
        let s1 = SKTexture(imageNamed: "player1b")
        let s2 = SKTexture(imageNamed: "player1c")
        let s3 = SKTexture(imageNamed: "player1d")
        let s4 = SKTexture(imageNamed: "player1e")
        
        let textures = [s1, s2, s3, s4]
        
        let strikeAnimation = SKAction.animate(with: textures, timePerFrame: 0.05, resize: true, restore: false)
        self.player1.run(strikeAnimation)
    }
    
    func player2Strike(){
        let s1 = SKTexture(imageNamed: "player2b")
        let s2 = SKTexture(imageNamed: "player2c")
        let s3 = SKTexture(imageNamed: "player2d")
        let s4 = SKTexture(imageNamed: "player2e")
        
        let textures = [s1, s2, s3, s4]
        
        let strikeAnimation = SKAction.animate(with: textures, timePerFrame: 0.05, resize: true, restore: false)
        self.player2.run(strikeAnimation)
    }
    
    func player1Wins(){
        let t1 = SKTexture(imageNamed: "player2f")
        let t2 = SKTexture(imageNamed: "player2g")
        let t3 = SKTexture(imageNamed: "player2h")
        
        let textures = [t1, t2, t3]
        
        let bleedAnimation = SKAction.animate(with: textures, timePerFrame: 0.4, resize: true, restore: false)
        self.player2.run(bleedAnimation)
    }
    
    func player2Wins(){
        
        let t1 = SKTexture(imageNamed: "player1f")
        let t2 = SKTexture(imageNamed: "player1g")
        let t3 = SKTexture(imageNamed: "player1h")
        
        let textures = [t1, t2, t3]
        
        let bleedAnimation = SKAction.animate(with: textures, timePerFrame: 0.4, resize: true, restore: false)
        self.player1.run(bleedAnimation)

    }
    
    func fightCountdown() {
        
        print("Both Players Ready")
        //initialFightTimer = 0
        
        let waitTime1 = randomTime(range: 1) + 1
        let waitTime2 = randomTime(range: 2) + 1
        let waitTime3 = randomTime(range: 6)
        
        let wait1 = SKAction.wait(forDuration: TimeInterval(waitTime1))
        let wait2 = SKAction.wait(forDuration: TimeInterval(waitTime2))
        let wait3 = SKAction.wait(forDuration: TimeInterval(waitTime3))
        
        totalWait = Double(waitTime1 + waitTime2 + waitTime3)
        
        let prep = SKAction.run {
            print("Prepare")
            self.prepareLabel.setScale(2)
            self.prepareLabel.position = CGPoint(x: 0, y: 0)
            self.addChild(self.prepareLabel)
            self.gameState = .Strike
            self.player1TapArea.state = .Active
            self.player2TapArea.state = .Active
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

            print("Timers Enabled")
        }
        let countdown = SKAction.sequence([wait1, prep, wait2, to, wait3, fight])
        run(countdown)
        print("Countdown Start")
    }
    
    func round1Winner(){
        
        if self.player1Time < self.player2Time && self.player1Time != 0 {
            //player1WinsLabel and animations
            print("Player 1 Wins!")
            youWinLabel.setScale(2)
            youWinLabel.position = CGPoint(x: 0, y: (self.size.height * -0.35))
            youWinLabel.zPosition = 1
            youLoseLabel.setScale(2)
            youLoseLabel.position = CGPoint(x: 0, y: (self.size.height * 0.35))
            youLoseLabel.zPosition = 1
            player1Wins()

            self.addChild(youWinLabel)
            self.addChild(youLoseLabel)
        } else if self.player2Time < self.player1Time && self.player2Time != 0 {
            //player2WinsLabel and animations
            print("Player 2 Wins!")
            youWinLabel.setScale(-2)
            youWinLabel.position = CGPoint(x: 0, y: (self.size.height * 0.35))
            youWinLabel.zPosition = 1
            youLoseLabel.setScale(-2)
            youLoseLabel.position = CGPoint(x: 0, y: (self.size.height * -0.35))
            youLoseLabel.zPosition = 1
            player2Wins()

            self.addChild(youWinLabel)
            self.addChild(youLoseLabel)
        } else if self.player1Time == self.player2Time{
            print("Draw")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func update(_ currentTime: TimeInterval) {

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
    }
}
