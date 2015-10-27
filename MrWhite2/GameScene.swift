//
//  GameScene.swift
//  MrWhite2
//
//  Created by Ty Schultz on 9/23/15.
//  Copyright (c) 2015 Ty Schultz. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, UIGestureRecognizerDelegate, SKPhysicsContactDelegate {
    
    enum CharacterDirection : Int {
        case Jump
        case Ground
    }
    
    enum MoveDirection : Int {
        case Left
        case Right
        case Stopped
    }
    
    let playerCategory    : UInt32 = 0x1 << 0
    let floorCategory     : UInt32 = 0x1 << 1
    let targetCategory    : UInt32 = 0x1 << 2
    let bulletCategory    : UInt32 = 0x1 << 3

    
    var parentController : GameViewController!

    var moveDirection : MoveDirection?
    var characterDirection : CharacterDirection?
    
    var jumping = false
    var level2 = false
    
    var jumps :Int = 2

    var bulletSpeed :CGFloat = 10
    
    var startTime :CFTimeInterval?


    var goalXPosition :CGFloat = 1000
    var deadXPosition :CGFloat = 0.0
    var resetXPosition :CGFloat = 230.0
    var cameraXPosition :CGFloat = 450
    
    var circleScore = 8
    var lives = 1
    var currentTime = 0
    var timer : NSTimer!

    var moveSpeed :CGFloat = 0.3

    var previousDirection : MoveDirection?

    var sceneNumber = 0

    var trackingDistance = 100.0
    var startLocation : CGPoint?


    func timerInterval () {
        currentTime++
        let timerLabel = childNodeWithName("timerLabel") as! SKLabelNode
        if currentTime < 10 {
            timerLabel.text = "0:0\(currentTime)"
        }else if currentTime < 60 {
            timerLabel.text = "0:\(currentTime)"
        }else if currentTime < 600 {
            let tmp = currentTime % 60
            let minutes = Int(floor(Double(currentTime) / 60.0))
            if tmp < 10 {
                timerLabel.text = "\(minutes):0\(tmp)"
            }else if tmp < 60 {
                timerLabel.text = "\(minutes):\(tmp)"
            }
        }else{
            timerLabel.text = "\(currentTime)"
        }
    }
    override func didMoveToView(view: SKView) {
    
        /* Setup your scene here */
//        let myLabel = SKLabelNode(fontNamed:"Avenir Book")
//        myLabel.text = "Hello, World!";
//        myLabel.name = "startText"
//        myLabel.fontSize = 65;
//        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
//        self.addChild(myLabel)
//        

        characterDirection = .Ground
        moveDirection = .Stopped
        
        currentTime = 0
        timer =  NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "timerInterval", userInfo: nil, repeats: true)
    
    

        
        physicsWorld.contactDelegate = self
        
  
   
        
        //setup a fire emitter
        let fireEmmitterPath = NSBundle.mainBundle().pathForResource("fire", ofType: "sks")
        
