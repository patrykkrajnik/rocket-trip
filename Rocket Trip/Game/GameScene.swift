//
//  GameScene.swift
//  Rocket Trip
//
//  Created by Patryk Krajnik on 06/06/2020.
//  Copyright © 2020 Patryk Krajnik. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var background = SKSpriteNode()
    var rocket = SKSpriteNode()
    var rock = SKSpriteNode()
    var scoreLabel: SKLabelNode!
    var infoLabel: SKLabelNode!
    var bestScoreLabel: SKLabelNode!
    var motionManager = CMMotionManager()
    var destX = 0.0
    var counter = 0
    var seconds = 0
    var points = 0 {
        didSet {
            scoreLabel.text = "\(points)"
        }
    }
    var highestScoreEasy:Int = 0
    var highestScoreHard:Int = 0
    var numberOfRocket: Int = 1
    var accelerometer = false
    var startRockCreating = false
    var gameFinished = false
    
    func didBegin(_ contact: SKPhysicsContact) {
        self.gameFinished = true
        startRockCreating = false
        
        rocket.physicsBody?.affectedByGravity = false
        rocket.physicsBody?.pinned = true
        rocket.physicsBody?.isDynamic = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        infoLabel.run(SKAction.hide())
        accelerometer = true
        startRockCreating = true
        rocket.physicsBody?.affectedByGravity = true
        rocket.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        rocket.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 300))
    }
    
    override func didMove(to view: SKView) {
        numberOfRocket = UserDefaults.standard.integer(forKey: "numberOfRocket")
        self.physicsWorld.contactDelegate = self
        motionManager.startAccelerometerUpdates()
        createBackground()
        self.rocket = (self.childNode(withName: "//rocket") as? SKSpriteNode)!
        rocket.texture = SKTexture(imageNamed: "flyingRocket\(numberOfRocket)")
        self.infoLabel = (self.childNode(withName: "infoLabel") as! SKLabelNode)
        //self.rock = (self.childNode(withName: "//rock") as? SKSpriteNode)!
        rocket.physicsBody?.categoryBitMask = 1
        rocket.physicsBody?.collisionBitMask = 2
        rocket.physicsBody?.contactTestBitMask = 2
        
        scoreLabel = SKLabelNode(text: "0")
        scoreLabel.position = CGPoint(x: (((self.scene?.size.width)!)/(-4))-50, y: (((self.scene?.size.height)!)/3)+100)
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = UIColor.yellow
        self.addChild(scoreLabel)
        
        bestScoreLabel = SKLabelNode(text: "Best: ")
        bestScoreLabel.position = CGPoint(x: (((self.scene?.size.width)!)/(-4))-50, y: (((self.scene?.size.height)!)/3)+50)
        bestScoreLabel.fontName = "AmericanTypewriter-Bold"
        bestScoreLabel.fontSize = 30
        bestScoreLabel.fontColor = UIColor.yellow
        self.addChild(bestScoreLabel)
        
        if UserDefaults.standard.bool(forKey: "hard") {
            let savedScore: Int = UserDefaults.standard.integer(forKey: "highestScoreHard")
            bestScoreLabel.text = "Best: \(savedScore)"
        } else {
            let savedScore: Int = UserDefaults.standard.integer(forKey: "highestScoreEasy")
            bestScoreLabel.text = "Best: \(savedScore)"
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveBackground()
        moveX()
        rocket.run(SKAction.moveTo(x: destX, duration: 1))
        sideConstraints()
        createRock()
        setHighestScore()
        if self.gameFinished {
            rocket.run(SKAction.moveTo(x: rocket.position.x, duration: 1))
            motionManager.stopAccelerometerUpdates()
            endGame()
            return
        }
    }
    
    func moveX() {
        if accelerometer == true {
            if motionManager.isAccelerometerAvailable {
                motionManager.accelerometerUpdateInterval = 0.01
                motionManager.startAccelerometerUpdates(to: .main) {
                    (data, error) in
                    guard let data = data, error == nil else {
                        return
                    }
                    
                    let currentX = self.rocket.position.x
                    self.destX = currentX + CGFloat(data.acceleration.x * 3000)
                }
            }
        }
    }
    
    func sideConstraints() {
        let rightConstraint = size.width/2 - 70
        let leftConstraint = rightConstraint*(-1)
        let positionX = rocket.position.x
        
        if (positionX > rightConstraint) {
            rocket.run(SKAction.moveTo(x: rightConstraint, duration: 0.1))
            if destX < rightConstraint {
                rocket.run(SKAction.moveTo(x: destX, duration: 1))
            }
        }
        
        if (positionX < leftConstraint) {
            rocket.run(SKAction.moveTo(x: leftConstraint, duration: 0.1))
            if destX > leftConstraint {
                rocket.run(SKAction.moveTo(x: destX, duration: 1))
            }
        }
    }
    
    func createBackground() {
        for i in 0...3 {
            background = SKSpriteNode(imageNamed: "gameBackground")
            background.name = "stars"
            background.size = self.size
            background.position = CGPoint(x: 0, y: CGFloat(i) * background.size.height)
            background.zPosition = -2
            self.addChild(background)
        }
    }
    
    func moveBackground() {
        self.enumerateChildNodes(withName: "stars", using: ({
            (node, error) in
            
            node.position.y -= 2
            
            if node.position.y < -((self.scene?.size.height)!) {
                node.position.y += (self.scene?.size.height)! * 3
            }
        }))
    }
    
    func createRock() {
        let xAxis = Int(arc4random_uniform(640))-640/2
        let yAxis = Int(1334)
        let rockSize = [80, 90, 100, 110, 120, 130, 140, 150]
        if (startRockCreating == true) {
            if UserDefaults.standard.bool(forKey: "hard") {
                counter += 1
                if (counter%4 == 0) {
                    counter += 1
                }
            }
            counter += 1
            countPoints()
            if (counter%45 == 0) {
                let size = rockSize.randomElement()
                rock = SKSpriteNode(imageNamed: "rock")
                if (arc4random_uniform(5)<2) {
                    rock.physicsBody = SKPhysicsBody(circleOfRadius: 75)
                } else {
                    rock.scale(to: CGSize(width: size!, height: size!))
                    rock.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(size!)*0.5)
                }
                self.addChild(rock)
                rock.position = CGPoint(x: xAxis, y: yAxis)
                rock.physicsBody?.mass = 0.1
                rock.physicsBody?.linearDamping = 1.0
                rock.physicsBody?.categoryBitMask = 2
                rock.physicsBody?.collisionBitMask = 1
                rock.physicsBody?.contactTestBitMask = 1
            }
        }
    }
    
    func countPoints() {
        seconds += 1
        if (seconds%60 == 0) {
            points += 1
        }
    }
    
    func endGame() {
        let transition = SKTransition.flipHorizontal(withDuration: 1.0)
        let gameOver = SKScene(fileNamed: "GameOverScene") as! GameOverScene
        gameOver.scaleMode = .aspectFill
        gameOver.score = points
        view!.presentScene(gameOver, transition: transition)
    }
    
    func setHighestScore() {
        let userDefaults = UserDefaults.standard
        if (points > userDefaults.integer(forKey: "highestScoreHard")) && userDefaults.bool(forKey: "hard") {
            highestScoreHard = points
            userDefaults.set(highestScoreHard, forKey: "highestScoreHard")
            userDefaults.synchronize()
        }
        
        if (points > userDefaults.integer(forKey: "highestScoreEasy")) && !(userDefaults.bool(forKey: "hard")) {
            highestScoreEasy = points
            userDefaults.set(highestScoreEasy, forKey: "highestScoreEasy")
            userDefaults.synchronize()
        }
    }
}
