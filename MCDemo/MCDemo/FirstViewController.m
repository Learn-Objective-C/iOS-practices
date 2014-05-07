//
//  FirstViewController.m
//  MCDemo
//
//  Created by Long Vinh Nguyen on 5/7/14.
//  Copyright (c) 2014 Home Inc. All rights reserved.
//

#import "FirstViewController.h"
#import "AppDelegate.h"

@interface FirstViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *messageTextField;
@property (nonatomic, weak) IBOutlet UITextView *chatTextView;

@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _chatTextView.editable = NO;
    _appDelegate = [UIApplication sharedApplication].delegate;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:@"MCDidReceiveDataNotification"
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendMyMessage];
    return YES;
}

- (IBAction)sendMessage:(id)sender
{
    [self sendMyMessage];
}

- (IBAction)cancelMessage:(id)sender
{
    
}

- (void)sendMyMessage
{
    NSData *data = [_messageTextField.text dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *allPeers = _appDelegate.mcManager.session.connectedPeers;
    NSError *error;
    
    [_appDelegate.mcManager.session sendData:data toPeers:allPeers withMode:MCSessionSendDataReliable error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }
    
    _chatTextView.text = [_chatTextView.text stringByAppendingFormat:@"I wrote: \n%@\n\n", _messageTextField.text];
    _messageTextField.text = @"";
    [_messageTextField resignFirstResponder];
}

- (void)didReceiveDataWithNotification:(NSNotification *)nc
{
    MCPeerID *peerID = nc.userInfo[@"peerID"];
    NSString *displayName = peerID.displayName;
    
    NSData *receivedData = nc.userInfo[@"data"];
    NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    [_chatTextView performSelectorOnMainThread:@selector(setText:) withObject:[_chatTextView.text stringByAppendingString:[NSString stringWithFormat:@"%@ wrote:\n%@\n\n", displayName, receivedText]] waitUntilDone:NO];
}

@end
