//
//  WebViewController.h
//  TextKitNotepad
//
//  Created by Long Vinh Nguyen on 4/12/14.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (nonatomic, strong) NSURL *url;

- (id)initWithURL:(NSURL *)url;

@end
