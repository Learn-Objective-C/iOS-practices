//
//  LVNViewController.h
//  IndexedTable
//
//  Created by Long Vinh Nguyen on 3/3/13.
//  Copyright (c) 2013 home.vn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LVNViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *tableData;
@property (nonatomic, strong) NSArray *indexTitlesArray;

@end
