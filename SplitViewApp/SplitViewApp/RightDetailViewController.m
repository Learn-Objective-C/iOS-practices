//
//  RightDetailViewController.m
//  SplitViewApp
//
//  Created by Long Vinh Nguyen on 3/10/13.
//  Copyright (c) 2013 home.vn. All rights reserved.
//

#import "RightDetailViewController.h"


@implementation RightDetailViewController
@synthesize statusLabel = _statusLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self.navigationItem setLeftBarButtonItem:nil];
}

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    [barButtonItem setTitle:@"Show List"];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
}

- (void)updateDetailViewWithDetail:(NSString *)detail
{
    NSLog(@"updateDetailViewWithDetail:%@ called", detail);
    [_statusLabel setText:[NSString stringWithFormat:@"%@ was selected",detail]];
}

@end
