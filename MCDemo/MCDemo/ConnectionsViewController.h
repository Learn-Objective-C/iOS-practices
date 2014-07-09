//
//  ConnectionsViewController.h
//  MCDemo
//
//  Created by Long Vinh Nguyen on 5/7/14.
//  Copyright (c) 2014 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectionsViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITableView *tblConnectedDevices;
@property (nonatomic, weak) IBOutlet UIButton *btnDisconnect;


- (IBAction)browseForDevices:(id)sender;
- (IBAction)disconnect:(id)sender;

@end
