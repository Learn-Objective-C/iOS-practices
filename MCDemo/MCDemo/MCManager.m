//
//  MCManager.m
//  MCDemo
//
//  Created by Long Vinh Nguyen on 5/7/14.
//  Copyright (c) 2014 Home Inc. All rights reserved.
//

#import "MCManager.h"

 NSString *const kServiceType = @"chat-files";

typedef void(^InvitationHandler) (BOOL accept, MCSession *session);

@interface MCManager()<MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, UIAlertViewDelegate>

@property (nonatomic, copy) InvitationHandler handler;

@end

@implementation MCManager

- (id)init
{
    if (self = [super init]) {
        _peerID = nil;
        _session = nil;
        _browser = nil;
        _advertiser = nil;
    }
    
    return self;
}

#pragma mark - Initialization
- (void)setupPeerAndSessionWithDisplayName:(NSString *)displayName
{
    _peerID = [[MCPeerID alloc] initWithDisplayName:displayName];
    _session = [[MCSession alloc] initWithPeer:_peerID];
    _session.delegate = self;
}

- (void)setupNearbyServiceBrowser
{
    _browser = [[MCNearbyServiceBrowser alloc] initWithPeer:_peerID serviceType:kServiceType];
}

- (void)advertiseSelf:(BOOL)shouldAdvertise
{
    if (shouldAdvertise) {
        _advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.peerID discoveryInfo:nil serviceType:kServiceType];
        _advertiser.delegate = self;
        [_advertiser startAdvertisingPeer];
    } else {
        [_advertiser stopAdvertisingPeer];
        _advertiser = nil;
    }
}

#pragma mark - MCSessionDelegate
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{

    if (state == MCSessionStateConnected) {
        NSDictionary *dict = @{@"peerID": peerID, @"accept": @YES};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidAcceptInvitation" object:nil userInfo:dict];
    } else if (state == MCSessionStateNotConnected) {
        NSDictionary *dict = @{@"peerID": peerID, @"accept": @NO};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidAcceptInvitation" object:nil userInfo:dict];
    }
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSDictionary *dict = @{@"peerID": peerID, @"data": data};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidReceiveDataNotification" object:nil userInfo:dict];
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    NSDictionary *dict = @{@"resourceName": resourceName,
                           @"peerID": peerID,
                           @"progress": progress};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didStartReceivingResourceNotification" object:nil userInfo:dict];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
    });
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    NSDictionary *dict = @{@"resourceName": resourceName,
                           @"peerID": peerID,
                           @"localURL": localURL};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didFinishReceivingResourceNotification" object:nil userInfo:dict];
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCReceivingProgressNotification"
                                                        object:nil
                                                      userInfo:@{@"progress": (NSProgress *)object}];
}

#pragma mark - MCNearbyServiceAdvertiser delegate
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL accept, MCSession *session))invitationHandler
{
    self.handler = invitationHandler;
    [[[UIAlertView alloc] initWithTitle:@"Invitation" message:[NSString stringWithFormat:@"%@ wants to connect", self.peerID.displayName] delegate:self cancelButtonTitle:@"Nope" otherButtonTitles:@"Sure", nil] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    BOOL accept = (buttonIndex == alertView.cancelButtonIndex)?NO:YES;
    self.handler(accept, self.session);
}

#pragma mark - End Connection
- (void)tearDown
{
    [self.browser stopBrowsingForPeers];
    [self.advertiser stopAdvertisingPeer];
    [self.session disconnect];
    
    self.browser = nil;
    self.advertiser = nil;
    self.session =nil;
}






@end
