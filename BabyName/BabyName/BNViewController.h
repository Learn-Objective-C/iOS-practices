//
//  BNViewController.h
//  BabyName
//
//  Created by Long Vinh Nguyen on 3/2/13.
//  Copyright (c) 2013 home.vn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *tableData;
@property (nonatomic, strong) NSMutableArray *selectedNames;
@property (strong, nonatomic) IBOutlet UITableView *theTableView;

@end
