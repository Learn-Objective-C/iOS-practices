//
//  ConnectionsViewController.m
//  MCDemo
//
//  Created by Long Vinh Nguyen on 5/7/14.
//  Copyright (c) 2014 Home Inc. All rights reserved.
//

#import "ConnectionsViewController.h"
#import "AppDelegate.h"
#import "LNBrowserViewController.h"

@interface ConnectionsViewController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, LNBrowserViewControllerDelegate>

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSMutableArray *arrConnectedDevices;

@end

@implementation ConnectionsViewController
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _arrConnectedDevices = [NSMutableArray new];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _arrConnectedDevices = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//#if TARGET_IPHONE_SIMULATOR
//    [_appDelegate.mcManager setupPeerAndSessionWithDisplayName:@"SIMULATOR"];
//#else
//    [_appDelegate.mcManager setupPeerAndSessionWithDisplayName:@"LongNV"];
//#endif
//    [_appDelegate.mcManager advertiseSelf:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Action methods
- (void)browseForDevices:(id)sender
{
    [_appDelegate.mcManager setupNearbyServiceBrowser];
    LNBrowserViewController *browserController = [[LNBrowserViewController alloc] init];
    browserController.delegate = self;
    browserController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:browserController animated:YES completion:nil];
}


- (void)disconnect:(id)sender
{
    [_appDelegate.mcManager tearDown];
    [_arrConnectedDevices removeAllObjects];
    [_tblConnectedDevices reloadData];
}

#pragma mark - LNBrowserViewController
- (void)browserViewControllerDidFinish:(LNBrowserViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    BOOL peersExist = ([[_appDelegate.mcManager.session connectedPeers] count] == 0);
    [_btnDisconnect setEnabled:!peersExist];
    _arrConnectedDevices = [NSMutableArray arrayWithArray:_appDelegate.mcManager.session.connectedPeers];
    [self.tblConnectedDevices reloadData];
}

- (void)browserViewControllerWasCancelled:(LNBrowserViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    BOOL peersExist = ([[_appDelegate.mcManager.session connectedPeers] count] == 0);
    [_btnDisconnect setEnabled:!peersExist];
    _arrConnectedDevices = [NSMutableArray arrayWithArray:_appDelegate.mcManager.session.connectedPeers];
    [self.tblConnectedDevices reloadData];
}

#pragma mark - ConnectedPeer tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrConnectedDevices.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    
    cell.textLabel.text = [_arrConnectedDevices[indexPath.row] displayName];
    
    return cell;
}

@end
