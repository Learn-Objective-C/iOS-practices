//
//  EvenCell.h
//  CustomCell
//
//  Created by Long Vinh Nguyen on 3/6/13.
//  Copyright (c) 2013 home.vn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvenCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *backView;
@property (nonatomic, strong) IBOutlet UIImageView *iconView;
@property (nonatomic, strong) IBOutlet UILabel *cellTitle;
@property (nonatomic, strong) IBOutlet UILabel *cellMainContent;
@property (nonatomic, strong) IBOutlet UILabel *cellOtherContent;

@end
