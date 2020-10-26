//
//  MenuScene.swift
//  Rocket Trip
//
//  Created by Patryk Krajnik on 08/06/2020.
//  Copyright © 2020 Patryk Krajnik. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    var newGameButtonNode: SKSpriteNode!
    var difficultyButtonNode: SKSpriteNode!
    var difficultyLabelNode: SKLabelNode!
    var arrowLeftButton: SKSpriteNode!
    var arrowRightButton: SKSpriteNode!
    var chooseRocket: SKSpriteNode!
    
    var numberOfRocket: Int = 1
    
    override func didMove(to view: SKView) {
        newGameButtonNode = (self.childNode(withName: "newGameButton") as! SKSpriteNode)
        difficultyButtonNode = (self.childNode(withName: "difficultyButton") as! SKSpriteNode)
        
        arrowLeftButton = (self.childNode(withName: "arrowLeftButton") as! SKSpriteNode)
        arrowLeftButton.run(SKAction.hide())
        arrowRightButton = (self.childNode(withName: "arrowRightButton") as! SKSpriteNode)
        chooseRocket = (self.childNode(withName: "chooseRocket") as! SKSpriteNode)
        
        difficultyLabelNode = (self.childNode(withName: "difficultyLabel") as! SKLabelNode)
        
        let userDefaults = UserDefaults.standard
        
        if userDefaults.bool(forKey: "hard") {
            difficultyLabelNode.text = "Hard"
        } else {
            difficultyLabelNode.text = "Easy"
        }
        
        changeRocket()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location  = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "newGameButton" {
                let transition = SKTransition.flipHorizontal(withDuration: 1.0)
                let gameScene = SKScene(fileNamed: "GameScene") as! GameScene
                gameScene.scaleMode = .aspectFill
                gameScene.numberOfRocket = self.numberOfRocket
                view!.presentScene(gameScene, transition: transition)
            } else if nodesArray.first?.name == "difficultyButton" {
                changeDifficulty()
            } else if nodesArray.first?.name == "arrowRightButton" {
                if numberOfRocket == 4 {
                    arrowRightButton.run(SKAction.hide())
                } else if numberOfRocket == 1 {
                    arrowLeftButton.run(SKAction.unhide())
                }
                numberOfRocket += 1
                changeRocket()
            } else if nodesArray.first?.name == "arrowLeftButton" {
                if numberOfRocket == 2 {
                    arrowLeftButton.run(SKAction.hide())
                } else if numberOfRocket == 5 {
                    arrowRightButton.run(SKAction.unhide())
                }
                numberOfRocket -= 1
                changeRocket()
            }
        }
    }
    
    func changeDifficulty() {
        let userDefaults = UserDefaults.standard
        
        if difficultyLabelNode.text == "Easy" {
            difficultyLabelNode.text = "Hard"
            userDefaults.set(true, forKey: "hard")
        } else {
            difficultyLabelNode.text = "Easy"
            userDefaults.set(false, forKey: "hard")
        }
        userDefaults.synchronize()
    }
    
    func changeRocket() {
        let userDefaults = UserDefaults.standard
        chooseRocket.texture = SKTexture(imageNamed: "flyingRocket\(numberOfRocket)")
        userDefaults.set(numberOfRocket, forKey: "numberOfRocket")
    }
}
