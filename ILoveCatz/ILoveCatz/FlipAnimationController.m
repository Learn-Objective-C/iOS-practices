//
//  FlipAnimationController.m
//  ILoveCatz
//
//  Created by Long Vinh Nguyen on 4/9/14.
//  Copyright (c) 2014 com.razeware. All rights reserved.
//

#import "FlipAnimationController.h"

@implementation FlipAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0f;
}

- (CATransform3D)yRotation:(CGFloat)angle
{
    return CATransform3DMakeRotation(angle, 0.0, 1.0, 0.0);
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    UIView *fromView = fromVC.view;
    [containerView addSubview:toVC.view];
    
    // add a perspective transform
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1/500.0f;
    [containerView.layer setSublayerTransform:transform];
    
    // reverse
    float factor = self.reverse? 1.0 : -1.0;
    
    // flip the to VC halfway round - hiding it
    toView.layer.transform = [self yRotation:factor * -M_PI_2];
    
    // Give both VCs the same start frame
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateKeyframesWithDuration:duration delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.5 animations:^{
            fromView.layer.transform = [self yRotation:factor * -M_PI_2];
        }];
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
            toView.layer.transform = [self yRotation:0.0];
        }];
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
