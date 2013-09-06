//
//  LVNViewController.m
//  IndexedTable
//
//  Created by Long Vinh Nguyen on 3/3/13.
//  Copyright (c) 2013 home.vn. All rights reserved.
//

#import "LVNViewController.h"

@implementation LVNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.tableData = [[NSArray alloc] initWithObjects:@"Bailey", @"Cadan", @"Dafydd", @"Eamon", @"Fabian", @"Gabrielle", @"Hafwen", @"Isaac", @"Jacinta", @"Kathleen", @"Lucy", @"Maurice", @"Nadia", @"Octavia", @"Padraig", @"Rachel", @"Sabina", @"Tabitha", @"Uma", @"Valentina", @"Wallis", @"Xanthe", @"Yvonne", nil]; 
    
    NSString *letters = @"A B C D E F G H I J K L M N O P Q R S T U V W X Y Z";
    self.indexTitlesArray = [letters componentsSeparatedByString:@" "];
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSString *name in self.tableData) {
        NSString *firstLetter = [name substringToIndex:1];
        [temp addObject:[firstLetter uppercaseString]];
    }
    
    self.indexTitlesArray = temp;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell.textLabel setText:[self.tableData objectAtIndex:indexPath.section]];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.indexTitlesArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.indexTitlesArray objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.indexTitlesArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [self.indexTitlesArray indexOfObject:title];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
