//
//  BNViewController.m
//  BabyName
//
//  Created by Long Vinh Nguyen on 3/2/13.
//  Copyright (c) 2013 home.vn. All rights reserved.
//

#import "BNViewController.h"
#import "BNName.h"
#import "BNDetailViewController.h"
#import "BNCell.h"
#import <QuartzCore/QuartzCore.h>

static NSString *cellIndentifier = @"BNCell";

@interface BNViewController()

@property (nonatomic, weak) UITableViewHeaderFooterView *headerView;

@end

@implementation BNViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Baby Names";
	// Do any additional setup after loading the view, typically from a nib.
    UINib *nib = [UINib nibWithNibName:@"BNCellandHeader" bundle:nil];
    [_theTableView registerNib:nib forCellReuseIdentifier:cellIndentifier];
    
    // [_theTableView registerClass:[[nib instantiateWithOwner:nil options:nil][0] class] forCellReuseIdentifier:cellIndentifier];
    
    //[_theTableView registerClass:[[nib instantiateWithOwner:nil options:nil][1] class] forHeaderFooterViewReuseIdentifier:@"BNHeaderView"];

    
    
    _selectedNames = [NSMutableArray arrayWithCapacity:10];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tableData) {
        if (section == 0) {
            return _selectedNames.count;
        }
        return [self.tableData count];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    BNCell *cell = [[NSBundle mainBundle] loadNibNamed:@"BNCellandHeader" owner:nil options:nil][0];
    
    if (!cell) {
        cell = [[BNCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    
    BNName *tempName = nil;
    
    if (indexPath.section == 0) {
        tempName = self.selectedNames[indexPath.row];
        [cell.checkBox setSelected:YES];
    } else {
        tempName = self.tableData[indexPath.row];
    }
    
    
    // Update the cell's textLabel
    [cell.title setText: tempName.nameText];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Select Row: %d",indexPath.row);
//    BNDetailViewController *detailViewController = [[BNDetailViewController alloc] initWithNibName:@"BNDetailViewController" bundle:nil];
//    [detailViewController setBNName:[self.tableData objectAtIndex:[indexPath row]]];
//    [self.navigationController pushViewController:detailViewController animated:YES];

    /* BabyName
    if (indexPath.section == 1) {
        NSString *selectedName = self.tableData[indexPath.row];
        if (![_selectedNames containsObject:selectedName] && _selectedNames.count < 10) {
            [_selectedNames addObject:selectedName];
            [tableView beginUpdates];
            [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(_selectedNames.count - 1) inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            [tableView endUpdates];
        }
    } else {
        NSString *selectedName = self.selectedNames[indexPath.row];
        [_selectedNames removeObject:selectedName];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        [tableView endUpdates];
    }
    UILabel *title = (UILabel *)[_headerView viewWithTag:1000];
    CABasicAnimation *mover = [CABasicAnimation animationWithKeyPath:@"position"];
    [mover setDuration:1.0f];
    mover.delegate = self;
    CGPoint destination = CGPointMake(200, title.center.y);
    [mover setDuration:1.0f];
    [mover setToValue:[NSValue valueWithCGPoint:destination]];
    [title.layer addAnimation:mover forKey:@"MoveTitle"];
     */
    
    //[title.layer setPosition:destination];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.tinhte.vn"]];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSIndexPath *selectedIndexPath = [self.theTableView indexPathForSelectedRow];
    
    [self.theTableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return @"Selected Names";
//    }
//    return @"Names";
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _headerView = [[NSBundle mainBundle] loadNibNamed:@"BNCellandHeader" owner:nil options:nil][1];
    UILabel *title = (UILabel *)[_headerView viewWithTag:1000];
    UILabel *capacity = (UILabel *)[_headerView viewWithTag:1010];
    UIImageView *imageView = (UIImageView *)[_headerView viewWithTag:1020];
    if (section == 0) {
//        CGRect rect = CGRectMake(100, 10, title.bounds.size.width, title.bounds.size.height);
        [UIView animateWithDuration:0.5 animations:^(){
            
        }];
        title.text = @"Selected Names";
        capacity.text = [NSString stringWithFormat:@"%d/10",self.selectedNames.count];
        imageView.image = nil;
    } else title.text = @"Names";
    return _headerView;
}











@end
