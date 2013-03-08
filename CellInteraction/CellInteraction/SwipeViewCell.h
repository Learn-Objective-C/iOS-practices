//
//  SwipeView.h
//  CellInteraction
//
//  Created by Long Vinh Nguyen on 3/7/13.
//  Copyright (c) 2013 home.vn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeCellProtocol.h"

@interface SwipeViewCell : UITableViewCell

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *swipeView;

@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, assign) id<SwipeCellProtocol> delegate;

- (IBAction)didLeftSwipeCell:(id)sender;
- (IBAction)didRightSwipeInCell:(id)sender;



@end
