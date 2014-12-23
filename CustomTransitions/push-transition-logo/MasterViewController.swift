//
//  MasterViewController.swift
//  push-transition-logo
//
//  Created by Marin Todorov on 8/9/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit
import QuartzCore

//
// Util delay function
//
func delay(#seconds: Double, completion:()->()) {
    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
    
    dispatch_after(popTime, dispatch_get_main_queue()) {
        completion()
    }
}

class MasterViewController: UIViewController {
    
    let logo = RWLogoLayer.logoLayer()
    let transition = TransitionController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Start"
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        
        // add the pan gesture recognizer
        let tap = UITapGestureRecognizer(target: self, action: Selector("didTap"))
        view.addGestureRecognizer(tap)
        
//        let pan = UIPanGestureRecognizer(target: self, action: "didPan:")
//        view.addGestureRecognizer(pan)
        
        // add the logo to the view
        logo.position = CGPoint(x: view.layer.bounds.size.width/2,
            y: view.layer.bounds.size.height/2 + 30)
        logo.fillColor = UIColor.whiteColor().CGColor
        view.layer.addSublayer(logo)
        
        
    }
    
    //
    // MARK: Gesture recognizer handler
    //
    func didTap() {
        performSegueWithIdentifier("details", sender: nil)
    }
    
    func didPan(recognizer: UIPanGestureRecognizer) {
        if transition.animating {
            return
        }
        
        if recognizer.state == .Began {
            performSegueWithIdentifier("details", sender: nil)
        }
        
        transition.handlePan(recognizer)
    }
    
}


extension MasterViewController : UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .Push {
            self.transition.operation = operation
            return transition
        } else {
            return nil
        }
    }
    
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        if transition.animating {
            return nil
        } else {
            return transition
        }
        
    }
}








