//
//  ViewController.m
//  Circles
//
//  Created by VisiKard MacBook Pro on 9/16/13.
//  Copyright (c) 2013 VLong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.tapCount == 2) {
        [self.view setNeedsDisplay];
    }
}

@end
