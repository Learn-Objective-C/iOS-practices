//
//  ViewController.swift
//  shape-mutation
//
//  Created by Marin Todorov on 8/6/14.
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

class ViewController: UIViewController {

  let arialRounded = UIFont(name: "ArialRoundedMTBold", size: 36.0)
  
  @IBOutlet var myAvatar: AvatarView!
  @IBOutlet var opponentAvatar: AvatarView!
  
  @IBOutlet var status: UILabel!
  @IBOutlet var vs: UILabel!
  @IBOutlet var searchAgain: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //initial setup
    myAvatar.name = "Me"
    myAvatar.image = UIImage(named: "avatar-1")
    
    status.font = arialRounded
    vs.font = arialRounded
    searchAgain.titleLabel!.font = arialRounded
    
    vs.alpha = 0
    searchAgain.alpha = 0
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    searchForOpponent()
    
  }
    
    func searchForOpponent() {
//        let bounceXOffset:CGFloat = 46.0
//        let leftBouncePoint = CGPoint(x: 160.0 + bounceXOffset, y: myAvatar.center.y)
//        myAvatar.bounceOffPoint(leftBouncePoint, morphSize: CGSize(width: 75, height: 100))
//        let rightBouncePoint = CGPoint(x: 160.0 - bounceXOffset, y: myAvatar.center.y)
//        opponentAvatar.bounceOffPoint(rightBouncePoint, morphSize: CGSize(width: 75, height: 100))
        myAvatar.animateToSquare()
        opponentAvatar.animateToSquare()
    }
      
  @IBAction func actionSearchAgain() {
    UIApplication.sharedApplication().keyWindow!.rootViewController = storyboard?.instantiateViewControllerWithIdentifier("ViewController") as UIViewController
  }
}

