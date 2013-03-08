//
//  NAViewController.h
//  NamesApp
//
//  Created by Long Vinh Nguyen on 3/3/13.
//  Copyright (c) 2013 home.vn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NAViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) NSArray *tableData;
@property (nonatomic, strong) UILocalizedIndexedCollation *collation;
@property (nonatomic, strong) NSMutableArray *outerArray;
@property (nonatomic, strong) NSArray *indexTitlesArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *filteredListContent;

- (void)configureSectionData;

@end
