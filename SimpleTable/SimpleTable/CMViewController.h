//
//  CMViewController.h
//  SimpleTable
//
//  Created by Long Vinh Nguyen on 3/2/13.
//  Copyright (c) 2013 home.vn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *tableData; // holds the table data
@property (nonatomic) int cellCount;

@end
