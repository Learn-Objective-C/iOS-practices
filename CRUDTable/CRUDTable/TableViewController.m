//
//  TableViewController.m
//  CRUDTable
//
//  Created by Long Vinh Nguyen on 3/3/13.
//  Copyright (c) 2013 home.vn. All rights reserved.
//

#import "TableViewController.h"

static NSString *cellIdentifier;
@implementation TableViewController
@synthesize tableData;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.navigationItem setTitle:@"Row insertion"];
    [self.navigationItem setRightBarButtonItem:self.editButtonItem];
    
    self.tableData = [[NSMutableArray alloc] initWithObjects:@"One", @"Two", @"Three" , @"Four", @"Five" ,nil];
    cellIdentifier = @"cellIdentifier";
    [self.tableView registerNib:[UINib nibWithNibName:@"CRUDTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static const int kLabel = 1010;
    static const int kImage = 1020;
    static const int kImageBackground = 1030;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //if (!cell) {
        // cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
      //  UINib *nib = [UINib nibWithNibName:@"CRUDTableViewCell" bundle:nil];
        //cell = [[nib instantiateWithOwner:self options:0] objectAtIndex:0];
        
        // Create a custom cell
//        UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 10, 200, 25)];
//        [myLabel setTag:kLabel];
//        
//        // Add the new label to the content View
//        [cell.contentView addSubview:myLabel];
//        
//        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 25)];
//        [myImageView setTag:kImage];
        
        //[cell.contentView addSubview:myImageView];
   // }
    
    UIImageView *myImageView = (UIImageView *)[cell viewWithTag:kImage];
    [myImageView setImage:[UIImage imageNamed:@"mac_blue_flowers"]];
    
    UIImageView *myBackgroundView = (UIImageView *)[cell viewWithTag:kImageBackground];
    [myBackgroundView setImage:[UIImage imageNamed:@"animation_bg"]];

    
    UILabel *myLabel = (UILabel *)[cell viewWithTag:kLabel];
    
    
    
    if (indexPath.row == [self.tableData count]) {
        [myLabel setText:@"Add new row"];
        [myLabel setTextColor:[UIColor darkGrayColor]];
    } else
        [myLabel setText:[tableData objectAtIndex:indexPath.row]];
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editing) {
        if (indexPath.row == [self.tableData count]) {
            return UITableViewCellEditingStyleInsert;
        } else
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *indexPathArray = [NSArray arrayWithObject:indexPath];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.tableData removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationLeft];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        NSString *theObjectToInsert = [NSString stringWithFormat:@"%@", [NSDate date]];
        [self.tableData addObject:theObjectToInsert];
        [tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.tableData count]) {
        [self setEditing:YES animated:YES];
    } else {
        
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.tableData count]) {
        return NO;
    }
    return YES;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (proposedDestinationIndexPath.row == [self.tableData count]) {
        return sourceIndexPath;
    }
    else return proposedDestinationIndexPath;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSString *temp = [self.tableData objectAtIndex:sourceIndexPath.row];
    [self.tableData removeObjectAtIndex:sourceIndexPath.row];
    [self.tableData insertObject:temp atIndex:destinationIndexPath.row];
}






@end
