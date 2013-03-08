//
//  SwipeView.m
//  CellInteraction
//
//  Created by Long Vinh Nguyen on 3/7/13.
//  Copyright (c) 2013 home.vn. All rights reserved.
//

#import "SwipeViewCell.h"

@implementation SwipeViewCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSLog(@"self.contentView.width = %f",self.contentView.frame.size.width);
        
        // Create the top View
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 80)];
        [_topView setBackgroundColor:[UIColor whiteColor]];
        
        // Create the top label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 150, 40)];
        [label setFont:[UIFont fontWithName:@"Zapfino" size:18]];
        [label setTextColor:[UIColor blackColor]];
        [label setText:@"Swipe me!"];
        [_topView addSubview:label];
        
        // Create the top image
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mac-1"]];
        CGFloat imageXPosition = self.frame.size.width - 160;
        [image setFrame:CGRectMake(imageXPosition, 18, 50, 44)];
        [_topView addSubview:image];
        
        // Create the swipe view
        _swipeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 80)];
        [_swipeView setBackgroundColor:[UIColor darkGrayColor]];
        
        // Create the swipe label
        UILabel *haveSwipelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 200, 30)];
        [haveSwipelabel setBackgroundColor:[UIColor clearColor]];
        [haveSwipelabel setFont:[UIFont fontWithName:@"GillSans-Bold" size:18]];
        [haveSwipelabel setTextColor:[UIColor whiteColor]];
        [haveSwipelabel setText:@"I've been swiped"];
        [_swipeView addSubview:haveSwipelabel];
        
        // Add views to contentView
        [self.contentView addSubview:_swipeView];
        [self.contentView addSubview:_topView];
        
        // Create the gesture Recognizers
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didRightSwipeInCell:)];
        [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
        
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didLeftSwipeCell:)];
        [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        
        [self addGestureRecognizer:swipeRight];
        [self addGestureRecognizer:swipeLeft];
        
        // Prevent the hightlighting
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)didRightSwipeInCell:(id)sender
{
    NSLog(@"Right swipe start");
    [delegate didSwipeRightInCellWithIndexPath:_indexPath];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    // Swipe to view left
    [UIView animateWithDuration:1.0 animations:^{
        [_topView setFrame:CGRectMake(320, 0, self.contentView.frame.size.width, 80)];
    } completion:^(BOOL finished) {
        // Bounce the lower view
        [UIView animateWithDuration:0.15 animations:^{
            [_swipeView setFrame:CGRectMake(10, 0, self.contentView.frame.size.width, 80)];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                [_swipeView setFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 80)];
            }];
        }];
    }];
}

- (void)didLeftSwipeCell:(id)sender
{
    [delegate didSwipeLeftInCellWithIndexPath:_indexPath];
    NSLog(@"Left swipe start");
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView animateWithDuration:1.0 animations:^{
        [_topView setFrame:CGRectMake(-10, 0, self.contentView.frame.size.width, 80)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            [_topView setFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 80)];
        }];
    }];
}










@end
