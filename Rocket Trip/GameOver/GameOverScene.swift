//
//  GameOverScene.swift
//  Rocket Trip
//
//  Created by Patryk Krajnik on 08/06/2020.
//  Copyright © 2020 Patryk Krajnik. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    var score: Int = 0
    
    var scoreLabel: SKLabelNode!
    var newGameButtonNode: SKSpriteNode!
    var difficultyButtonNode: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        scoreLabel = (self.childNode(withName: "scoreLabel") as! SKLabelNode)
        scoreLabel.text = "\(score)"
        
        newGameButtonNode = (self.childNode(withName: "newGameButton") as! SKSpriteNode)
        difficultyButtonNode = (self.childNode(withName: "difficultyButton") as! SKSpriteNode)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "newGameButton" {
                let transition = SKTransition.flipHorizontal(withDuration: 1.0)
                let gameScene = SKScene(fileNamed: "GameScene")
                gameScene!.scaleMode = .aspectFill
                view!.presentScene(gameScene!, transition: transition)
            } else if nodesArray.first?.name == "difficultyButton" {
                let transition = SKTransition.flipHorizontal(withDuration: 1.0)
                let menuScene = SKScene(fileNamed: "MenuScene")
                menuScene!.scaleMode = .aspectFill
                view!.presentScene(menuScene!, transition: transition)
            }
        }
    }
}
