//
//  MCManager.h
//  MCDemo
//
//  Created by Long Vinh Nguyen on 5/7/14.
//  Copyright (c) 2014 Home Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MultipeerConnectivity;

@class MCChatSession;


@protocol MCChatSessionDelegate <NSObject>

- (void)didReveivedData:(NSData *)data from:(MCPeerID *)peerID;
- (void)didReveiveResource:(NSURL *)url from:(MCPeerID *)peerID;
- (void)peerIDDidJoinChatSeesion:(MCPeerID *)peerID;

@end


@interface MCChatSession : NSObject

@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCSession *session;
@property (strong, nonatomic) MCNearbyServiceBrowser *browser;
@property (nonatomic, strong) MCNearbyServiceAdvertiser *advertiser;

@property (nonatomic, weak) id<MCChatSessionDelegate>delegate;

- (void)setupPeerAndSessionWithDisplayName:(NSString *)displayName;
- (void)setupNearbyServiceBrowser;
- (void)advertiseSelf:(BOOL)shouldAdvertise;
- (void)tearDown;



@end
