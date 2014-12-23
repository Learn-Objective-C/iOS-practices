//
//  DetailViewController.swift
//  push-transition-logo
//
//  Created by Marin Todorov on 8/9/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit
import QuartzCore

class DetailViewController: UITableViewController {
    
    let maskLayer: CAShapeLayer = RWLogoLayer.logoLayer()
    let transition = TransitionController()
    var isInteractive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pack List"
        tableView.rowHeight = 54.0
        
        maskLayer.position = CGPoint(x: view.layer.bounds.size.width / 2, y: view.layer.bounds.size.height / 2)
        view.layer.mask = maskLayer
        
        navigationController?.delegate = self
        
        // add pan gesture didPan
        let pan = UIPanGestureRecognizer(target: self, action: "didPan:")
        view.addGestureRecognizer(pan)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        view.layer.mask = nil
    }
    
    // MARK: Table View methods
    let packItems = ["Icecream money", "Great weather", "Beach ball", "Swim suit for him", "Swim suit for her", "Beach games", "Ironing board", "Cocktail mood", "Sunglasses", "Flip flops"]
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        cell.accessoryType = .None
        cell.textLabel!.text = packItems[indexPath.row]
        cell.imageView!.image = UIImage(named: "summericons_100px_0\(indexPath.row).png")
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func didPan(recognizer: UIPanGestureRecognizer) {
        if transition.animating {
            return
        }
        
        if recognizer.state == .Began {
            isInteractive = true
            navigationController?.popViewControllerAnimated(true)
        } else {
            isInteractive = false
        }
        
        transition.handlePan(recognizer)
    }
    
}

extension DetailViewController : UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .Pop {
            transition.operation = operation
            return transition
        } else {
            return nil
        }
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if (isInteractive && transition.animating == false) {
            return transition
        } else {
            return nil
        }
    }
}
