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


@implementation BNViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tableData) {
        return [self.tableData count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"BabyNameCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    
    // Extract the BNName object from the tableData
    BNName *tempName = [self.tableData objectAtIndex:[indexPath row]];
    
    // Update the cell's textLabel
    [cell.textLabel setText: tempName.nameText];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNDetailViewController *detailViewController = [[BNDetailViewController alloc] initWithNibName:@"BNDetailViewController" bundle:nil];
    [detailViewController setBNName:[self.tableData objectAtIndex:[indexPath row]]];
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSIndexPath *selectedIndexPath = [self.theTableView indexPathForSelectedRow];
    
    [self.theTableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Baby Names";
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
