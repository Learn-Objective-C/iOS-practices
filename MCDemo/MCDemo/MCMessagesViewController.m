//
//  FirstViewController.m
//  MCDemo
//
//  Created by Long Vinh Nguyen on 5/7/14.
//  Copyright (c) 2014 Home Inc. All rights reserved.
//

#import "MCMessagesViewController.h"
#import "AppDelegate.h"
#import "JSQMessage.h"
#import "JSQMessagesBubbleImageFactory.h"

@interface MCMessagesViewController()<MCChatSessionDelegate>


@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSMutableArray *messsages;

@end

@implementation MCMessagesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = true;
    [self setSender:[UIDevice currentDevice].name];
    _messsages = [NSMutableArray new];
    _appDelegate = [UIApplication sharedApplication].delegate;
    _appDelegate.mcManager.delegate = self;
}
    

#pragma mark - JSQMessagesCollectionViewDataSource
- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return _messsages[indexPath.item];
}

- (UIImageView *)collectionView:(JSQMessagesCollectionView *)collectionView bubbleImageViewForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = _messsages[indexPath.row];
    if ([message.sender isEqualToString:self.sender]) {
        return [JSQMessagesBubbleImageFactory outgoingMessageBubbleImageViewWithColor:[UIColor blueColor]];
    }
    return [JSQMessagesBubbleImageFactory incomingMessageBubbleImageViewWithColor:[UIColor lightGrayColor]];
}

- (UIImageView *)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageViewForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"anonymous"]];
    return nil;
}


#pragma mark - ColllectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _messsages.count;
}

#pragma mark - JSQMessagesCollectionViewDelegateFlowLayout

#pragma mark - MessageView Controller
- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text sender:(NSString *)sender date:(NSDate *)date
{
    JSQMessage *message = [JSQMessage messageWithText:text sender:sender];
    [_messsages addObject:message];
    
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *allPeers = _appDelegate.mcManager.session.connectedPeers;
    NSError *error;
    
    [_appDelegate.mcManager.session sendData:data toPeers:allPeers withMode:MCSessionSendDataReliable error:&error];
    NSLog(@"peer: %@", allPeers);
    
    if (error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }
    [self finishSendingMessage];
}

#pragma mark - MCChatSessionDelegate
- (void)didReveivedData:(NSData *)data from:(MCPeerID *)peerID
{
    NSData *receivedData = data;
    NSString *displayName = peerID.displayName;
    NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    JSQMessage *message = [JSQMessage messageWithText:receivedText sender:displayName];
    [_messsages addObject:message];
    
    if ([NSThread currentThread] == [NSThread mainThread]) {
        NSLog(@"Thread %@ displayName: %@ %@", [NSThread currentThread],displayName, receivedText);
    } else {
        NSLog(@"displayName: %@ %@",displayName, receivedText);
    }

    
    [self finishReceivingMessage];
}

- (void)peerIDDidJoinChatSeesion:(MCPeerID *)peerID
{
    
}

- (void)didReveiveResource:(NSURL *)url from:(MCPeerID *)peerID
{
    
}
    

@end
