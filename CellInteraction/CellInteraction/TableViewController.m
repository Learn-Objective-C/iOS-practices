//
//  TableViewController.m
//  CellInteraction
//
//  Created by Long Vinh Nguyen on 3/6/13.
//  Copyright (c) 2013 home.vn. All rights reserved.
//

#import "TableViewController.h"
#import "CustomCell.h"
#import "PANASTableSliderCell.h"
#import "SwipeViewCell.h"

#define kCellIdentifier @"CellIdentifier"
#define kPANASTableSliderCell @"PANASTableSliderCellIdentifier"
#define kSwipeViewCell @"SwipeViewCellIdentifier"

@implementation TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _sliderNames = [[NSMutableArray alloc] init];
        _slideValues = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // set up sliderNames
    [_sliderNames addObject:@"Enthusiastic"];
    [_sliderNames addObject:@"Inspired"];
    [_sliderNames addObject:@"Nervous"];
    [_sliderNames addObject:@"Excited"];
    [_sliderNames addObject:@"Happy"];
    
    // set up slideValues
    [_slideValues addObject:[NSNumber numberWithFloat:0.0]];
    [_slideValues addObject:[NSNumber numberWithFloat:0.0]];
    [_slideValues addObject:[NSNumber numberWithFloat:0.0]];
    [_slideValues addObject:[NSNumber numberWithFloat:0.0]];
    [_slideValues addObject:[NSNumber numberWithFloat:0.0]];
    
    NSLog(@"Start %f %f",self.tableView.frame.origin.x, self.tableView.frame.origin.y);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _mainWindow = [[UIApplication sharedApplication] keyWindow];
    [_mainWindow setBackgroundColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 1) {
        return 2;
    } else if (section == 2) {
        return 8;
    }
    else return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if (indexPath.section == 2) {
        SwipeViewCell *swipeCell = [tableView dequeueReusableCellWithIdentifier:kSwipeViewCell];
        if (!swipeCell) {
            swipeCell = [[SwipeViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSwipeViewCell];
        }
    //}
    
//    if (indexPath.section == 1) {
//        PANASTableSliderCell *pCell = [[[NSBundle mainBundle] loadNibNamed:@"PANASTableSliderCell" owner:nil options:nil] objectAtIndex:0];
//        
//        // Configure slider
//        pCell.slider.tag = indexPath.row;
//        pCell.slider.minimumValue = 0.0;
//        pCell.slider.maximumValue = 4.0;
//        pCell.slider.continuous = NO;
//        [pCell.slider addTarget:self action:@selector(slideDidChange:) forControlEvents:UIControlEventValueChanged];
//        
//        [pCell.sliderLabel setText:[_sliderNames objectAtIndex:indexPath.row]];
//        [pCell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        
//        // Set slider value
//        pCell.slider.value = [[_slideValues objectAtIndex:indexPath.row] floatValue];
//        
//        // Return cell;
//        return pCell;
//        
//        
//    }
    
//        CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
//        if (!cell) {
//            cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
//            
//            // Create the UITapGestureRecognizer
//            UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTapCell:)];
//            [doubleTapRecognizer setNumberOfTapsRequired:2];
//            
//            // Add the gestureRecognizer to the cell
//            [cell addGestureRecognizer:doubleTapRecognizer];
//            
//        }
//        [cell setIndexPath:indexPath];
//
    
    [swipeCell setIndexPath:indexPath];
    [swipeCell setDelegate:self];
    
    
    return swipeCell;;
}


- (void) didTapButtonCell
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Something happened!" message:@"A button was tapped" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
}

- (void)slideDidChange: (id)sender
{
    UISlider *slider = (UISlider *)sender;
    
    // Figure out what the intValue of the slider is
    // and snap to nearest int
    int sliderIntValue = (int)slider.value;
    float sliderModValue = (float)sliderIntValue;

    if ((slider.value - sliderModValue) > 0.5) {
        sliderModValue ++;
    }
    
    slider.value = sliderModValue;
    [_slideValues replaceObjectAtIndex:slider.tag withObject:[NSNumber numberWithInt:sliderModValue]];
}

- (void)didDoubleTapCell:(UITapGestureRecognizer *)sender
{
    CustomCell *cell = (CustomCell *)sender.view;
    [cell.theLabel setTextColor:[UIColor greenColor]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    }
    return 44;
}

- (void)didSwipeRightInCellWithIndexPath:(NSIndexPath *)indexPath
{
    // Check if the newly-swiped cell is different to the currently
    // swiped cell - if it is, 'unswipe' it
    if ([_swipedCell compare:indexPath] != NSOrderedSame) {
        // Unswipe the currently swiped cell
        SwipeViewCell *currentlySwipeCell = (SwipeViewCell *)[self.tableView cellForRowAtIndexPath:_swipedCell];
        [currentlySwipeCell didLeftSwipeCell:self];
    }
    
    // Update the tableView controller's _swipeCell property
    _swipedCell = indexPath;
}

- (void)didSwipeLeftInCellWithIndexPath:(NSIndexPath *)indexPath
{
    // If the currently swiped cell has just been 'unswiped',
    // reset the _swipedCell property
    if ([_swipedCell compare:indexPath] == NSOrderedSame) {
        _swipedCell = nil;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_swipedCell) {
        SwipeViewCell *currentlySwipedCell = (SwipeViewCell *)[self.tableView cellForRowAtIndexPath:_swipedCell];
        [currentlySwipedCell didLeftSwipeCell:self];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    if (contentOffsetY < -60) {
        [self displayActivitySpinner];
    }
}

- (void)displayActivitySpinner
{
    _activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    [_activityView setBackgroundColor:[UIColor whiteColor]];
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_activityIndicator setFrame:CGRectMake(145, 20, 30, 30)];
    [_activityIndicator startAnimating];
    [_activityView addSubview:_activityIndicator];
    
    [_mainWindow addSubview:_activityView];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.tableView setFrame:CGRectMake(0, 60, self.tableView.frame.size.width, self.tableView.frame.size.height)];
        
    } completion:^(BOOL finished) {
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(removeActivitySpinner) userInfo:nil repeats:NO];
    }];
    
}

- (void)removeActivitySpinner
{
    [_activityIndicator stopAnimating];
    [_activityView removeFromSuperview];
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect currentTableRect = self.tableView.frame;
        NSLog(@"%f %f",currentTableRect.origin.x, currentTableRect.origin.y);
        [self.tableView setFrame:CGRectMake(currentTableRect.origin.x, currentTableRect.origin.y - 40, currentTableRect.size.width, currentTableRect.size.height)];
    }];
}





@end
