//
//  CodeBaseEvenCell.m
//  CustomCell
//
//  Created by Long Vinh Nguyen on 3/6/13.
//  Copyright (c) 2013 home.vn. All rights reserved.
//

#import "CodeBaseEvenCell.h"

@implementation CodeBaseEvenCell
@synthesize cellTitle = _cellTitle, cellMainContent = _cellMainContent, cellOtherContent = _cellOtherContent, iconView = _iconView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *theBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ginham"]];
        self.backgroundView = theBackgroundView;
        
        // cellTitle label
        _cellTitle = [[UILabel alloc] init];
        _cellTitle.frame = CGRectMake(13, 13, 208, 32);
        _cellTitle.backgroundColor = [UIColor clearColor];
        _cellTitle.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:23];
        _cellTitle.textColor = [UIColor blackColor];
        
        // mainContent label
        _cellMainContent = [[UILabel alloc] init];
        _cellMainContent.frame = CGRectMake(110, 2, 147, 21);
        _cellMainContent.backgroundColor = [UIColor clearColor];
        _cellMainContent.font = [UIFont fontWithName:@"Baskerville-Italic" size:15];
        _cellMainContent.textColor = [UIColor blueColor];
        
        // otherContent label
        _cellOtherContent = [[UILabel alloc] init];
        _cellOtherContent.frame = CGRectMake(110, 26, 147, 21);
        _cellOtherContent.backgroundColor = [UIColor clearColor];
        _cellOtherContent.font = [UIFont fontWithName:@"Baskerville" size:15];
        _cellOtherContent.textColor = [UIColor blueColor];
        
        // iconView
        _iconView = [[UIImageView alloc] init];
        _iconView.frame = CGRectMake(265, 2, 45, 45);
        
        // set up content view
        [self.contentView addSubview:_cellTitle];
        [self.contentView addSubview:_cellMainContent];
        [self.contentView addSubview:_cellOtherContent];
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
