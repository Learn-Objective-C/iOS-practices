//
//  CMViewController.m
//  SimpleTable
//
//  Created by Long Vinh Nguyen on 3/2/13.
//  Copyright (c) 2013 home.vn. All rights reserved.
//

#import "CMViewController.h"


@implementation CMViewController
@synthesize tableData;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create the array to hold the table data
    self.tableData = [[NSMutableArray alloc] init];
    
    // Create and add 10 data items to the table data array
    for (NSUInteger i = 0; i < 10; i++) {
        // The cell will contain a string "Item X"
        NSString *dataString = [NSString stringWithFormat:@"Item %d",i];
        
        // Here the string is added to the end of the array
        [self.tableData addObject:dataString];
    }
    
    // Print out the contents of the array into the log
    NSLog(@"The tableData array contains %@", self.tableData);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    
    [cell.textLabel setText:[self.tableData objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Table row %d has been tapped", indexPath.row);
    
    NSString *messageString = [NSString stringWithFormat:@"You tapped row %d",indexPath.row];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Row tapped" message:messageString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
}








@end
