//
//  MyBrowserViewController.m
//  GreatExchange
//
//  Created by Christine Abernathy on 7/1/13.
//  Copyright (c) 2013 Elidora LLC. All rights reserved.
//

#import "MyBrowserViewController.h"
#import "AppDelegate.h"
#import "MyBrowserTableViewCell.h"


@interface MyBrowserViewController ()<MCNearbyServiceBrowserDelegate, UIToolbarDelegate>

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *nearbyPeers;
@property (strong, nonatomic) NSMutableArray *acceptedPeers;
@property (strong, nonatomic) NSMutableArray *declinedPeers;

@property (nonatomic, strong) MCNearbyServiceBrowser *browser;
@property (nonatomic, strong) NSString *serviceType;
@property (nonatomic, strong) MCPeerID *peerId;
@property (nonatomic, strong) MCSession *session;


@end

@implementation MyBrowserViewController

#pragma mark Initialization methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        // Default maximum and minimum number of
        // peers allowed in a session
        self.maximumNumberOfPeers = 8;
        self.minimumNumberOfPeers = 2;
    }
    return self;
}

#pragma mark - View lifecycle methods
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Set the toolbar delegate to be able
    // to position it to the top of the view.
    self.toolbar.delegate = self;
    
    self.nearbyPeers = [@[] mutableCopy];
    self.acceptedPeers = [@[] mutableCopy];
    self.declinedPeers = [@[] mutableCopy];
    
    [self showDoneButton:NO];
    self.browser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.peerId serviceType:self.serviceType];
    self.browser.delegate = self;
    [self.browser startBrowsingForPeers];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(peerConnected:) name:PeerConnectionAcceptedNotification object:nil];
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

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UIToolbarDelegate methods
- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
    
}

#pragma mark - Helper methods
- (void)showDoneButton:(BOOL)display
{
    NSMutableArray *toolbarButtons = [[self.toolbar items] mutableCopy];
    if (display) {
        // Show the done button
        if (![toolbarButtons containsObject:self.doneButton]) {
            [toolbarButtons addObject:self.doneButton];
            [self.toolbar setItems:toolbarButtons animated:NO];
        }
    } else {
        // Hide the done button
        [toolbarButtons removeObject:self.doneButton];
        [self.toolbar setItems:toolbarButtons animated:NO];
    }
}

#pragma mark - Action methods

- (IBAction)cancelButtonPressed:(id)sender {
    // Send the delegate a message that the controller was canceled.
    if ([self.delegate respondsToSelector:@selector(myBrowserViewControllerWasCancelled:)]) {
        [self.delegate myBrowserViewControllerWasCancelled:self];
    }
}

- (IBAction)doneButtonPressed:(id)sender {
    // Send the delegate a message that the controller was done browsing.
    if ([self.delegate respondsToSelector:@selector(myBrowserViewControllerDidFinish:)]) {
        [self.delegate myBrowserViewControllerDidFinish:self];
    }
}

#pragma mark - Table view data source and delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.nearbyPeers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NearbyDevicesCell";
    MyBrowserTableViewCell *cell = (MyBrowserTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MyBrowserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = nil;
    }
    
    MCPeerID *cellPeerId = self.nearbyPeers[indexPath.row];
    if ([self.acceptedPeers containsObject:cellPeerId]) {
        if ([cell.accessoryView isKindOfClass:[UIActivityIndicatorView class]]) {
            UIActivityIndicatorView *activityIndicatorView = (UIActivityIndicatorView *)cell.accessoryView; [activityIndicatorView stopAnimating];
        }
        UILabel *checkMarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        checkMarkLabel.text = @" √ ";
        cell.accessoryView = checkMarkLabel;
    } else if ([self.declinedPeers containsObject:cellPeerId]) {
        if ([cell.accessoryView isKindOfClass:[UIActivityIndicatorView class]]) {
            UIActivityIndicatorView *activityIndicatorView = (UIActivityIndicatorView *)cell.accessoryView; [activityIndicatorView stopAnimating];
        }
        UILabel *uncheckMarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        uncheckMarkLabel.text = @" X ";
        cell.accessoryView = uncheckMarkLabel;
    } else {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityView setColor:[(AppDelegate *)[[UIApplication sharedApplication] delegate] mainColor]];
        activityView.hidesWhenStopped = YES;
        [activityView startAnimating];
        cell.accessoryView = activityView;
        [self.browser invitePeer:cellPeerId toSession:self.session withContext:[@"Making Contact" dataUsingEncoding:NSUTF8StringEncoding] timeout:10];
    }
    cell.textLabel.text = cellPeerId.displayName;
    
    return cell;
}

#pragma mark - Set up nearby devices
- (void)setupWithServiceType:(NSString *)serviceType session:(MCSession *)session peer:(MCPeerID *)peerId
{
    self.session = session;
    self.serviceType = serviceType;
    self.peerId = peerId;
}

- (void)peerConnected:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    MCPeerID *peer = userInfo[@"peer"];
    
    BOOL nearbyDeviceDecision = [[notification userInfo][@"accept"] boolValue];
    if (nearbyDeviceDecision) {
        [self.acceptedPeers addObject:peer];
    } else {
        [self.declinedPeers addObject:peer];
    }
    
    if ([self.acceptedPeers count] >= self.maximumNumberOfPeers - 1) {
        [self doneButtonPressed:nil];
    } else {
        if ([self.acceptedPeers count] < (self.minimumNumberOfPeers - 1)) {
            [self showDoneButton:NO];
        } else {
            [self showDoneButton:YES];
        }
        [self.tableView reloadData];
    }
}


#pragma mark - MCNearbyServiceBrowse
- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
    NSLog(@"Error %@", error.localizedDescription);
}


- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    [self.nearbyPeers addObject:peerID];
    [self.tableView reloadData];
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    [self.nearbyPeers removeObject:peerID];
    [self.acceptedPeers removeObject:peerID];
    [self.declinedPeers removeObject:peerID];
    if ([self.acceptedPeers count] < (self.minimumNumberOfPeers - 1)) {
        [self showDoneButton:NO];
    }
    [self.tableView reloadData];
}

@end
