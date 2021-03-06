//
//  ViewController.swift
//  basic-uiview-animations
//
//  Created by Marin Todorov on 8/11/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit

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

      loginButton.layer.cornerRadius = 8.0
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
      
      //add the status label
      label.frame = CGRect(x: 0, y: 0, width: status.frame.size.width, height: status.frame.size.height)
      label.font = UIFont(name: "HelveticaNeue", size: 18.0)
      label.textColor = UIColor(red: 228.0/255.0, green: 98.0/255.0, blue: 0.0, alpha: 1.0)
      label.textAlignment = .Center
      status.addSubview(label)
    }

    override func viewWillAppear(animated: Bool) {
      super.viewWillAppear(animated)
      
      heading.center.x -= view.bounds.width
      username.center.x -= view.bounds.width
      password.center.x -= view.bounds.width
      loginButton.center.y += 30.0
      loginButton.alpha = 0.0

    }
  
    override func viewDidAppear(animated: Bool) {
      super.viewDidAppear(animated)
      
      //animate form
      UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
        self.heading.center.x += self.view.bounds.width
        }, completion: nil)
      UIView.animateWithDuration(0.5, delay: 0.3, options: .CurveEaseOut, animations: {
        self.username.center.x += self.view.bounds.width
        }, completion: nil)
      UIView.animateWithDuration(0.5, delay: 0.4, options: .CurveEaseOut, animations: {
        self.password.center.x += self.view.bounds.width
        }, completion: nil)
      UIView.animateWithDuration(0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: nil, animations: {
        self.loginButton.center.y -= 30.0
        self.loginButton.alpha = 1.0
        }, completion: nil)

      animateCloud(self.cloud1);
      animateCloud(self.cloud2);
      animateCloud(self.cloud3);
      animateCloud(self.cloud4);

    }
  
    @IBAction func login() {
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
        
        self.loginButton.backgroundColor = UIColor(red: 217.0/255.0, green: 211.0/255.0, blue: 114.0/255.0, alpha: 1.0)
        
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
    
    UIView.animateWithDuration(0.33, delay: 0.0, options: nil, animations: {
      
      self.spinner.center = CGPoint(x: -20, y: 16)
      self.spinner.alpha = 0.0
      self.loginButton.backgroundColor = UIColor(red: 160.0/255.0, green: 214.0/255.0, blue: 90.0/255.0, alpha: 1.0)
      
      }, completion: {_ in
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: nil, animations: {
          let b = self.loginButton.bounds
          self.loginButton.bounds = CGRect(x: b.origin.x + 20, y: b.origin.y, width: b.size.width - 80, height: b.size.height)
          }, completion:nil)
        
    })
    
  }

  func animateCloud(cloud: UIImageView) {
    //animate clouds
    let cloudSpeed = 20.0 / Double(view.frame.size.width)
    let duration: NSTimeInterval = Double(view.frame.size.width - cloud.frame.origin.x) * cloudSpeed
    
    UIView.animateWithDuration(duration, delay: 0.0, options: .CurveLinear, animations: {
      //move cloud to right edge
      cloud.frame.origin.x = self.view.bounds.size.width
      }, completion: {_ in
        //reset cloud
        cloud.frame.origin.x = -self.cloud1.frame.size.width
        self.animateCloud(cloud);
    });
  }

}

