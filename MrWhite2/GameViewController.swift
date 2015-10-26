//
//  GameViewController.swift
//  MrWhite2
//
//  Created by Ty Schultz on 9/23/15.
//  Copyright (c) 2015 Ty Schultz. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
            // Configure the view.
            scene.parentController = self
        
            
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit appvars additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
            
            
//            let tapRecognizer = UITapGestureRecognizer(target: self, action: "tapped:")
//            tapRecognizer.allowedPressTypes = [NSNumber(integer: UIPressType.PlayPause.rawValue)];
//            self.view.addGestureRecognizer(tapRecognizer)
//
//            let rightSwipe = UISwipeGestureRecognizer(target: scene, action: "swipeRight")
//            rightSwipe.direction = .Right
//            self.view.addGestureRecognizer(rightSwipe)
//            
//            
//            let leftSwipe = UISwipeGestureRecognizer(target: scene, action: "swipeLeft")
//            leftSwipe.direction = .Left
//            self.view.addGestureRecognizer(leftSwipe)

        }
    }
    
    
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        for item in presses {
            if item.type == UIPressType.Select {
                let skView = self.view as! SKView
                let scene = skView.scene as! GameScene
                scene.jump()
                
            }else if item.type == UIPressType.PlayPause {
                let skView = self.view as! SKView
                let scene = skView.scene as! GameScene
                scene.shootStarted()
            }else if item.type == UIPressType.Menu {
                let skView = self.view as! SKView
                let scene = skView.scene as! GameScene
                let gameScene = SKScene(fileNamed: "GameScene") as? GameScene
                let transition = SKTransition.doorsOpenHorizontalWithDuration(1.0)
                
                scene.runAction(SKAction.sequence([SKAction.fadeAlphaBy(-1.0, duration: 1.0), SKAction.waitForDuration(0.5)]), completion: { () -> Void in
                    skView.presentScene(gameScene!, transition: transition)
                })

            }
        }
    }
    
    override func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        for item in presses {
            if item.type == UIPressType.Select {

            }else if item.type == UIPressType.PlayPause {
                let skView = self.view as! SKView
                let scene = skView.scene as! GameScene
                scene.shootEnded()

            }
        }
    }
    
    
    func dismissView(){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}