//        
//        let fireEmmitter = NSKeyedUnarchiver.unarchiveObjectWithFile(fireEmmitterPath!) as! SKEmitterNode
//        
//        fireEmmitter.position = CGPointMake(self.frame.size.width, self.frame.size.height);
//        fireEmmitter.name = "fireEmmitter";
//        fireEmmitter.zPosition = 1;
//        fireEmmitter.targetNode = self;
//        
//        addChild(fireEmmitter)
////
//
//        let light = SKLightNode()
//        light.categoryBitMask = 1;
//        light.falloff = 1;
//        light.ambientColor = UIColor.whiteColor()
//        light.lightColor = UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 0.5)
//        light.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
//        fireEmmitter.addChild(light)
//        
        setupCategories()
    }
    
    
    func setupCategories (){
        
        if let ball = childNodeWithName("redCircle") as? SKSpriteNode {
            ball.physicsBody?.categoryBitMask = playerCategory
            ball.physicsBody?.collisionBitMask  = floorCategory
            ball.physicsBody?.contactTestBitMask = floorCategory
        }
        
        for child in children {
            if child.name == "floor" {
                child.physicsBody?.categoryBitMask = floorCategory
                child.physicsBody?.collisionBitMask  = bulletCategory | playerCategory
                child.physicsBody?.contactTestBitMask = playerCategory
            }
            
            if child.name == "target" {
                child.physicsBody?.categoryBitMask = targetCategory
                child.physicsBody?.collisionBitMask  = playerCategory
                child.physicsBody?.contactTestBitMask = playerCategory
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        startLocation =  touches.first?.locationInNode(self)

        for touch in touches {
          let location = touch.locationInNode(self)
            startLocation = location
            
//            print("\(location)")
//
////            
////            let sprite = SKSpriteNode(imageNamed:"Spaceship")
////            
////            sprite.xScale = 0.5
////            sprite.yScale = 0.5
////            sprite.position = location
////            
////            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
////            
////            sprite.runAction(SKAction.repeatActionForever(action))
////            
////            self.addChild(sprite)
//            
//            if let ball = childNodeWithName("redCircle") {
//                ball.physicsBody?.applyImpulse(CGVectorMake(0, 50))
//                ball.physicsBody?.angularVelocity = -3.3
//            }
//            
//            if let ball = childNodeWithName("ball") {
//                ball.physicsBody?.applyImpulse(CGVectorMake(0, 60))
//            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        previousDirection = moveDirection
        moveDirection = .Stopped
//        for touch in touches {
//            let touchLocation = touch.locationInNode(self)
//
//            var dx = touchLocation.x - startLocation!.x
//            var dy = touchLocation.y - startLocation!.y
//
//            // Calculate the distance from the `touchPadAnchorPoint` to the current location.
//            let distance = hypot(dx, dy)
//
//            /*
//            If the distance is greater than our allowed `trackingDistance`,
//            create a unit vector and multiply by max displacement
//            (`trackingDistance`).
//            */
//            let trackingDistance :CGFloat = 0.1
//            if distance > trackingDistance {
//                dx = (dx / distance) * trackingDistance
//                dy = (dy / distance) * trackingDistance
//            }
//
//            // Position the touchPad to match the touch's movement.
////            touchPad.position = CGPoint(x: center.x + dx, y: center.y + dy)
//
//            // Normalize the displacements between [-1.0, 1.0].
//            let normalizedDx = CGFloat(dx / trackingDistance) * 8.0
//            let normalizedDy = CGFloat(dy / trackingDistance) * 8.0
////            delegate?.thumbStickNode(self, didUpdateXValue: normalizedDx, yValue: normalizedDy)
//            
//            let ball = childNodeWithName("redCircle") as! SKSpriteNode
//            ball.physicsBody?.applyImpulse(CGVectorMake(-normalizedDy, normalizedDx))
////            ball.physicsBody?.angularVelocity = -3.3
//        }
    }
//
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let ball = childNodeWithName("redCircle") as? SKSpriteNode {
            
            // For each touch, calculate the movement of the touchPad.
            for touch in touches {
                let touchLocation = touch.locationInNode(self)
                
                if (startLocation?.y)! - touchLocation.y > -50 {
                    moveDirection = .Right
                    ball.texture = SKTexture(imageNamed: "triRight")
                }else if (startLocation?.y)! - touchLocation.y < 50 {
                    moveDirection = .Left
                    ball.texture = SKTexture(imageNamed: "triLeft")

                }
                
//
////                var dx = touchLocation.x - center.x
////                var dy = touchLocation.y - center.y
//                
//                // Calculate the distance from the `touchPadAnchorPoint` to the current location.
//                let distance = hypot(dx, dy)
//                
//                /*
//                If the distance is greater than our allowed `trackingDistance`,
//                create a unit vector and multiply by max displacement
//                (`trackingDistance`).
//                */
//                if distance > trackingDistance {
//                    dx = (dx / distance) * trackingDistance
//                    dy = (dy / distance) * trackingDistance
//                }
//                
//                // Position the touchPad to match the touch's movement.
////                touchPad.position = CGPoint(x: center.x + dx, y: center.y + dy)
//                
//                // Normalize the displacements between [-1.0, 1.0].
//                let normalizedDx = Float(dx / trackingDistance)
//                let normalizedDy = Float(dy / trackingDistance)
//                delegate?.thumbStickNode(self, didUpdateXValue: normalizedDx, yValue: normalizedDy)
            
            
//            ball.physicsBody?.applyImpulse(CGVectorMake(0, 50))
//            ball.physicsBody?.angularVelocity = -3.3
            }
        }
    }
//
    
    func jump(){
        if jumps > 0 {
            jumping = true
            if let ball = childNodeWithName("redCircle") {
                ball.physicsBody?.allowsRotation = true
                ball.physicsBody?.velocity = CGVectorMake((ball.physicsBody?.velocity.dx)!, 0)
                ball.physicsBody?.applyImpulse(CGVectorMake(0, 12))
                
                if moveDirection == .Left {
                    ball.physicsBody?.angularVelocity = 8
                }else if moveDirection == .Right {
                    ball.physicsBody?.angularVelocity = -8
                }
                jumps--
            }
        }
    }
    
    func shootStarted(){
        let ball = childNodeWithName("redCircle")
            ball!.alpha = 0.3
    
    }
    
    func shootEnded(){
        let ball = childNodeWithName("redCircle")
        ball!.alpha = 1.0
    
        let bulletSpeedMultiplyer :CGFloat = 4.0
        
        let bullet = Bullet(texture: nil, color: SKColor.whiteColor(), size: CGSizeMake(16, 8))
        bullet.position = ball!.position
        if moveDirection == .Left {
            bullet.changeDirection(0)
            bullet.physicsBody?.velocity = CGVectorMake(-bulletSpeed*bulletSpeedMultiplyer, 0)
        }else if moveDirection == .Right {
            bullet.changeDirection(1)
            bullet.physicsBody?.velocity = CGVectorMake(bulletSpeed*bulletSpeedMultiplyer, 0)
        }else if previousDirection == .Left {
            bullet.changeDirection(0)
            bullet.physicsBody?.velocity = CGVectorMake(-bulletSpeed*bulletSpeedMultiplyer, 0)
        }else if previousDirection == .Right{
            bullet.changeDirection(1)
            bullet.physicsBody?.velocity = CGVectorMake(bulletSpeed*bulletSpeedMultiplyer, 0)
        }
        bullet.physicsBody?.categoryBitMask = bulletCategory
        bullet.physicsBody?.collisionBitMask  = floorCategory | targetCategory
        bullet.physicsBody?.contactTestBitMask = targetCategory

        addChild(bullet)
        

    }
    
    func createBall() {
        
        let texture = SKTexture(imageNamed: "r4")
        let ball = SKSpriteNode(texture: texture)
        var array :NSMutableArray = []

        let playerAnimation = SKTextureAtlas(named: "Player")
        let walkAnimation = [
            playerAnimation.textureNamed("r1"),
            playerAnimation.textureNamed("r2"),
            playerAnimation.textureNamed("r3"),
            playerAnimation.textureNamed("r4"),
            playerAnimation.textureNamed("r5"),
            playerAnimation.textureNamed("r6"),
            playerAnimation.textureNamed("r7")
        ]
//
        ball.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(walkAnimation, timePerFrame:0.06)))
        
//        SKTextureAtlas *playerAnimationAtlas = [SKTextureAtlas atlasNamed:@"player"];
//        NSMutableArray *walkAnimation = [[NSMutableArray alloc] init];
//        [walkAnimation addObject:[playerAnimationAtlas textureNamed:@"player-walk1"]];
//        [walkAnimation addObject:[playerAnimationAtlas textureNamed:@"player-walk2"]];
//        [walkAnimation addObject:[playerAnimationAtlas textureNamed:@"player-walk3"]];
//        [walkAnimation addObject:[playerAnimationAtlas textureNamed:@"player-walk4"]];
//        
//        CGPoint distance = CGPointMake(location.x - self.position.x, location.y - self.position.y);
//        float walkLength = sqrtf(distance.x * distance.x + distance.y * distance.y);
//        float walkDuration = walkLength / 80.0;
//        [self runAction:[SKAction repeatActionForever:
//        [SKAction animateWithTextures:walkAnimation timePerFrame:0.3f resize:NO restore:YES]] withKey:@"playerWalkAnimation"];
//        [self runAction:[SKAction sequence:@[[SKAction moveTo:location duration:walkDuration],
//        [SKAction runBlock:^{ [self walkStop]; }]]] withKey:@"playerWalkMovement"];
//        
        ball.setScale(0.45)
        ball.position = CGPoint(x: 100, y: 500)
        ball.name = "ball"
        ball.physicsBody = SKPhysicsBody(rectangleOfSize: ball.frame.size)
        ball.physicsBody?.usesPreciseCollisionDetection = true
//        ball.physicsBody?.categoryBitMask = ballCategory
//        ball.physicsBody?.contactTestBitMask = blockCategory | paddleCategory | backCategory | destroyCategory
//        ball.physicsBody?.collisionBitMask = 1
        ball.physicsBody?.allowsRotation = true
        ball.physicsBody?.linearDamping = 0.0
        ball.physicsBody?.restitution = 0.0
        ball.physicsBody?.friction = 2.0
        ball.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
        ball.physicsBody?.mass = 0.1
        ball.alpha = 0.0
        addChild(ball)
        let fade = SKAction.fadeAlphaBy(1.0, duration: 0.5)
        
        ball.runAction(fade)
        
    }
    
    
    func moveCameraToPlayer () {
        let tri = childNodeWithName("redCircle") as? SKSpriteNode
        let camera = childNodeWithName("Camera") as? SKCameraNode

        let triPosition = tri?.position
        var cameraPosition = camera?.position
        
        if triPosition!.y - cameraPosition!.y > 10 {
            cameraPosition?.y = cameraPosition!.y+8
        }else if triPosition!.y - cameraPosition!.y < -10 {
            cameraPosition?.y = cameraPosition!.y-8
        }
        
        if triPosition!.x - cameraPosition!.x > 10 {
            cameraPosition?.x = cameraPosition!.x+8
        }else if triPosition!.x - cameraPosition!.x < -10 {
            cameraPosition?.x = cameraPosition!.x-8
        }
        camera?.position = cameraPosition!

    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
       
        if let tri = childNodeWithName("redCircle") {
            let dot = childNodeWithName("directionDot") as? SKSpriteNode
            let camera = childNodeWithName("Camera") as? SKCameraNode
            
            if camera?.position != tri.position{
//                moveCameraToPlayer()
            }

        
            if tri.position.y < -1000 {
                tri.alpha = 0.0
                let fade = SKAction.fadeAlphaBy(1.0, duration: 2.0)
                tri.position = CGPoint(x: resetXPosition, y: 250)
                tri.physicsBody?.velocity = CGVectorMake(0, 0)
                tri.runAction(fade)
                
                lives++
                let livesLabel = childNodeWithName("levelLabel") as! SKLabelNode
                livesLabel.text = "Lives: \(lives)"

            }
            
            var magnitude :CGFloat = moveSpeed
            if moveDirection == .Left {
                if tri.physicsBody?.velocity.dx > -20{
                    magnitude = magnitude*4
                }
                tri.physicsBody?.applyImpulse(CGVectorMake(-magnitude, 0))
                dot?.position = CGPointMake(tri.position.x - tri.frame.size.width/2, tri.position.y + tri.frame.size.height/2)

            }else if moveDirection == .Right {
                if tri.physicsBody?.velocity.dx < 20 {
                    magnitude = magnitude*4
                }
                tri.physicsBody?.applyImpulse(CGVectorMake(magnitude, 0))
                dot?.position = CGPointMake(tri.position.x + tri.frame.size.width/2, tri.position.y + tri.frame.size.height/2)

            }else{
                if previousDirection == .Left {
                    dot?.position = CGPointMake(tri.position.x - tri.frame.size.width/2, tri.position.y + tri.frame.size.height/2)

                }else{
                    dot?.position = CGPointMake(tri.position.x + tri.frame.size.width/2, tri.position.y + tri.frame.size.height/2)

                }
                slowDownBall()
            }
            
//            print("\(tri.physicsBody?.velocity.dx)")
            let velocity = tri.physicsBody?.velocity
            if velocity!.dx > 600 {
                tri.physicsBody?.velocity = CGVectorMake(600, velocity!.dy)
            }else if velocity!.dx < -600{
                tri.physicsBody?.velocity = CGVectorMake(-600, velocity!.dy)
            }
            
            
            
            for child in children {
                if child.name == "Bullet" {
                    let bullet = child as! Bullet
                    if bullet.direction == .Left {
                        bullet.physicsBody?.applyForce(CGVectorMake(-bulletSpeed, 0))
                    }else if bullet.direction == .Right {
                        bullet.physicsBody?.applyForce(CGVectorMake(bulletSpeed, 0))
                    }else if bullet.direction == .Left {
                        bullet.physicsBody?.applyForce(CGVectorMake(-bulletSpeed, 0))
                    }else if bullet.direction == .Right{
                        bullet.physicsBody?.applyForce(CGVectorMake(bulletSpeed, 0))
                    }
                }
            }
        }
    }
    
    func slowDownBall () {
        if let tri = childNodeWithName("redCircle") {
            let velocity = tri.physicsBody?.velocity
            if velocity?.dx != 0.0{
                if velocity?.dx > 1.0 {
                    tri.physicsBody?.applyImpulse(CGVectorMake(-moveSpeed/2, 0))
                }else if velocity?.dx < 1.0 {
                    tri.physicsBody?.applyImpulse(CGVectorMake(moveSpeed/2, 0))
                }
            }
        }
    }
    
    
    func blah () {
        if let tri = childNodeWithName("redCircle") {
            
            let camera = childNodeWithName("Camera")
            if tri.position.x > goalXPosition {
                sceneNumber++
                let move = SKAction.moveTo(CGPoint(x: cameraXPosition+500, y: 200), duration: 1.5)
                let scale = SKAction.scaleTo(2, duration: 1.5)
                camera?.runAction(move)
                camera?.runAction(scale)
                
                levelOne(self)
                changeXPositions()
            }
            
            if tri.position.x < deadXPosition {
                tri.alpha = 0.0
                let fade = SKAction.fadeAlphaBy(1.0, duration: 1.0)
                tri.position = CGPoint(x: resetXPosition, y: 130)
                tri.physicsBody?.velocity = CGVectorMake(0, 0)
                tri.runAction(fade)
                
            }
            if tri.position.y < 0 {
                tri.alpha = 0.0
                let fade = SKAction.fadeAlphaBy(1.0, duration: 1.0)
                tri.position = CGPoint(x: resetXPosition, y: 130)
                tri.zRotation = 135
                tri.physicsBody?.velocity = CGVectorMake(0, 0)
                tri.runAction(fade)
                
            }
            
            if sceneNumber == 3 && tri.position.y > 1000  {
                let platform = SKSpriteNode()
                platform.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(50, 5))
                platform.position = CGPoint(x: tri.position.x-10, y: tri.position.y - 30)
                addChild(platform)
            }
        }
        
        
        if circleScore == 0 && !level2 {
            level2 = true
            let camera = childNodeWithName("Camera")
            let moveAction = SKAction(named: "level2CameraMove")
            camera?.runAction(moveAction!)
            
            sceneNumber++
            
            let mainFloor = childNodeWithName("level3Floor")
            let moveFloor = SKAction(named: "moveFloorToLevel3")
            mainFloor?.runAction(moveFloor!)
            
            let player = childNodeWithName("redCircle") as? SKSpriteNode
            let movePlayer = SKAction(named: "movePlayerToLevel3")
            player?.runAction(movePlayer!)
            
            
        }
        
        if sceneNumber == 1 {
            let circleScoreLabel = childNodeWithName("circleScore") as? SKLabelNode
            
            for child in children {
                if child.name == "circle" {
                    if child.position.y < 0 {
                        child.removeFromParent()
                        circleScore--
                        circleScoreLabel?.text = "\(circleScore)"
                    }
                }
            }
        }

    }
    
    func changeXPositions(){
        switch sceneNumber {
            case 0:
                goalXPosition = 1000
                deadXPosition = 30
                resetXPosition = 230
                cameraXPosition = 450

                break
            case 1:
                goalXPosition = 2050
                deadXPosition = 500
                resetXPosition = 1000
                cameraXPosition = 950

                break
            case 2:
                goalXPosition = 3100
                deadXPosition = 1000
                resetXPosition = 1500
                cameraXPosition = 450

                break
            default:
                goalXPosition = 1000
                deadXPosition = 30
                resetXPosition = 230
                cameraXPosition = 450

                break
            
        }
    }
    
    
    func didEndContact(contact: SKPhysicsContact) {
//        var ballBody: SKPhysicsBody?
//        var otherBody: SKPhysicsBody?
//        
//        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
//            ballBody = contact.bodyA
//            otherBody = contact.bodyB
//        } else {
//            ballBody = contact.bodyB
//            otherBody = contact.bodyA
//        }
//        if otherBody?.categoryBitMask == targetCategory{
//            
//        }
//        print("ballBody Bit: \(ballBody?.categoryBitMask)")
//        print("otherBody Bit: \(otherBody?.categoryBitMask)")
//
//        if ballBody?.categoryBitMask == targetCategory || otherBody?.categoryBitMask == targetCategory {
//            
//            if ballBody?.categoryBitMask == targetCategory{
//                ballBody!.node?.removeFromParent()
//            }else{
//                otherBody!.node?.removeFromParent()
//            }
//            circleScore--
//            let circleScoreLabel = childNodeWithName("circleScore") as! SKLabelNode
//            circleScoreLabel.text = "\(circleScore)"
//        }
//    
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
       
        var ballBody: SKPhysicsBody?
        var otherBody: SKPhysicsBody?
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            ballBody = contact.bodyA
            otherBody = contact.bodyB
        } else {
            ballBody = contact.bodyB
            otherBody = contact.bodyA
        }
        if otherBody?.categoryBitMask == targetCategory{
            
        }
        print("ballBody Bit: \(ballBody?.categoryBitMask)")
        print("otherBody Bit: \(otherBody?.categoryBitMask)")
        
        if ballBody?.categoryBitMask == targetCategory || otherBody?.categoryBitMask == targetCategory {
            
            if ballBody?.categoryBitMask == targetCategory{
                ballBody!.node?.removeFromParent()
            }else{
                otherBody!.node?.removeFromParent()
            }
            circleScore--
            let circleScoreLabel = childNodeWithName("circleScore") as! SKLabelNode
            circleScoreLabel.text = "\(circleScore)"
            
            if circleScore == 0 {
                self.parentController.dismissViewControllerAnimated(true, completion: nil)
            }
            
        }else{
            let ball = childNodeWithName("redCircle")
            jumping = false
            jumps = 2
        }
    }
    
    
    
