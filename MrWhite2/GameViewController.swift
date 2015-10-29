//
//  GameViewController.swift
//  MrWhite2
//
//  Created by Ty Schultz on 9/23/15.
//  Copyright (c) 2015 Ty Schultz. All rights reserved.
//

import UIKit
import SpriteKit
import RealmSwift

class GameViewController: UIViewController {

    var time = 0
    var initials = ""
    

    @IBOutlet weak var initialLabel: UILabel!
    @IBOutlet weak var timeHeaderLabel: UILabel!
    @IBOutlet weak var initialsView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        initialsView.hidden = true
//        self.initialsView.alpha = 1.0
        initialsView.backgroundColor = UIColor(red:0.18, green:0.45, blue:0.64, alpha:0.8)
//        initialsView.frame = CGRect(x: 0, y: -225, width: self.view.frame.size.width, height: 450)
        self.initialsView.hidden = true


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
    override var preferredFocusedView: UIView? {
//        if someCondition {
//            return theViewYouWant
//        } else {
//            return defaultView
//        }
        if self.initialsView.hidden == true {
            return self.view
        }else{
            return self.initialsView
        }
    }
    
    func timeText (time : Int) -> String {
        if time < 10 {
            return  "0:0\(time)"
        }else if time < 60 {
            return "0:\(time)"
        }else if time < 600 {
            let tmp = time % 60
            let minutes = Int(floor(Double(time) / 60.0))
            if tmp < 10 {
                return "\(minutes):0\(tmp)"
            }else if tmp < 60 {
                return "\(minutes):\(tmp)"
            }
        }else{
            return "\(time)"
        }
        return "0:00"
    }
    
    
    func dismissView(time : Int, alive :Bool){
        let successView = SuccessAnimationView(frame: self.view.frame)

        if !alive {
            successView.changeColor(UIColor(red:0.7, green:0.06, blue:0.18, alpha:1), color2: UIColor(red:0.94, green:0.33, blue:0.32, alpha:1), message: "FAILURE")
            
        }
        
        self.view.addSubview(successView)
        
        self.time = time
        self.timeHeaderLabel.text = timeText(self.time)
        
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 3 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
           
            if !alive{
                self.dismissViewControllerAnimated(true, completion: nil)
            }else{
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.initialsView.hidden = false

                    }, completion: { (Bool) -> Void in
                        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil) // grabs the storybaord
                        let viewController = storyboard.instantiateViewControllerWithIdentifier("EnterInitials")  as! EnterInitialsViewController //Uses the view created in the sotryboard so we have autolayout
                        viewController.parentController = self
                        
                        self.presentViewController(viewController, animated: true) { () -> Void in
                            
                        }
                

                })
            }
        }
    }
    
    func changeInitials(newInitials : String){
        self.initials = newInitials
        
        
    }
    
    @IBOutlet weak var donePressed: UIButton!
    
    @IBAction func doneButtonPressed(sender: UIButton) {
        let realm = try? Realm()
        
        //Creates a new course
        let newScore = Score()
        newScore.time = self.time
        newScore.initials = self.initials
        
        try! realm?.write {
            realm?.add(newScore)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}
