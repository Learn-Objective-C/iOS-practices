//
//  CustomCell.m
//  CellInteraction
//
//  Created by Long Vinh Nguyen on 3/7/13.
//  Copyright (c) 2013 home.vn. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell
@synthesize theLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIButton *theButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [theButton setFrame:CGRectMake(0, 0, 75, 30)];
        [theButton addTarget:self action:@selector(didTapButtonInCell) forControlEvents:UIControlEventTouchUpInside];
        self.accessoryView = theButton;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (!selected) {
        [theLabel setTextColor:[UIColor blackColor]];
    }
}

- (void)setIndexPath:(NSIndexPath *)theIndexPath
{
    _indexPath = theIndexPath;
    theLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, 200, 25)];
    [theLabel setFont:[UIFont systemFontOfSize:18]];
    [theLabel setText:[NSString stringWithFormat:@"Row %d",_indexPath.row]];
     
    [self.contentView addSubview:theLabel];
     UIButton *theButton = (UIButton *)self.accessoryView;
     [theButton setTitle:@"Tap me!" forState:UIControlStateNormal];
     
}

- (void)didTapButtonInCell
{
    NSString *messageString = [NSString stringWithFormat:@"Button at section %d row %d was tapped.",_indexPath.section, _indexPath.row];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Button Tapped!" message:messageString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
}












@end
