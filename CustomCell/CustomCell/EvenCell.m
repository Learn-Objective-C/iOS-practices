//
//  EvenCell.m
//  CustomCell
//
//  Created by Long Vinh Nguyen on 3/6/13.
//  Copyright (c) 2013 home.vn. All rights reserved.
//

#import "EvenCell.h"

@implementation EvenCell

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
    UIView *redView = [[UIView alloc] initWithFrame:self.selectedBackgroundView.frame];
    [redView setBackgroundColor:[UIColor redColor]];
    [self setSelectedBackgroundView:redView];

    // Configure the view for the selected state
}

@end
