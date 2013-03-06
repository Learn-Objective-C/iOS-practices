//
//  LVNViewController.m
//  CustomCell
//
//  Created by Long Vinh Nguyen on 3/5/13.
//  Copyright (c) 2013 home.vn. All rights reserved.
//

#import "LVNViewController.h"
#import "OddCell.h"
#import "EvenCell.h"
#import "CodeBaseEvenCell.h"
#import "CodeBaseOddCell.h"

#define kOddCellIdentifier @"OddCellIdentifer"
#define kEvenCellIdentifier  @"EvenCellIdentifer"

@implementation LVNViewController
@synthesize phraseData, tableData;

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        tableData = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    NSLog(@"load");
    [super viewDidLoad];
    // [self.tableView registerNib:[UINib nibWithNibName:@"OddCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kOddCellIdentifier];
    // [self.tableView registerNib:[UINib nibWithNibName:@"EvenCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kEvenCellIdentifier];
    NSString *pathPhrases = [[NSBundle mainBundle] pathForResource:@"phrases" ofType:@"plist"];
    phraseData = [[[NSDictionary alloc] initWithContentsOfFile:pathPhrases] valueForKey:@"phrases"];
    [self populateTableData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [phraseData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isEvenRow = (indexPath.row % 2 == 0);
    NSString *cellIdentifier = nil;
    UIImage *backViewImage = nil;
    UIImage *iconViewImage = nil;
    
    NSString *cellTitle = [self.tableData objectAtIndex:indexPath.row];
    NSString *cellPhraseContent =[self.phraseData objectAtIndex:indexPath.row];
    
    if (isEvenRow) {
        // even row
        cellIdentifier = kEvenCellIdentifier;
        backViewImage =[UIImage imageNamed:@"ginham"];
        iconViewImage = [UIImage imageNamed:@"star1"];
    } else {
        // odd row
        cellIdentifier = kOddCellIdentifier;
        backViewImage = [UIImage imageNamed:@"corkboard"];
        iconViewImage = [UIImage imageNamed:@"planet"];
    }
    
    
    if (isEvenRow) {
        // Even Row
        CodeBaseEvenCell *evenCell = [tableView dequeueReusableCellWithIdentifier:kEvenCellIdentifier];
        if (!evenCell) {
            evenCell = [[CodeBaseEvenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kEvenCellIdentifier];
        }
        [evenCell.iconView setImage:iconViewImage];
        [evenCell.cellTitle setText:cellTitle];
        [evenCell.cellMainContent setText:cellPhraseContent];
        [evenCell.cellOtherContent setText:@"copyright@2013"];
        
        return evenCell;
    } 
    // Odd row
    
    CodeBaseOddCell *oddCell = [tableView dequeueReusableCellWithIdentifier:kOddCellIdentifier];
    if (!oddCell) {
        oddCell = [[CodeBaseOddCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kOddCellIdentifier];
    }
    [oddCell.iconView setImage:iconViewImage];
    [oddCell.cellTitle setText:cellTitle];
    [oddCell.cellContent setText:cellPhraseContent];

    return oddCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        return 50;
    }
    return 70;
}

- (void)populateTableData
{
    [phraseData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        [tableData addObject:[NSString stringWithFormat:@"Cell %d", idx]];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Select row %d",indexPath.row);
}













@end
