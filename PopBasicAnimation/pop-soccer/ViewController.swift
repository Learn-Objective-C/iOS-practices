//
//  ViewController.swift
//  pop-soccer
//
//  Created by Marin Todorov on 8/15/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, POPAnimationDelegate {
    
    @IBOutlet var door: UIImageView!
    @IBOutlet var ball: UIImageView!
    
    var playingRect: CGRect!
    var observeBounds = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup ball interaction
        ball.userInteractionEnabled = true
        ball.addGestureRecognizer(
            UIPanGestureRecognizer(target: self, action: Selector("didPan:"))
        )
        
        ball.addObserver(self, forKeyPath: "alpha", options: .New, context: nil)
        ball.alpha = 0
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "alpha" && object as NSObject === ball {
//            println("ball alpha: \(ball.alpha)")
            return
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.fadeInView(ball)
        animateMessage("Game on!")
    }
    
    func didPan(pan: UIPanGestureRecognizer) {
        println("Panning...")
        
        switch pan.state {
        case .Began:
            ball.pop_removeAllAnimations()
        case .Changed:
            ball.center = pan.locationInView(self.view)
            break
        case .Ended:
            let velocity  = pan.velocityInView(view)
            
            let animation = POPDecayAnimation(propertyNamed: kPOPViewCenter)
            
            animation.fromValue = NSValue(CGPoint: ball.center)
            animation.velocity = NSValue(CGPoint: velocity)
            animation.delegate = self
            
            ball.pop_addAnimation(animation, forKey: nil)
            
        default: break
        }
        
    }
    
    func pop_animationDidStop(anim: POPAnimation!, finished: Bool) {
//        if finished {
//            resetBall()
//        }
    }
    
    func pop_animationDidApply(anim: POPAnimation!) {
        if CGRectContainsPoint(door.frame, ball.center) {
            ball.pop_removeAllAnimations()
            resetBall()
            animateMessage("GOAL!!!")
            return
        }
        
        if ball.center.y < 0 {
            ball.pop_removeAllAnimations()
            resetBall()
            return
        }
        
        let minX = ball.frame.size.width / 2
        let maxX = view.frame.size.width - ball.frame.size.width / 2
        
        if ball.center.x < minX || ball.center.x > maxX {
            let velocity = ((anim as POPDecayAnimation).velocity as NSValue).CGPointValue()
            ball.pop_removeAllAnimations()
            
            let newVelocity = CGPoint(x: -velocity.x, y: velocity.y)
            let newX = min(max(minX, ball.center.x), maxX)
            
            let animation = POPDecayAnimation(propertyNamed: kPOPViewCenter)
            animation.fromValue = NSValue(CGPoint: CGPoint(x: newX, y: ball.center.y))
            animation.velocity = NSValue(CGPoint: newVelocity)
            animation.delegate = self;
            ball.pop_addAnimation(animation, forKey: "shot")
        }
    }
    
    func fadeInView(view: UIView) {
        let animation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        view.pop_addAnimation(animation, forKey: nil)
    }
    
    func resetBall() {
        //set ball at random position on the field
        let randomX = CGFloat(Float(arc4random()) / 0xFFFFFFFF)
        ball.center = CGPoint(x: randomX * view.frame.size.width, y: 380.0)
        fadeInView(ball)
    }
    
    func animateMessage(text: String) {
        let label = UILabel(frame: CGRect(x: -view.frame.size.width, y: 200, width: view.frame.size.width, height: 52.0))
        label.font = UIFont(name: "ArialRoundedMTBold", size: 52.0)
        label.textAlignment = .Center
        label.textColor = UIColor.yellowColor()
        label.text = text
        label.shadowColor = UIColor.darkGrayColor()
        label.shadowOffset = CGSize(width: 2, height: 2)
        
        view.addSubview(label)
        
        let animation = POPSpringAnimation(propertyNamed: kPOPViewCenter)
        animation.fromValue = NSValue(CGPoint: label.center)
        animation.toValue = NSValue(CGPoint: view.center)
        animation.springBounciness = 30
        animation.springSpeed = 15
        
        animation.completionBlock = { _, _ in
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                label.alpha = 0
            }, completion: { (_) -> Void in
                label.removeFromSuperview()
            })
            
        }
        
        label.pop_addAnimation(animation, forKey: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}