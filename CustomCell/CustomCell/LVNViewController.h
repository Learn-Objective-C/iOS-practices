//
//  LVNViewController.h
//  CustomCell
//
//  Created by Long Vinh Nguyen on 3/5/13.
//  Copyright (c) 2013 home.vn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LVNViewController : UITableViewController

@property (nonatomic, strong) NSArray *phraseData;
@property (nonatomic, strong) NSMutableArray *tableData;

- (void)populateTableData;

@end
