//
//  NAViewController.m
//  NamesApp
//
//  Created by Long Vinh Nguyen on 3/3/13.
//  Copyright (c) 2013 home.vn. All rights reserved.
//

#import "NAViewController.h"


@implementation NAViewController
@synthesize collation, tableData, outerArray, indexTitlesArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *pListPath = [bundle pathForResource:@"Names" ofType:@"plist"];
    
    NSDictionary *namesDictionary = [[NSDictionary alloc] initWithContentsOfFile:pListPath];
    self.tableData = [namesDictionary objectForKey:@"names"];
    
    self.collation = [UILocalizedIndexedCollation currentCollation];
    [self configureSectionData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    float maxTableHeight = self.tableView.contentSize.height;
    float frameTableHeight = self.tableView.frame.size.height;
    NSLog(@"Table Height: %f, Frame Height: %f", maxTableHeight, frameTableHeight);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureSectionData
{
    NSUInteger sectionTitlesCount = [collation.sectionIndexTitles count];
    self.outerArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    
    for (NSUInteger index = 0; index < sectionTitlesCount; index ++) {
        NSMutableArray *array = [NSMutableArray array];
        [self.outerArray addObject:array];
    }
    
    for (NSString *nameString in tableData) {
        NSInteger sectionNumber = [collation sectionForObject:nameString collationStringSelector:@selector(lowercaseString)];
        NSMutableArray *sectionNames = [outerArray objectAtIndex:sectionNumber];
        [sectionNames addObject:nameString];
    }
    for (NSUInteger index = 0; index < sectionTitlesCount; index ++) {
        NSMutableArray *namesForSection = [outerArray objectAtIndex:index];
        NSArray *sortedNamesForSection = [collation sortedArrayFromArray:namesForSection collationStringSelector:@selector(lowercaseString)];
        [self.outerArray replaceObjectAtIndex:index withObject:sortedNamesForSection];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return collation.sectionIndexTitles.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *theLetter = [self.collation.sectionIndexTitles objectAtIndex:section];
    
    if (![theLetter isEqualToString:@"#"]) {
        NSString *titleString = [NSString stringWithFormat:@"Names for the letter %@", theLetter];
        return titleString;
    }
    return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.collation.sectionIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *innerArray = [self.outerArray objectAtIndex:section];
    return [innerArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // Get the inner array for this section
    NSArray *innerArray = [self.outerArray objectAtIndex:indexPath.section];
    NSString *theName = [innerArray objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:theName];
    return cell;
}

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // Create header and footer for the table
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    [sectionHeaderView setBackgroundColor:[UIColor colorWithRed:1.0 green:0.7 blue:0.57 alpha:1.0]];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, sectionHeaderView.frame.size.width, 15.0)];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    [headerLabel setText:@"Section Header"];
    [headerLabel setFont:[UIFont fontWithName:@"Courier-Bold" size:18.0]];
    [sectionHeaderView addSubview:headerLabel];
    
    return sectionHeaderView;
    
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0;
}


















@end
