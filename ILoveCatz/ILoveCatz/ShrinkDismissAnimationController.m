//
//  ShrinkDismissAnimationController.m
//  ILoveCatz
//
//  Created by Long Vinh Nguyen on 4/9/14.
//  Copyright (c) 2014 com.razeware. All rights reserved.
//

#import "ShrinkDismissAnimationController.h"

@implementation ShrinkDismissAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 2.0f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    UIView *containerView = [transitionContext containerView];
    
    //
    toVC.view.frame = finalFrame;
    toVC.view.alpha = 0.5f;
    
    [containerView addSubview:toVC.view];
    [containerView sendSubviewToBack:toVC.view];
    
    // Determine the intermediate and final frame for the frame view
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGRect shrunkenFrame = CGRectInset(fromVC.view.frame, fromVC.view.frame.size.width / 4, fromVC.view.frame.size.height / 4);
    CGRect fromFinalFrame = CGRectOffset(shrunkenFrame, 0.0, screenBounds.size.height);
    
    // Create a snapshot
//    UIView *intermediateView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
//    intermediateView.frame = fromVC.view.frame;
//    [fromVC.view removeFromSuperview];
//    [containerView addSubview:intermediateView];
//
    // reverse
    float factor = self.reverse? 0.5 : 1.0;
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    // animate with keyframes
    [UIView animateKeyframesWithDuration:duration delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
//            intermediateView.frame = shrunkenFrame;
            fromVC.view.transform = CGAffineTransformMakeScale(0.5 / factor, 0.5 / factor);
            toVC.view.alpha = 0.5f / factor;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
            fromVC.view.frame = fromFinalFrame;
            toVC.view.alpha = 1.0f;
        }];
    } completion:^(BOOL finished) {
//        [intermediateView removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
