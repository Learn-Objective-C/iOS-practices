//
//  SwipeCellProtocol.h
//  CellInteraction
//
//  Created by Long Vinh Nguyen on 3/8/13.
//  Copyright (c) 2013 home.vn. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SwipeCellProtocol <NSObject>

- (void)didSwipeRightInCellWithIndexPath: (NSIndexPath *)indexPath;
- (void)didSwipeLeftInCellWithIndexPath: (NSIndexPath *)indexPath;

@end
