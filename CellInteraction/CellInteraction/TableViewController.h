//
//  TableViewController.h
//  CellInteraction
//
//  Created by Long Vinh Nguyen on 3/6/13.
//  Copyright (c) 2013 home.vn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeCellProtocol.h"

@interface TableViewController : UITableViewController<SwipeCellProtocol>

@property (nonatomic, strong) NSMutableArray *sliderNames;
@property (nonatomic, strong) NSMutableArray *slideValues;

@property (nonatomic, strong) NSIndexPath *swipedCell;

@property (nonatomic, strong) UIWindow *mainWindow;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIView *activityView;

- (void)displayActivitySpinner;
- (void)removeActivitySpinner;

@end
