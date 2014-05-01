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
NSInteger kBufferSize = 1024;

typedef void (^InvitationHandler) (BOOL accept, MCSession *session);

@interface AppDelegate ()<MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, UIAlertViewDelegate, NSStreamDelegate>

@property (nonatomic, strong) MCAdvertiserAssistant *advertiserAssistant;
@property (nonatomic, strong) MCNearbyServiceAdvertiser *advertiser;
@property (nonatomic, copy) InvitationHandler handler;
@property (nonatomic, strong) NSDictionary *discoveryInfo;
@property (nonatomic, strong) NSOutputStream *outputStream;
@property (nonatomic, strong) NSInputStream *dataStream;
@property (nonatomic, strong) NSInputStream *inputStream;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) MCPeerID *streamPeerID;
@property (nonatomic, assign) size_t buffetLimit;
@property (nonatomic, assign) size_t bufferOffset;

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
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.myCard];
    self.dataStream = [NSInputStream inputStreamWithData:data];
    [self.dataStream open];
    
    // Start an output stream to the connected peer, there should be only one device connected
    self.outputStream = [self.session startStreamWithName:@"myCard" toPeer:self.session.connectedPeers[0] error:&error];
    self.outputStream.delegate = self;
    [self.outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode: NSDefaultRunLoopMode];
    [self.outputStream open];

}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    switch (eventCode) {
        case NSStreamEventOpenCompleted:
        {
            if (aStream == self.inputStream) {
                self.receivedData = [NSMutableData new];
            }
            break;
        }
        case NSStreamEventHasSpaceAvailable:
        {
            if (aStream == self.outputStream) {
                u_int8_t buffer[kBufferSize];
                if (self.buffetLimit == self.bufferOffset) {
                    NSInteger bytesRead = [self.dataStream read:buffer maxLength:sizeof(buffer)];
                    if (bytesRead == -1) {
                        [self closeOutputStream];
                    } else if (bytesRead == 0) {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self closeOutputStream];
                        });
                    } else {
                        self.bufferOffset = 0;
                        self.buffetLimit = bytesRead;
                    }
                }
                
                if (self.buffetLimit != self.bufferOffset) {
                    NSInteger bytesWritten = [self.outputStream write:&buffer[self.bufferOffset] maxLength:self.buffetLimit - self.bufferOffset];
                    NSLog(@"bytes Written %d bufferOffset %zu bytesLimit %zu", bytesWritten, self.bufferOffset, self.buffetLimit);
                    if (bytesWritten == - 1) {
                        [self closeOutputStream];
                    } else {
                        self.bufferOffset += bytesWritten;
                    }
                }
            }
            break;
        }
        case NSStreamEventHasBytesAvailable:
        {
            if (aStream == self.inputStream) {
                u_int8_t buffer[kBufferSize];
                NSInteger bytesRead = [self.inputStream read:buffer maxLength:sizeof(buffer)];
                if (bytesRead == -1) {
                    [self closeInputStream];
                } else if (bytesRead == 0) {
                    
                } else {
                    [self.receivedData appendBytes:&buffer length:bytesRead];
                }
            }
            break;
        }
        case NSStreamEventErrorOccurred:
        {NSError* error = [aStream streamError];
            NSString* errorMessage = [NSString stringWithFormat:@"%@ and code = %d",
                                      [error localizedDescription],
                                      [error code]];
            NSLog(@"Error in stream event: %@", errorMessage);
            // Error, cleanup streams
            if (aStream == self.inputStream) {
                [self closeInputStream];
            }
            if (aStream == self.outputStream) {
                [self closeOutputStream];
            }
            break;
            
        }
        case NSStreamEventEndEncountered:
        {
            if (aStream == self.inputStream) {
                [self session:self.session didReceiveData:self.receivedData fromPeer:self.streamPeerID];
                [self closeInputStream];
            }
            break;
        }

            
        default:
            break;
    }
}

- (void)closeOutputStream
{
    if (self.outputStream) {
        [self.outputStream close];
        [self.outputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        self.outputStream.delegate = nil;
        self.outputStream = nil;
    }
    
    if (self.dataStream) {
        [self.dataStream close];
        [self.dataStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        self.dataStream.delegate = nil;
        self.dataStream = nil;
    }
    
    self.bufferOffset = 0;
    self.buffetLimit = 0;
}

- (void)closeInputStream
{
    if (self.inputStream) {
        [self.inputStream close];
        [self.inputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        self.inputStream.delegate = nil;
        self.inputStream = nil;
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
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.inputStream) {
            return;
        }
        
        self.streamPeerID = peerID;
        self.inputStream = stream;
        self.inputStream.delegate = self;
        [self.inputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        [self.inputStream open];
    });
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
    [[[UIAlertView alloc] initWithTitle:@"Invitation" message:[NSString stringWithFormat:@"%@ want to connect", peerID.displayName] delegate:self cancelButtonTitle:@"Nope" otherButtonTitles:@"Sure", nil] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    BOOL accept = (buttonIndex == alertView.cancelButtonIndex) ? NO : YES;
    self.handler(accept, self.session);
}



@end