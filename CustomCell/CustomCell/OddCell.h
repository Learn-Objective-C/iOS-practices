//
//  OddCell.h
//  CustomCell
//
//  Created by Long Vinh Nguyen on 3/5/13.
//  Copyright (c) 2013 home.vn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OddCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *backView;
@property (nonatomic, strong) IBOutlet UIImageView *iconView;
@property (nonatomic, strong) IBOutlet UILabel *cellTitle;
@property (nonatomic, strong) IBOutlet UILabel *cellContent;

@end
