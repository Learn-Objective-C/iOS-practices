//
//  MasterViewController.h
//  TextKitMagazine
//
//  Created by Colin Eberhardt on 02/07/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookViewController;

@interface ChaptersViewController : UITableViewController

@property (strong, nonatomic) BookViewController *bookViewController;


@end
