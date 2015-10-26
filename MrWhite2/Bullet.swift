//
//  Bullet.swift
//  MrWhite2
//
//  Created by Ty Schultz on 9/26/15.
//  Copyright © 2015 Ty Schultz. All rights reserved.
//

import SpriteKit

public class Bullet: SKSpriteNode {
    
    enum CharacterDirection : Int {
        case Left
        case Right
    }
    
    var direction : CharacterDirection
    
    var length: CGFloat!
    
    override init(texture: SKTexture!, color: SKColor, size: CGSize) {
        direction = .Left
        super.init(texture: texture, color: color, size: size)
        self.name = "Bullet"
        addPhysicsBody()

    }
    
    convenience init(color: SKColor, length: CGFloat = 10) {
        let size = CGSize(width: length, height: length);
        self.init(texture:nil, color: color, size: size)
        addPhysicsBody()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        // Decoding length here would be nice...
        direction = .Left
        super.init(coder: aDecoder)
    }
    
    public func changeDirection(newDirection : Int){
        direction = CharacterDirection(rawValue: newDirection)!
    }
    
    public func addPhysicsBody(){
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(16, 8))
        self.physicsBody!.dynamic = true
        self.name = "Bullet"
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.allowsRotation = false
        
    }
   
}

