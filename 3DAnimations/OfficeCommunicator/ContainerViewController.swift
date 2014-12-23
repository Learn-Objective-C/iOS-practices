//
//  ContainerViewController.swift
//  OfficeCommunicator
//
//  Created by David Grandinetti on 8/8/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit
import QuartzCore

class ContainerViewController: UIViewController {
    
    let menuWidth: CGFloat = 80.0
    let animationTime: NSTimeInterval = 0.5
    
    let menuViewController: UIViewController!
    let centerViewController: UIViewController!
    
    var isOpening = false
    
    init(sideMenu: UIViewController, center: UIViewController) {
        menuViewController = sideMenu
        centerViewController = center
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        
        addChildViewController(centerViewController)
        view.addSubview(centerViewController.view)
        centerViewController.didMoveToParentViewController(self)
        
        addChildViewController(menuViewController)
        view.addSubview(menuViewController.view)
        menuViewController.didMoveToParentViewController(self)
        menuViewController.view.layer.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        
        menuViewController.view.frame = CGRect(x: -menuWidth, y: 0,
            width: menuWidth, height: view.frame.height)
        
        var panGesture = UIPanGestureRecognizer(target:self, action:Selector("handleGesture:"))
        view.addGestureRecognizer(panGesture)
        
        setToPercent(0)
    }
    
    func handleGesture(recognizer:UIPanGestureRecognizer) {
        
        let translation = recognizer.translationInView(recognizer.view!.superview!)
        
        var progress = translation.x / menuWidth * (isOpening ? 1.0 : -1.0)
        progress = min(max(progress, 0.0), 1.0)
        
        switch recognizer.state {
        case .Began:
            let isOpen = floor(centerViewController.view.frame.origin.x/menuWidth)
            isOpening = isOpen == 1.0 ? false: true
            menuViewController.view.layer.shouldRasterize = true
            menuViewController.view.layer.rasterizationScale = UIScreen.mainScreen().scale
            
        case .Changed:
            self.setToPercent(isOpening ? progress: (1.0 - progress))
            
        case .Ended: fallthrough
        case .Cancelled: fallthrough
        case .Failed:
            
            self.menuViewController.view.layer.shouldRasterize = false
            
            var targetProgress: CGFloat
            if (isOpening) {
                targetProgress = progress < 0.5 ? 0.0 : 1.0
            } else {
                targetProgress = progress < 0.5 ? 1.0 : 0.0
            }
            
            UIView.animateWithDuration(animationTime, animations: {
                self.setToPercent(targetProgress)
                }, completion: { _ in
                    //
            })
            
        default: break
        }
    }
    
    func toggleSideMenu() {
        let isOpen = floor(centerViewController.view.frame.origin.x/menuWidth)
        let targetProgress: CGFloat = isOpen == 1.0 ? 0.0: 1.0
        
        UIView.animateWithDuration(animationTime, animations: {
            self.setToPercent(targetProgress)
            }, completion: { _ in
                self.menuViewController.view.layer.shouldRasterize = false
        })
    }
    
    func setToPercent(percent: CGFloat) {
        centerViewController.view.frame.origin.x = menuWidth * CGFloat(percent)
        menuViewController.view.layer.transform = menuTransformForPercent(percent)
        menuViewController.view.alpha = CGFloat(max(0.2, percent))
        
        let centerVC = (centerViewController as UINavigationController).viewControllers.first as? CenterViewController
        if var button = centerVC!.menuButton {
            var identity = CATransform3DIdentity
            identity.m34 = -1.0 / 10_000
            
            let rotationTransform = CATransform3DRotate(identity, percent * CGFloat(M_PI), 1.0, 1.0, 0.0)
            button.imageView.layer.transform = rotationTransform
        }
    }
    
    func menuTransformForPercent(percent: CGFloat) -> CATransform3D {
        var identity = CATransform3DIdentity
        identity.m34 = -1.0/10000
        
        let angle = (1.0 - percent) * -CGFloat(M_PI_2)
        
        let rotationTransform = CATransform3DRotate(identity, angle, 0.0, 1.0, 0.0)
        
        
        let translationTransform = CATransform3DMakeTranslation(menuWidth * percent, 0, 0)
        
        return CATransform3DConcat(rotationTransform, translationTransform)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}