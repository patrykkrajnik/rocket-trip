//
//  MenuScene.swift
//  Rocket Trip
//
//  Created by Patryk Krajnik on 08/06/2020.
//  Copyright © 2020 Patryk Krajnik. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    var newGameButton: SKSpriteNode!
    
    var difficultyButton: SKSpriteNode!
    var difficultyLabel: SKLabelNode!
    
    var arrowLeftButton: SKSpriteNode!
    var arrowRightButton: SKSpriteNode!
    
    var chooseRocket: SKSpriteNode!
    var numberOfRocket = 1
    
    let userDefaults = UserDefaults.standard
    
    override func didMove(to view: SKView) {
        setupButtonsAndLabels()
        arrowLeftButton.run(SKAction.hide())
        changeRocket()
        
        if userDefaults.bool(forKey: "hard") {
            difficultyLabel.text = "Hard"
        } else {
            difficultyLabel.text = "Easy"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            
            //Handling available buttons
            switch nodesArray.first?.name {
            case "newGameButton":
                let transition = SKTransition.flipHorizontal(withDuration: 1.0)
                let gameScene = SKScene(fileNamed: "GameScene") as! GameScene
                gameScene.scaleMode = .aspectFill
                gameScene.numberOfRocket = numberOfRocket
                view!.presentScene(gameScene, transition: transition)
            case "difficultyButton":
                changeDifficulty()
            case "arrowRightButton":
                if numberOfRocket == 4 {
                    arrowRightButton.run(SKAction.hide())
                } else if numberOfRocket == 1 {
                    arrowLeftButton.run(SKAction.unhide())
                }
                numberOfRocket += 1
                changeRocket()
            case "arrowLeftButton":
                if numberOfRocket == 2 {
                    arrowLeftButton.run(SKAction.hide())
                } else if numberOfRocket == 5 {
                    arrowRightButton.run(SKAction.unhide())
                }
                numberOfRocket -= 1
                changeRocket()
            default:
                print("Unknown button")
            }
        }
    }
    
    //Setting up all buttons and labels
    func setupButtonsAndLabels() {
        newGameButton = (childNode(withName: "newGameButton") as! SKSpriteNode)
        
        difficultyButton = (childNode(withName: "difficultyButton") as! SKSpriteNode)
        difficultyLabel = (childNode(withName: "difficultyLabel") as! SKLabelNode)
        
        arrowLeftButton = (childNode(withName: "arrowLeftButton") as! SKSpriteNode)
        arrowRightButton = (childNode(withName: "arrowRightButton") as! SKSpriteNode)
        
        chooseRocket = (childNode(withName: "chooseRocket") as! SKSpriteNode)
    }
    
    //Changing the difficulty of game
    func changeDifficulty() {
        if difficultyLabel.text == "Easy" {
            difficultyLabel.text = "Hard"
            userDefaults.set(true, forKey: "hard")
        } else {
            difficultyLabel.text = "Easy"
            userDefaults.set(false, forKey: "hard")
        }
        userDefaults.synchronize()
    }
    
    //Changing the texture of Rocket
    func changeRocket() {
        chooseRocket.texture = SKTexture(imageNamed: "flyingRocket\(numberOfRocket)")
        userDefaults.set(numberOfRocket, forKey: "numberOfRocket")
    }
}
