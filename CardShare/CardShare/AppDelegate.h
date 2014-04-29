//
//  AppDelegate.h
//  GreatExchange
//
//  Created by Christine Abernathy on 6/27/13.
//  Copyright (c) 2013 Elidora LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"
@import MultipeerConnectivity;

extern NSString *const kServiceType;
extern NSString *const DataReceivedNotification;
extern BOOL const kProgrammaticDiscovery;
extern NSString *const PeerConnectionAcceptedNotification;
extern NSString *const kSecretCode;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) Card *myCard;
@property (strong, nonatomic) NSMutableArray *otherCards;
@property (strong, nonatomic) NSMutableArray *receivedCardPeers;
@property (nonatomic, assign, getter = isSentBusinessCard) BOOL sentBusinessCard;

@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCPeerID *peerId;

- (void) addToOtherCardsList:(Card *)card;
- (void) removeCardFromExchangeList:(Card *)card;
- (void)sendCardToPeer;
- (UIColor *) mainColor;
- (BOOL)isMatchingInfo:(NSDictionary *)info;

@end
