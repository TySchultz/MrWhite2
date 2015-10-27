//
//  Levels.swift
//  MrWhite2
//
//  Created by Ty Schultz on 9/23/15.
//  Copyright © 2015 Ty Schultz. All rights reserved.
//

import Foundation

import SpriteKit

var currentScene : GameScene?

func levelOne(scene : GameScene) {
    
    currentScene = scene
    
    if let startText = scene.childNodeWithName("levelLabel") as? SKLabelNode {
        animateLabelNode(startText, text: "Level2")
    }
    
    let targetTri = scene.childNodeWithName("targetTri")
    let fadeOut = SKAction.fadeAlphaBy(-1, duration: 1.5)
    let fadeIn = SKAction.fadeAlphaBy(1, duration: 1.5)

    targetTri?.runAction(SKAction.repeatActionForever(SKAction.sequence([fadeOut,fadeIn])), completion: { () -> Void in
        
    })
}

func levelTwo(scene : GameScene) {
    

}

func levelThree(scene : GameScene) {
    
    
}


func levelFour(scene : GameScene) {
    
    
}

func setLevelBoundries(goalX : CGFloat, deadX : CGFloat, resetX : CGFloat, cameraX : CGFloat, circleScore : Int){

    currentScene?.goalXPosition = goalX
    currentScene?.deadXPosition = deadX
    currentScene?.resetXPosition = resetX
    currentScene?.cameraXPosition = cameraX
    currentScene?.circleScore = circleScore
}

func animateLabelNode(label : SKLabelNode, text : NSString){
    
    let fadeOutText = SKAction.fadeOutWithDuration(1.0)
    let fadeInText = SKAction.fadeInWithDuration(1.5)
    label.runAction(fadeOutText, completion: { () -> Void in
        label.text = text as String
        label.runAction(fadeInText)
    })
}