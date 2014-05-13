//
//  FirstViewController.m
//  MCDemo
//
//  Created by LongNV on 5/13/14.
//  Copyright (c) 2014 Home Inc. All rights reserved.
//

#import "FirstViewController.h"
#import "MCMessagesViewController.h"

@interface FirstViewController ()

@property (nonatomic, strong) MCMessagesViewController *messagesViewController;

@end

@implementation FirstViewController

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
    _messagesViewController = [MCMessagesViewController messagesViewController];
    _messagesViewController.view.frame = CGRectInset(self.view.bounds, 0, self.tabBarController.tabBar.frame.size.height);
    NSLog(@"%@ %f", NSStringFromCGRect(_messagesViewController.view.frame), self.tabBarController.tabBar.frame.size.height);
    [self addChildViewController:_messagesViewController];
    [self.view addSubview:_messagesViewController.view];
    [_messagesViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
