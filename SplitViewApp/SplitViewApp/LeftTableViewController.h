//
//  LeftTableViewController.h
//  SplitViewApp
//
//  Created by Long Vinh Nguyen on 3/10/13.
//  Copyright (c) 2013 home.vn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpdateSplitViewDetailViewDelegate.h"

@interface LeftTableViewController : UITableViewController

@property (nonatomic, weak) id<UpdateSplitViewDetailViewDelegate>delegate;

@end
