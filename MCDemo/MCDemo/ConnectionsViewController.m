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
    
    _appDelegate = [UIApplication sharedApplication].delegate;
    [_appDelegate.mcManager setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
    [_appDelegate.mcManager advertiseSelf:YES];

    _arrConnectedDevices = [NSMutableArray new];
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
    browserController.view.frame = self.view.bounds;
    browserController.delegate = self;
    browserController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:browserController animated:YES completion:nil];
}

- (void)toogleVisibility:(id)sender
{
    [_appDelegate.mcManager advertiseSelf:_swVisible.isOn];
}

- (void)disconnect:(id)sender
{
    [_appDelegate.mcManager tearDown];
    _txtName.enabled = YES;
    [_arrConnectedDevices removeAllObjects];
    [_tblConnectedDevices reloadData];
}

#pragma mark - MCBrowserViewController delegate


#pragma mark - UITextFieled delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [_appDelegate.mcManager tearDown];

    [_appDelegate.mcManager setupPeerAndSessionWithDisplayName:_txtName.text];
    [_appDelegate.mcManager setupNearbyServiceBrowser];
    [_appDelegate.mcManager advertiseSelf:_swVisible.isOn];
    
    return YES;
}

#pragma mark - LNBrowserViewController
- (void)browserViewControllerDidFinish:(LNBrowserViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    BOOL peersExist = ([[_appDelegate.mcManager.session connectedPeers] count] == 0);
    [_btnDisconnect setEnabled:!peersExist];
    [_txtName setEnabled:peersExist];
    _arrConnectedDevices = [NSMutableArray arrayWithArray:_appDelegate.mcManager.session.connectedPeers];
    [self.tblConnectedDevices reloadData];
}

- (void)browserViewControllerWasCancelled:(LNBrowserViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    BOOL peersExist = ([[_appDelegate.mcManager.session connectedPeers] count] == 0);
    [_btnDisconnect setEnabled:!peersExist];
    [_txtName setEnabled:peersExist];
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
