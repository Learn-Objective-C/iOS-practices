//
//  BNAppDelegate.h
//  BabyName
//
//  Created by Long Vinh Nguyen on 3/2/13.
//  Copyright (c) 2013 home.vn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BNName;

@class BNViewController;

@interface BNAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) BNViewController *viewController;

@property (strong, nonatomic) NSMutableArray *tableData;

- (BNName *)createNameWithNonsenseDataWithIndex:(int)index;

@end
