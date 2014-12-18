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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Pack List"
    tableView.rowHeight = 54.0
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
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
    
}
