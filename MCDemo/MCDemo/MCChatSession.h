//
//  MCManager.h
//  MCDemo
//
//  Created by Long Vinh Nguyen on 5/7/14.
//  Copyright (c) 2014 Home Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString *const kServiceType;

@import MultipeerConnectivity;

@interface MCChatSession : NSObject

@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCSession *session;
@property (strong, nonatomic) MCNearbyServiceBrowser *browser;
@property (nonatomic, strong) MCNearbyServiceAdvertiser *advertiser;

- (void)setupPeerAndSessionWithDisplayName:(NSString *)displayName;
- (void)setupNearbyServiceBrowser;
- (void)advertiseSelf:(BOOL)shouldAdvertise;
- (void)tearDown;



@end
