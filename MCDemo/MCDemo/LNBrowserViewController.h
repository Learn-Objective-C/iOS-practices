//
//  LNBrowserViewController.h
//  MCDemo
//
//  Created by LongNV on 5/12/14.
//  Copyright (c) 2014 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MultipeerConnectivity;

@class LNBrowserViewController;

@protocol LNBrowserViewControllerDelegate <NSObject>

- (void)browserViewControllerDidFinish:(LNBrowserViewController *)controller;
- (void)browserViewControllerWasCancelled:(LNBrowserViewController *)controller;

@end

@interface LNBrowserViewController : UIViewController<MCNearbyServiceBrowserDelegate>

@property (nonatomic, weak) id<LNBrowserViewControllerDelegate> delegate;

@end
