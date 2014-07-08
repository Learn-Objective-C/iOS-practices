//
//  LNBrowserViewController.m
//  MCDemo
//
//  Created by LongNV on 5/12/14.
//  Copyright (c) 2014 Home Inc. All rights reserved.
//

#import "LNBrowserViewController.h"
#import "AppDelegate.h"

@interface LNBrowserViewController ()<UINavigationBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *peersTableView;
@property (nonatomic, strong) NSMutableArray *nearbyPeers;
@property (nonatomic, strong) NSMutableArray *acceptedPeers;
@property (nonatomic, strong) NSMutableArray *declinedPeers;

@property (nonatomic, assign) NSInteger minimumNumbers;
@property (nonatomic, assign) NSInteger maximumNumbers;

@property (nonatomic, strong) UIBarButtonItem *rightButtonItem;
@property (nonatomic, strong) UIBarButtonItem *leftButtonItem;

@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation LNBrowserViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.minimumNumbers = 2;
        self.maximumNumbers = 8;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _nearbyPeers = [NSMutableArray new];
    _acceptedPeers = [NSMutableArray new];
    _declinedPeers = [NSMutableArray new];
    
    _peersTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _peersTableView.contentInset = UIEdgeInsetsMake(55, 0, 0, 0);
    _peersTableView.delegate = self;
    _peersTableView.dataSource = self;
    [self.view addSubview:_peersTableView];
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 15, CGRectGetWidth(self.view.bounds), 40)];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@""];
    _leftButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped:)];
    _rightButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped:)];
    [item setLeftBarButtonItem:_leftButtonItem];
    [item setRightBarButtonItem:_rightButtonItem];
    
    navBar.items = @[item];
    navBar.delegate = self;
    
    
    [self.view addSubview:navBar];
    _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _appDelegate.mcManager.browser.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(peerConnected:) name:@"MCDidAcceptInvitation" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [_appDelegate.mcManager.browser startBrowsingForPeers];
    [super viewWillAppear:animated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

- (void)peerConnected:(NSNotification *)notification
{
    MCPeerID *peer = (MCPeerID *)[notification userInfo][@"peerID"];
    BOOL nearbyDeviceDecision = [[notification userInfo][@"accept"] boolValue];
    
    if (nearbyDeviceDecision) {
        [self.acceptedPeers addObject:peer];
    } else {
        [self.declinedPeers addObject:peer];
    }
    
    if ([self.acceptedPeers count] >= (self.maximumNumbers - 1)) {
        [self doneButtonTapped:nil];
    } else {
        if ([self.acceptedPeers count] < (self.maximumNumbers - 1)) {
            [self showButtonDone:YES];
        }
        else {
            [self showButtonDone:NO];
        }
        [self.peersTableView reloadData];
    }
}


#pragma mark - Action methods
- (void)cancelButtonTapped:(id)sender
{
    [_appDelegate.mcManager.browser stopBrowsingForPeers];
    if ([_delegate respondsToSelector:@selector(browserViewControllerWasCancelled:)]) {
        [_delegate browserViewControllerWasCancelled:self];
    }
}

- (void)doneButtonTapped:(id)sender
{
    [_appDelegate.mcManager.browser stopBrowsingForPeers];
    if ([_delegate respondsToSelector:@selector(browserViewControllerDidFinish:)]) {
        [_delegate browserViewControllerDidFinish:self];
    }
}

- (void)showButtonDone:(BOOL)flag
{
    self.rightButtonItem.enabled = flag;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _nearbyPeers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    MCPeerID *cellPeerID = _nearbyPeers[indexPath.row];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = nil;
    }
    
    if ([_acceptedPeers containsObject:cellPeerID]) {
        if ([cell.accessoryView isKindOfClass:[UIActivityIndicatorView class]]) {
            UIActivityIndicatorView *activityIndicatorView = (UIActivityIndicatorView *)cell.accessoryView;
            [activityIndicatorView stopAnimating];
        }
        
        UILabel *checkMarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        checkMarkLabel.text = @" √ ";
        cell.accessoryView = checkMarkLabel;
    } else if ([_declinedPeers containsObject:cellPeerID]) {
        if ([cell.accessoryView isKindOfClass:
             [UIActivityIndicatorView class]])
        {
            UIActivityIndicatorView *activityIndicatorView = (UIActivityIndicatorView *)cell.accessoryView;
            [activityIndicatorView stopAnimating];
        }
        UILabel *unCheckmarkLabel =
        [[UILabel alloc]
         initWithFrame:CGRectMake(0, 0, 20, 20)];
        unCheckmarkLabel.text = @" X ";
        cell.accessoryView = unCheckmarkLabel;
    }
    
    cell.textLabel.text = cellPeerID.displayName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    MCPeerID *cellPeerID = _nearbyPeers[indexPath.row];
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]
                                                      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.hidesWhenStopped = YES;
    cell.accessoryView = activityIndicatorView;

    [activityIndicatorView startAnimating];
    [_appDelegate.mcManager.browser invitePeer:cellPeerID toSession:_appDelegate.mcManager.session withContext:[@"Making Contact" dataUsingEncoding:NSUTF8StringEncoding] timeout:30];
}

#pragma mark - MCNearbyServiceBrowser delegate
- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
    NSLog(@"Error: %@", error.localizedDescription);
}

- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    [_nearbyPeers addObject:peerID];
    [self.peersTableView reloadData];
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    NSLog(@"Lost peer %@ peerID", peerID);
    [_nearbyPeers removeObject:peerID];
    [_acceptedPeers removeObject:peerID];
    [_declinedPeers removeObject:peerID];
    
    if (_acceptedPeers.count < self.minimumNumbers - 1) {
        NSLog(@"_acceptedPeers %d minimumNumbers %d", _acceptedPeers.count, _minimumNumbers);
        [self showButtonDone:NO];
    }
    
    [self.peersTableView reloadData];
}



@end
