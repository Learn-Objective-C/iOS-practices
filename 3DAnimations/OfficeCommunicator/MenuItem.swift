//
//  MenuItem.swift
//  OfficeCommunicator
//
//  Created by David Grandinetti on 8/8/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit

extension UIColor {
  class func smileColor() -> UIColor {
    return UIColor(red: 249/255, green: 84/255, blue: 7/255, alpha: 1)
  }
  class func coffeeColor() -> UIColor {
    return UIColor(red: 69/255, green: 59/255, blue: 55/255, alpha: 1)
  }
  class func drinksColor() -> UIColor {
    return UIColor(red: 249/255, green: 194/255, blue: 7/255, alpha: 1)
  }
  class func thumbsUpColor() -> UIColor {
    return UIColor(red: 32/255, green: 188/255, blue: 32/255, alpha: 1)
  }
  class func thumbsDownColor() -> UIColor {
    return UIColor(red: 207/255, green: 34/255, blue: 156/255, alpha: 1)
  }
  class func rainingColor() -> UIColor {
    return UIColor(red: 14/255, green: 88/255, blue: 149/255, alpha: 1)
  }
  class func clockColor() -> UIColor {
    return UIColor(red: 15/255, green: 193/255, blue: 231/255, alpha: 1)
  }
}

class MenuItem {
  let name :String
  let color: UIColor

  init(name: String, color: UIColor) {
    self.name = name
    self.color = color
  }
  
  var sideMenuImage: UIImage {
    return UIImage(named: name)!
  }
  
  var mainImage: UIImage {
    return UIImage(named: name + "_big")!
  }
  
  class var sharedItems: [MenuItem] {
    struct Static {
      static let items = sharedMenuItems()
    }
    return Static.items
  }
}

private func sharedMenuItems() -> [MenuItem] {
  var items = [MenuItem]()

  items.append(MenuItem(name: "smile",       color: UIColor.smileColor()))
  items.append(MenuItem(name: "coffee",      color: UIColor.coffeeColor()))
  items.append(MenuItem(name: "drinks",      color: UIColor.drinksColor()))
  items.append(MenuItem(name: "thumbs_up",   color: UIColor.thumbsUpColor()))
  items.append(MenuItem(name: "thumbs_down", color: UIColor.thumbsDownColor()))
  items.append(MenuItem(name: "raining",     color: UIColor.rainingColor()))
  items.append(MenuItem(name: "clock",       color: UIColor.clockColor()))
  
  return items
}

