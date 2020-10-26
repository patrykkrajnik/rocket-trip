//
//  RocketNode.swift
//  Rocket Trip
//
//  Created by Patryk Krajnik on 07/06/2020.
//  Copyright © 2020 Patryk Krajnik. All rights reserved.
//

import SpriteKit

class RocketNode: SKSpriteNode {
    init() {
        let texture = SKTexture(imageNamed: "flyingRocket")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
