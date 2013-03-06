//
//  CodeBaseOddCell.m
//  CustomCell
//
//  Created by Long Vinh Nguyen on 3/6/13.
//  Copyright (c) 2013 home.vn. All rights reserved.
//

#import "CodeBaseOddCell.h"

@implementation CodeBaseOddCell
@synthesize cellTitle = _cellTitle, iconView = _iconView, cellContent =_cellContent;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *theBackGroundView =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"corkboard"]];
        [self setBackgroundView:theBackGroundView];
        
        // cellTitle Label
        _cellTitle = [[UILabel alloc] init];
        [_cellTitle setFrame:CGRectMake(93, 13, 208, 32)];
        [_cellTitle setBackgroundColor:[UIColor clearColor]];
        [_cellTitle setFont:[UIFont fontWithName:@"Futura-CondensedExtraBold" size:23]];
        [_cellTitle setTextColor:[UIColor blackColor]];
        
        // cellContent Label
        _cellContent = [[UILabel alloc] init];
        _cellContent.frame = CGRectMake(92, 42, 208, 21);
        _cellContent.backgroundColor = [UIColor clearColor];
        _cellContent.font = [UIFont fontWithName:@"Futura-Medium" size:13];
        _cellContent.textColor = [UIColor blackColor];
        
        // iconView
        _iconView = [[UIImageView alloc] init];
        _iconView.frame = CGRectMake(20, 17, 58, 36);

        // contentView
        [self.contentView addSubview:_cellTitle];
        [self.contentView addSubview:_cellContent];
        [self.contentView addSubview:_iconView];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    if (selected) {
        UIImageView *theSelectedView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bluePrint"]];
        self.selectedBackgroundView = theSelectedView;
        self.selectedBackgroundView.alpha = 0.8;
        [_cellTitle setTextColor:[UIColor redColor]];
    } else {
        self.selectedBackgroundView = nil;
        [_cellTitle setTextColor:[UIColor blackColor]];
    }
}

@end
