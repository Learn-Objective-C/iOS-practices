//
//  AppDelegate.h
//  MCDemo
//
//  Created by Long Vinh Nguyen on 5/7/14.
//  Copyright (c) 2014 Home Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCChatSession.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong)  MCChatSession *mcManager;

@end
