//
//  SuccessAnimationView.swift
//  Planet
//
//  Created by Ty Schultz on 10/25/15.
//  Copyright © 2015 Ty Schultz. All rights reserved.
//

import UIKit

class SuccessAnimationView: UIView {

    let BACKGROUNDCOLOR = UIColor(red:0.18, green:0.45, blue:0.64, alpha:1)
    var LIGHTCOLOR = UIColor(red:0.27, green:0.73, blue:0.98, alpha:1)

    let ANIMATIONTIME = 0.2
    let ALPHA :CGFloat = 0.9
    
    //Objects
    var backgroundView : UIView?
    var box : UIView?
    var label : UILabel?

    //Lines
    var leftBorderLine : UIView?
    var rightBorderLine : UIView?
    var topBorderLine : UIView?
    var bottomBorderLine : UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.initialize()
    }
    
    convenience init() {
        self.init(frame: CGRectZero)
        self.initialize()
    }
    
    func closeView(){
        self.removeFromSuperview()
    }
    
    func initialize() {
        
       let tapRecognizer = UITapGestureRecognizer(target: self, action: "closeView")
        addGestureRecognizer(tapRecognizer)
        
        backgroundColor = UIColor.clearColor()
        
        
        backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: self.frame.size.height))
        backgroundView?.backgroundColor = BACKGROUNDCOLOR
        backgroundView?.alpha = ALPHA
        
        addSubview(backgroundView!)
        
        createBox()
        createLines()
        createLabel()
        animateLines()

        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseOut, animations: { () -> Void in
            self.backgroundView!.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)

            }) { (Bool) -> Void in
        }
    }
    
    func changeColor(color: UIColor, color2 :UIColor, message : String){
        LIGHTCOLOR = color2
        backgroundView?.backgroundColor = color
        leftBorderLine?.backgroundColor = color2
        rightBorderLine?.backgroundColor = color2
        topBorderLine?.backgroundColor = color2
        bottomBorderLine?.backgroundColor = color2
        label?.text = message
    }
    
    func createBox() {
        let width :CGFloat = 400
        let height :CGFloat = 100
        box = UIView(frame: CGRect(x: 64, y: self.frame.midY-50, width: width, height: height))
        box?.backgroundColor = UIColor.clearColor()
        box?.center = self.center
        addSubview(box!)
    }
    
    func createLabel() {
        let width = self.frame.size.width-128
        let height :CGFloat = 100

        label = UILabel(frame: CGRect(x: 64, y: self.frame.midY-50, width: width, height: height))
        label?.text = "Success"
        label?.font = UIFont(name: "Avenir Medium", size: 40.0)
        label?.textColor = UIColor.whiteColor()
        label?.textAlignment = NSTextAlignment.Center
        label?.alpha = 0.0
        addSubview(label!)
    }
    
    func createLines () {
        let LINECOLOR = LIGHTCOLOR
        let STARTSIZE : CGFloat = 1.0
        let RIGHTX : CGFloat = box!.frame.size.width
        let BOTTOMY : CGFloat = box!.frame.size.height
        
        
        leftBorderLine = UIView(frame: CGRect(x: 0, y: BOTTOMY, width: STARTSIZE, height: STARTSIZE))
        leftBorderLine?.backgroundColor = LINECOLOR
        box!.addSubview(leftBorderLine!)
        
        rightBorderLine = UIView(frame: CGRect(x: RIGHTX, y: 0, width: STARTSIZE, height: STARTSIZE))
        rightBorderLine?.backgroundColor = LINECOLOR
        box!.addSubview(rightBorderLine!)
        
        topBorderLine = UIView(frame: CGRect(x: 0, y: 0, width: STARTSIZE, height: STARTSIZE))
        topBorderLine?.backgroundColor = LINECOLOR
        box!.addSubview(topBorderLine!)
        
        bottomBorderLine = UIView(frame: CGRect(x: RIGHTX, y: BOTTOMY, width: STARTSIZE, height: STARTSIZE))
        bottomBorderLine?.backgroundColor = LINECOLOR
        box!.addSubview(bottomBorderLine!)
        
    }
    
   
    
    func animateLines() {
        let LINEWIDTH :CGFloat = 2.0
        let HEIGHT :CGFloat = 100
        let WIDTH :CGFloat = box!.frame.size.width
        let RIGHTX : CGFloat = box!.frame.size.width
        let BOTTOMY : CGFloat = box!.frame.size.height
        
        flashLabelAlpha(3)
        
        UIView.animateWithDuration(0.2, animations:  { () -> Void in
            self.leftBorderLine?.frame = CGRectMake(0, 0, LINEWIDTH, HEIGHT) //Left Bar
            }) { (Bool) -> Void in
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.topBorderLine?.frame = CGRectMake(0, 0, WIDTH, LINEWIDTH) //top Bar
                    }) { (Bool) -> Void in
                        UIView.animateWithDuration(0.1, animations: { () -> Void in
                            self.rightBorderLine!.frame = CGRectMake(RIGHTX, 0, LINEWIDTH, HEIGHT) // right Bar
                            }) { (Bool) -> Void in
                                UIView.animateWithDuration(0.4, delay: 0.0, options: .CurveEaseOut, animations: { () -> Void in
                                    self.bottomBorderLine?.frame = CGRectMake(0, BOTTOMY, WIDTH, LINEWIDTH) // Bottom Bar
                                    }) { (Bool) -> Void in
                                        
                                            self.animateBars() // Call bar animations
                                }
                        }
                }
        }
    }
    
    func animateBars(){
        let BARCOLOR = LIGHTCOLOR
        let HEIGHT :CGFloat = 100
        let WIDTH :CGFloat = box!.frame.size.width
        let RIGHTX : CGFloat = box!.frame.size.width
        let BOTTOMY : CGFloat = box!.frame.size.height
        
        //Create two bars for sideways motion
        let secondBar = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: HEIGHT))
        secondBar.backgroundColor = BARCOLOR
        secondBar.alpha = 0.6
        box!.addSubview(secondBar)
        box!.sendSubviewToBack(secondBar)
        
        let firstBar = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: HEIGHT))
        firstBar.backgroundColor = BARCOLOR
        firstBar.alpha = 0.3
        box!.addSubview(firstBar)
        box!.sendSubviewToBack(firstBar)
        
        
        //Create animations
        let firstBarAnimation  = {
            firstBar.frame = CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT)
        }
        
        let secondBarAnimation = {
            secondBar.frame = CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT)
        }
        
        let secondBarShrinkWithTopLine = {
            secondBar.frame = CGRect(x: RIGHTX, y: 0, width: 0, height: HEIGHT)
            self.topBorderLine?.frame = CGRect(x: RIGHTX, y: 0, width: 0, height: 0)
        }
        
        let shrinkBottomAndRightLine = {
            self.bottomBorderLine?.frame = CGRect(x: RIGHTX, y: BOTTOMY, width: 0, height: 0)
            self.rightBorderLine?.frame = CGRect(x: RIGHTX, y: BOTTOMY, width: 0, height: 0)
        }
        
        let fadeBackgroundView = {
            self.backgroundView!.alpha = 0.0
        }
        
        let fadeLabelAndFirstBar = {
            firstBar.frame = CGRect(x: RIGHTX, y: 0, width: 0, height: HEIGHT)
            self.label?.alpha = 0.0
        }
        
        //Run Animations
        UIView.animateWithDuration(0.3, delay: 0.2, options: .CurveEaseInOut, animations: firstBarAnimation) { (Finished) -> Void in
            UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseInOut, animations: secondBarAnimation ) { (Finished) -> Void in
                //Shrink
                self.leftBorderLine?.alpha  = 0.0

                UIView.animateWithDuration(0.3, delay: 0.0,  options: .CurveEaseInOut, animations: secondBarShrinkWithTopLine, completion: nil)
                UIView.animateWithDuration(0.3, delay: 0.15, options: .CurveEaseInOut, animations: shrinkBottomAndRightLine, completion: nil)
                UIView.animateWithDuration(0.4, delay: 0.3,  options: .CurveEaseInOut, animations: fadeBackgroundView, completion: nil)
                UIView.animateWithDuration(0.3, delay: 0.1,  options: .CurveEaseInOut, animations: fadeLabelAndFirstBar, completion: nil)
            }
        }
    }
    
    
    func flashLabelAlpha(flashes : Int){
        if flashes == 0 { return }
        UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveLinear, animations: { () -> Void in
            if self.label!.alpha == 1.0 {
                self.label!.alpha = 0.0
            }else{
                self.label!.alpha = 1.0
            }
        }, completion: { (Bool) -> Void in
              self.flashLabelAlpha(flashes-1)
        })
    }
    
}
