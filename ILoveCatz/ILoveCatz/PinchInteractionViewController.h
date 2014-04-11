//
//  PinchInteractionViewController.h
//  ILoveCatz
//
//  Created by Long Vinh Nguyen on 4/9/14.
//  Copyright (c) 2014 com.razeware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PinchInteractionViewController : UIPercentDrivenInteractiveTransition


- (void)wireToViewController:(UIViewController *)viewController;

@property (nonatomic, assign) BOOL interactionInProgress;

@end
