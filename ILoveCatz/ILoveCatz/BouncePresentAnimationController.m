//
//  BouncePresentAnimationController.m
//  ILoveCatz
//
//  Created by Long Vinh Nguyen on 4/9/14.
//  Copyright (c) 2014 com.razeware. All rights reserved.
//

#import "BouncePresentAnimationController.h"

@implementation BouncePresentAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // obtain the state from the context
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
    
    // obtain the container view
    UIView *containerView = [transitionContext containerView];
    
    // set the intial state
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    toViewController.view.frame = CGRectOffset(finalFrame, 0, screenBounds.size.height);
    
    // add the view
    [containerView addSubview:toViewController.view];
    
    // animate
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    UIViewController *fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:1.2 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        fromController.view.alpha = 0.5f;
        toViewController.view.frame = finalFrame;
    } completion:^(BOOL finished) {
        fromController.view.alpha = 1.0f;
        [transitionContext completeTransition:YES];
    }];
}

@end
