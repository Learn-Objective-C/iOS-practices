//
//  SideMenuViewController.swift
//  OfficeCommunicator
//
//  Created by David Grandinetti on 8/8/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit

class SideMenuViewController: UITableViewController {

  var centerViewController: CenterViewController!
  let imageTag = 6
  
  // MARK: UITableViewDataSource
  
  override func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
    return MenuItem.sharedItems.count
  }
  
  override func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {

    var cell = (tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath:indexPath) as? UITableViewCell)!

    let menuItem = MenuItem.sharedItems[indexPath.row]
    cell.contentView.backgroundColor = menuItem.color
    (cell.viewWithTag(imageTag) as UIImageView).image = menuItem.sideMenuImage

    return cell
  }
  
  override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView  {
    return tableView.dequeueReusableCellWithIdentifier("HeaderCell") as UIView
  }
  
  // MARK: UITableViewDelegate
  
  override func tableView(tableView:UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated:true)
    
    centerViewController.menuItem = MenuItem.sharedItems[indexPath.row]
    
    let containerVC = parentViewController as ContainerViewController
    containerVC.toggleSideMenu()
  }
  
  override func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath) -> CGFloat {
    return 84
  }
  
  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 64
  }
}