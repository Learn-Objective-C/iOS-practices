//
//  MenuButton.swift
//  OfficeCommunicator
//
//  Created by Marin Todorov on 8/24/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit

class MenuButton: UIView {
  
  var imageView: UIImageView!
  var tapHandler: (()->())?
  
  override func didMoveToSuperview() {
    frame = CGRect(x: 0, y: 0, width: 20, height: 20)
    
    imageView = UIImageView(image:UIImage(named:"menu"))
    imageView.userInteractionEnabled = true
    imageView.addGestureRecognizer(
      UITapGestureRecognizer(target: self, action: Selector("didTap")))
    addSubview(imageView)
  }
  
  func didTap() {
    if let tap = tapHandler {
      tap()
    }
  }
  
}