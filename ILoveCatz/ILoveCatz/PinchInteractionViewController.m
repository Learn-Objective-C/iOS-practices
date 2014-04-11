//
//  PinchInteractionViewController.m
//  ILoveCatz
//
//  Created by Long Vinh Nguyen on 4/9/14.
//  Copyright (c) 2014 com.razeware. All rights reserved.
//

#import "PinchInteractionViewController.h"

@implementation PinchInteractionViewController
{
    BOOL _shouldCompleteTransition;
    UIViewController *_presentedViewController;
}

- (void)wireToViewController:(UIViewController *)viewController
{
    UIPinchGestureRecognizer *picnchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [viewController.view addGestureRecognizer:picnchGesture];
    _presentedViewController = viewController;
}

- (void)handlePinch:(UIPinchGestureRecognizer *)gesture
{
    CGFloat scale = gesture.scale;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            _interactionInProgress = YES;	
            [_presentedViewController dismissViewControllerAnimated:YES completion:nil];
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGFloat fraction = 1.0 * 0.1 / scale;
            _shouldCompleteTransition = scale < 0.5;
            NSLog(@"Scale %f fraction %f", scale, fraction);
            [self updateInteractiveTransition:fraction];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            self.interactionInProgress = NO;
            if (!_shouldCompleteTransition || gesture.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
            } else {
                [self finishInteractiveTransition];
            }
            break;
        }
            
        default:
            break;
    }
}


@end
