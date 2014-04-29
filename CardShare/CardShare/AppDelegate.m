//
//  AppDelegate.m
//  GreatExchange
//
//  Created by Christine Abernathy on 6/27/13.
//  Copyright (c) 2013 Elidora LLC. All rights reserved.
//

#import "AppDelegate.h"

NSString *const kServiceType = @"ln-careshare";
NSString *const DataReceivedNotification = @"com.longnv.apps.CardShare:DataReceivedNotification";
NSString *const PeerConnectionAcceptedNotification = @"com.longnv.apps.CardShare:PeerConnectionAcceptedNotification";
NSString *const kSecretCode = @"secretCode";
BOOL const kProgrammaticDiscovery = YES;

typedef void (^InvitationHandler) (BOOL accept, MCSession *session);

@interface AppDelegate ()<MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, UIAlertViewDelegate, NSStreamDelegate>

@property (nonatomic, strong) MCAdvertiserAssistant *advertiserAssistant;
@property (nonatomic, strong) MCNearbyServiceAdvertiser *advertiser;
@property (nonatomic, copy) InvitationHandler handler;
@property (nonatomic, strong) NSDictionary *discoveryInfo;
@property (nonatomic, strong) NSOutputStream *outputStream;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // Set appearance info
    [[UITabBar appearance] setBarTintColor:[self mainColor]];
    
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackOpaque];
    [[UINavigationBar appearance] setBarTintColor:[self mainColor]];
    
    [[UIToolbar appearance] setBarStyle:UIBarStyleBlackOpaque];
    [[UIToolbar appearance] setBarTintColor:[self mainColor]];
    
    // Initialize properties
    self.cards = [@[] mutableCopy];
    
    // Initialize any stored data
    self.myCard = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"myCard"]) {
        NSData *myCardData = [defaults objectForKey:@"myCard"];
        self.myCard = (Card *)[NSKeyedUnarchiver unarchiveObjectWithData:myCardData];
    }
    self.otherCards = [@[] mutableCopy];
    if ([defaults objectForKey:@"otherCards"]) {
        NSData *otherCardsData = [defaults objectForKey:@"otherCards"];
        self.otherCards = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:otherCardsData];
    }
    self.discoveryInfo = @{kSecretCode: @"WOW"};
    [self setUpMultipeerConnectivity];
    
    return YES;
}

#pragma mark - Helper methods
- (UIColor *)mainColor
{
    return [UIColor colorWithRed:28/255.0f green:171/255.0f blue:116/255.0f alpha:1.0f];
}

/*
 * Implement the setter for the user's card
 * so as to set the value in storage as well.
 */
- (void)setMyCard:(Card *)aCard
{
    if (aCard != _myCard) {
        _myCard = aCard;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        // Create an NSData representation
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:aCard];
        [defaults setObject:data forKey:@"myCard"];
        [defaults synchronize];
    }
}

- (void)addToOtherCardsList:(Card *)card
{
    [self.otherCards addObject:card];
    // Update stored value
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.otherCards];
    [defaults setObject:data forKey:@"otherCards"];
    [defaults synchronize];
}

- (void) removeCardFromExchangeList:(Card *)card
{
    NSMutableSet *cardsSet = [NSMutableSet setWithArray:self.cards];
    [cardsSet removeObject:card];
    self.cards = [[cardsSet allObjects] mutableCopy];
}

- (void)sendCardToPeer
{
    self.sentBusinessCard = YES;
    NSError *error;
//    [self.session sendData:data toPeers:self.session.connectedPeers withMode:MCSessionSendDataReliable error:&error];
    self.outputStream = [self.session startStreamWithName:@"CardShare" toPeer:self.session.connectedPeers[1] error:&error];
    self.outputStream.delegate = self;
    [self.outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode: NSDefaultRunLoopMode];
    [self.outputStream open];

}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    switch (eventCode) {
        case NSStreamEventHasSpaceAvailable:
        {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.myCard];
            [self.outputStream write:[data bytes] maxLength:[data length]];
            break;
        }

            
        default:
            break;
    }
}

- (void)cleanUpMultipeerConnectivity
{
    [self.session disconnect];
    self.session.delegate = nil;
    
    if (kProgrammaticDiscovery) {
        [self.advertiserAssistant stop];
        self.advertiserAssistant.delegate = nil;
    } else {
        [self.advertiser stopAdvertisingPeer];
    }
    
    // Cleanup the session
    self.session = nil;
    // Cleanup peer info
    self.peerId = nil;
}

- (void)setUpMultipeerConnectivity
{
    //
    NSString *peerName = self.myCard.firstName?:[[UIDevice currentDevice] name];
    self.peerId = [[MCPeerID alloc] initWithDisplayName:peerName];
    self.session = [[MCSession alloc] initWithPeer:self.peerId securityIdentity:nil encryptionPreference:MCEncryptionOptional];
    self.session.delegate = self;
    if (kProgrammaticDiscovery) {
        self.advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.peerId discoveryInfo:self.discoveryInfo serviceType:kServiceType];
        self.advertiser.delegate = self;
        [self.advertiser startAdvertisingPeer];
    } else {
        self.advertiserAssistant = [[MCAdvertiserAssistant alloc] initWithServiceType:kServiceType discoveryInfo:self.discoveryInfo session:self.session];
        [self.advertiserAssistant start];
    }
    self.receivedCardPeers = [NSMutableArray new];
    self.sentBusinessCard = NO;
}

- (BOOL)isMatchingInfo:(NSDictionary *)info
{
    if (self.discoveryInfo == nil) {
        return YES;
    }
    return [info isEqualToDictionary:self.discoveryInfo];
}

- (void)isDisconnectSession
{
    if ([self.receivedCardPeers isEqualToArray:self.session.connectedPeers] && self.isSentBusinessCard) {
        NSLog(@"Disconnect");
        [self cleanUpMultipeerConnectivity];
        [self setUpMultipeerConnectivity];
    }
}

#pragma mark - MCSession Delegate
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    Card *card = (Card *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    [self.cards addObject:card];
    [self.receivedCardPeers addObject:peerID];
    [self isDisconnectSession];
    [[NSNotificationCenter defaultCenter] postNotificationName:DataReceivedNotification object:nil];
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    
}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    if (state == MCSessionStateConnected && self.session) {
        [[NSNotificationCenter defaultCenter] postNotificationName:PeerConnectionAcceptedNotification object:nil userInfo:@{@"peer": peerID, @"accept":@YES}];
    } else if (state == MCSessionStateNotConnected && self.session) {
        if (![self.session.connectedPeers containsObject:peerID]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:PeerConnectionAcceptedNotification object:nil userInfo:@{@"peer": peerID, @"accept":@NO}];
            [self isDisconnectSession];
        }
    }
}

#pragma mark - MCNearbyService Delegate
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler
{
    self.handler = invitationHandler;
    [[[UIAlertView alloc] initWithTitle:@"Invitation" message:[NSString stringWithFormat:@"%@ watns to connect", peerID.displayName] delegate:self cancelButtonTitle:@"Nope" otherButtonTitles:@"Sure", nil] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    BOOL accept = (buttonIndex == alertView.cancelButtonIndex) ? NO : YES;
    self.handler(accept, self.session);
}



@end