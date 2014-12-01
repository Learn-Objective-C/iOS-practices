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
        loginButton.alpha = 0
        
        cloud1.center.x -= view.bounds.width
        cloud2.center.x -= view.bounds.width
        cloud3.center.x -= view.bounds.width
        cloud4.center.x -= view.bounds.width
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(4.0, delay: 0, options: nil, animations: {
            self.cloud1.center.x += self.view.bounds.width
            self.cloud2.center.x += self.view.bounds.width
            self.cloud3.center.x += self.view.bounds.width
            self.cloud4.center.x += self.view.bounds.width
        }, completion: nil)
        
        UIView.animateWithDuration(1.0, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.heading.center.x += self.view.bounds.size.width
        }, completion: nil)
        
        UIView.animateWithDuration(1.0, delay: 0.3, options: .CurveEaseInOut, animations: { () -> Void in
            self.username.center.x += self.view.bounds.size.width
            }, completion: nil)
        
        UIView.animateWithDuration(1.0, delay: 0.4, options: .CurveEaseInOut, animations: { () -> Void in
            self.password.center.x += self.view.bounds.size.width
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0.5, usingSpringWithDamping: 0.05, initialSpringVelocity: 0, options: nil, animations: {
            self.loginButton.center.y -= 30
            self.loginButton.alpha = 1.0
        }, completion: nil)
    }
    
    @IBAction func login() {
        let b = self.loginButton.bounds
        
        UIView.animateWithDuration(1.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 20, options: nil, animations: {
            self.loginButton.bounds = CGRect(x: b.origin.x - 20, y: b.origin.y, width: b.size.width + 80, height: b.size.height)
            }, completion: {
                _ in
                //
                self.showMessages(0)
        })
        
        UIView.animateWithDuration(0.33, delay: 0, options: .CurveEaseOut, animations: {
            self.loginButton.center.y += 60
            self.spinner.alpha = 1
            self.spinner.center = CGPoint(x: 40, y: self.loginButton.frame.height / 2)
        }, completion: nil)
    }
    
    func showMessages(index:Int) {
        UIView.animateWithDuration(0.33, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: nil, animations: { () -> Void in
            self.status.center.x += self.view.bounds.size.width
            }, completion: {
                _ in
                self.status.hidden = true
                self.status.center.x -=  self.view.bounds.size.width
                self.label.text = self.messages[index]
                
                UIView.transitionWithView(self.status, duration: 0.3, options: .CurveEaseOut | UIViewAnimationOptions.TransitionCurlDown, animations: {
                    self.status.hidden = false
                    }, completion: {_ in
                    
                        delay(seconds: 2.0, { () -> () in
                            if index < self.messages.count - 1 {
                                self.showMessages(index + 1)
                            } else {
                                self.resetButton()
                            }
                        })
                        
                })
        })
    }
    
    func resetButton() {
        UIView.animateWithDuration(0.5, delay: 0, options: nil, animations: {
            self.spinner.alpha = 0
            self.spinner.center = CGPoint(x: -20, y: 16)
            self.loginButton.backgroundColor = UIColor(red: 160/255.0, green: 214/255.0, blue: 90/255.0, alpha: 1)
            }, completion: {
                _ in

                UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 20, options: nil, animations: {
                    let b = self.loginButton.bounds
                    self.loginButton.bounds = CGRectMake(b.origin.x + 20, b.origin.y, b.width - 80, b.height)
                    }, completion: {
                        _ in
                        
                })
        })
    }
    
}

