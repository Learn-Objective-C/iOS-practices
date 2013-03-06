//
//  OddCell.m
//  CustomCell
//
//  Created by Long Vinh Nguyen on 3/5/13.
//  Copyright (c) 2013 home.vn. All rights reserved.
//

#import "OddCell.h"

@implementation OddCell
@synthesize backView = _backView, iconView = _iconView, cellTitle = _cellTitle, cellContent = _cellContent;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