//    func didBeginContact:(SKPhysicsContact *)contact {
//        [self.contactQueue addObject:contact];
//    }
//    
//    -(void)handleContact:(SKPhysicsContact*)contact {
//    // Ensure you haven't already handled this contact and removed its nodes
//    if (!contact.bodyA.node.parent || !contact.bodyB.node.parent) return;
//    
//    NSArray* nodeNames = @[contact.bodyA.node.name, contact.bodyB.node.name];
//    if ([nodeNames containsObject:kShipName] && [nodeNames containsObject:kInvaderFiredBulletName]) {
//    // Invader bullet hit a ship
//    [self runAction:[SKAction playSoundFileNamed:@"ShipHit.wav" waitForCompletion:NO]];
//    //1
//    [self adjustShipHealthBy:-0.334f];
//    if (self.shipHealth <= 0.0f) {
//    //2
//    [contact.bodyA.node removeFromParent];
//    [contact.bodyB.node removeFromParent];
//    } else {
//    //3
//    SKNode* ship = [self childNodeWithName:kShipName];
//    ship.alpha = self.shipHealth;
//    if (contact.bodyA.node == ship) [contact.bodyB.node removeFromParent];
//    else [contact.bodyA.node removeFromParent];
//    }
//    } else if ([nodeNames containsObject:kInvaderName] && [nodeNames containsObject:kShipFiredBulletName]) {
//    // Ship bullet hit an invader
//    [self runAction:[SKAction playSoundFileNamed:@"InvaderHit.wav" waitForCompletion:NO]];
//    [contact.bodyA.node removeFromParent];
//    [contact.bodyB.node removeFromParent];
//    //4
//    [self adjustScoreBy:100];
//    }
//    }


}
