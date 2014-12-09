//
//  ViewController.swift
//  basic-uiview-animations
//
//  Created by Marin Todorov on 8/11/14.
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
    
    // MARK: ui outlets
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var heading: UILabel!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    
    @IBOutlet var cloud1: UIImageView!
    @IBOutlet var cloud2: UIImageView!
    @IBOutlet var cloud3: UIImageView!
    @IBOutlet var cloud4: UIImageView!
    
    // MARK: further ui
    
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    
    let status = UIImageView(image: UIImage(named: "banner"))
    let label = UILabel()
    let messages = ["Connecting ...", "Authorization ...", "Sending credentials ...", "Failed"]
    
    // MARK: view controller lifecycle
    
    override func viewDidLoad() {
      super.viewDidLoad()

      loginButton.layer.cornerRadius = 10.0
      loginButton.layer.masksToBounds = true
      
      //add the button spinner
      spinner.frame = CGRect(x: -20, y: 6, width: 20, height: 20)
      spinner.startAnimating()
      spinner.alpha = 0.0
      loginButton.addSubview(spinner)

      //add the status banner
      status.hidden = true
      status.center = loginButton.center
      view.addSubview(status)
        
        status.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: "didTapStatus")
        status.addGestureRecognizer(tap)
      
      //add the status label
      label.frame = CGRect(x: 0, y: 0, width: status.frame.size.width, height: status.frame.size.height)
      label.font = UIFont(name: "HelveticaNeue", size: 18.0)
      label.textColor = UIColor(red: 228.0/255.0, green: 98.0/255.0, blue: 0.0, alpha: 1.0)
      label.textAlignment = .Center
      status.addSubview(label)
    }

    override func viewWillAppear(animated: Bool) {
      super.viewWillAppear(animated)
      
      username.layer.position.x -= view.bounds.width
      password.layer.position.x -= view.bounds.width
    }
  
    override func viewDidAppear(animated: Bool) {
      super.viewDidAppear(animated)
      
      //animate form
      let flyRight = CABasicAnimation(keyPath: "position.x")
        flyRight.fromValue = -view.bounds.size.width/2
        flyRight.toValue = view.bounds.size.width/2
        flyRight.duration = 0.5
        heading.layer.addAnimation(flyRight, forKey: nil)
        
        flyRight.delegate = self
        flyRight.setValue("form", forKey: "name")
        flyRight.setValue(username.layer, forKey: "layer")
        
        flyRight.beginTime = CACurrentMediaTime() + 0.3
        username.layer.addAnimation(flyRight, forKey: nil)
        
        flyRight.setValue(password.layer, forKey: "layer")
        flyRight.beginTime = CACurrentMediaTime() + 0.4
        password.layer.addAnimation(flyRight, forKey: nil)
        
        let loginButtonAnimation = CAKeyframeAnimation(keyPath: "position")
        loginButtonAnimation.duration = 1.5
        loginButtonAnimation.values = [
            NSValue(CGPoint: CGPoint(x: -view.bounds.size.width / 2, y: loginButton.layer.position.y + 100)),
            NSValue(CGPoint: CGPoint(x: view.bounds.size.width / 2, y: loginButton.layer.position.y + 100)),
            NSValue(CGPoint: CGPoint(x: view.bounds.size.width / 2, y: loginButton.layer.position.y))
        ]
        loginButtonAnimation.keyTimes = [0.0, 0.5, 1.0]
        loginButtonAnimation.additive = false
        loginButton.layer.addAnimation(loginButtonAnimation, forKey: nil)
        
        

      animateCloud(self.cloud1);
      animateCloud(self.cloud2);
      animateCloud(self.cloud3);
      animateCloud(self.cloud4);

    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        let nameValue = anim.valueForKey("name") as? String
        
        if let name = nameValue {
            if name == "form" {
                let layer:CALayer = anim.valueForKey("layer")! as CALayer
                layer.position.x = view.bounds.size.width/2
                layer.setValue(nil, forKey: "layer")
            } else if name == "loginButton" {
                loginButton.layer.position.y -= 100
                loginButton.layer.opacity = 1
            } else if name == "cloud" {
                let cloud = anim.valueForKey("view") as UIImageView
                cloud.frame.origin.x = -self.cloud1.frame.width
                delay(seconds: 0.1, { () -> () in
                    self.animateCloud(cloud)
                })
                
            }
        }
    }
    
    func tintBackgroundColor(layer:CALayer, toColor: UIColor) {
        let tint = CABasicAnimation(keyPath: "backgroundColor")
        tint.toValue = toColor.CGColor
        tint.duration = 1.5
        tint.fillMode = kCAFillModeForwards
        layer.addAnimation(tint, forKey: nil)
        layer.backgroundColor = toColor.CGColor
    }
    
    func roundedCorner(layer:CALayer, toRadius: CGFloat) {
        let roundRect = CABasicAnimation(keyPath: "cornerRadius")
        roundRect.toValue = toRadius
        roundRect.duration = 1.0
        roundRect.fillMode = kCAFillModeForwards
        roundRect.removedOnCompletion = false
        layer.addAnimation(roundRect, forKey: nil)
        layer.cornerRadius = toRadius
    }
  
    @IBAction func login() {
        
        tintBackgroundColor(loginButton.layer, toColor: UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0))
        roundedCorner(loginButton.layer, toRadius: 25.0)
        
      //enlarge
      UIView.animateWithDuration(1.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 20, options: nil, animations: {
        let b = self.loginButton.bounds
        self.loginButton.bounds = CGRect(x: b.origin.x - 20, y: b.origin.y, width: b.size.width+80, height: b.size.height)
        }, completion: {_ in
          
      })
      
      //move away the button
      UIView.animateWithDuration(0.33, delay: 0.0, options: .CurveEaseOut, animations: {
        if self.status.hidden {
          self.loginButton.center.y += 60
        }
        self.spinner.center = CGPoint(x: 40, y: self.loginButton.frame.size.height/2)
        self.spinner.alpha = 1.0
        }, completion: {_ in
          self.showMessages(index: 0)
      })

    }
  
  func showMessages(#index: Int) {
    
    let labelOriginalFrame = self.status.frame
    
    //move away old label
    UIView.animateWithDuration(0.33, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: nil, animations: {
      
      self.status.center.x += self.view.frame.size.width
      
      }, completion: {_ in
        
        self.status.hidden = true
        self.status.frame = labelOriginalFrame
        self.label.text = self.messages[index]
        
        UIView.transitionWithView(self.status, duration: 0.33, options: .CurveEaseOut | .TransitionFlipFromBottom, animations: {
          self.status.hidden = false
          }, completion: {_ in
            
            delay(seconds: 2.0) {
              if index < self.messages.count-1 {
                self.showMessages(index: index+1)
              } else {
                self.resetButton()
              }
            }
        })
        
    })
  }

  func resetButton() {
    
    tintBackgroundColor(loginButton.layer, toColor: UIColor(red: 160.0/255.0, green: 214.0/255.0, blue: 90.0/255.0, alpha: 1.0))
    roundedCorner(loginButton.layer, toRadius: 10.0)
    UIView.animateWithDuration(0.33, delay: 0.0, options: nil, animations: {
      
      self.spinner.center = CGPoint(x: -20, y: 16)
      self.spinner.alpha = 0.0
      
      }, completion: {_ in
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: nil, animations: {
          let b = self.loginButton.bounds
          self.loginButton.bounds = CGRect(x: b.origin.x + 20, y: b.origin.y, width: b.size.width - 80, height: b.size.height)
          }, completion:nil)
        
    })
    
    let bounce = CAKeyframeAnimation(keyPath: "transform.rotation.z")
    bounce.values = [0.0, -M_PI_4/2, M_PI_4/2, 0.0]
    bounce.keyTimes = [0.0, 0.33, 0.67, 1.0]
    bounce.additive = true
    bounce.repeatCount = HUGE
    status.layer.addAnimation(bounce, forKey: "wobble")
    
  }

  func animateCloud(cloud: UIImageView) {
    //animate clouds
    cloud.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
    let cloudSpeed = 20.0 / Double(view.frame.size.width)
    let duration: NSTimeInterval = Double(view.frame.size.width - cloud.frame.origin.x) * cloudSpeed
    
    let cloudAnimation = CABasicAnimation(keyPath: "position.x")
    cloudAnimation.duration = duration
    cloudAnimation.toValue = self.view.bounds.width
    cloudAnimation.setValue("cloud", forKey: "name")
    cloudAnimation.setValue(cloud, forKey: "view")
    cloudAnimation.delegate = self
    cloud.layer.addAnimation(cloudAnimation, forKey: nil)
  }

    func didTapStatus() {
        if let wobble = status.layer.animationForKey("wobble") {
            status.layer.removeAnimationForKey("wobble")
        }
    }
    
}

