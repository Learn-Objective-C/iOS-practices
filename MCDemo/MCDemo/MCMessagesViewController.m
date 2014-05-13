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

@interface MCMessagesViewController()


@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSMutableArray *messsages;

@end

@implementation MCMessagesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = true;
    [self setSender:@"Long"];
    self.collectionView.backgroundColor = [UIColor brownColor];
    _messsages = [NSMutableArray new];
    _appDelegate = [UIApplication sharedApplication].delegate;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:@"MCDidReceiveDataNotification"
                                               object:nil];
}

- (void)didReceiveDataWithNotification:(NSNotification *)nc
{
    MCPeerID *peerID = nc.userInfo[@"peerID"];
    NSString *displayName = peerID.displayName;
    
    NSData *receivedData = nc.userInfo[@"data"];
    NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"displayName: %@ %@", displayName, receivedText);
    JSQMessage *message = [JSQMessage messageWithText:receivedText sender:displayName];
    [_messsages addObject:message];
    
    [self.collectionView reloadData];
}


#pragma mark - JSQMessagesCollectionViewDataSource
- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return _messsages[indexPath.item];
}

- (UIImageView *)collectionView:(JSQMessagesCollectionView *)collectionView bubbleImageViewForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [JSQMessagesBubbleImageFactory outgoingMessageBubbleImageViewWithColor:[UIColor purpleColor]];
}

- (UIImageView *)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageViewForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"anonymous"]];
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
    
    if (error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }
    [self finishSendingMessage];
}

@end
