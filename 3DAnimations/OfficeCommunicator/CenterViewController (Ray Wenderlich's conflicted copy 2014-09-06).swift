//
//  CenterViewController.swift
//  OfficeCommunicator
//
//  Created by David Grandinetti on 8/8/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit

class CenterViewController: UIViewController {
  
  var menuItem: MenuItem! {
    didSet {
      title = menuItem.name
      view.backgroundColor = menuItem.color
      menuItemView?.image = menuItem.mainImage
    }
  }
  
  @IBOutlet var menuItemView:UIImageView?
  
  // MARK: ViewController
  
  var menuButton: MenuButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    menuButton = MenuButton()
    menuButton.tapHandler = {
      if let containerVC = self.navigationController?.parentViewController as? ContainerViewController {
        containerVC.toggleSideMenu()
      }
    }
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
    
    menuItem = MenuItem.sharedItems.first!
  }

}