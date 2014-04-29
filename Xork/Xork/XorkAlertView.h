//
//  XorkAlertView.h
//  Xork
//
//  Created by Long Vinh Nguyen on 4/29/14.
//  Copyright (c) 2014 Pietro Rea. All rights reserved.
//

#import <UIKit/UIKit.h>
@import JavaScriptCore;

@interface XorkAlertView : UIAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message success:(JSValue *)sucessHandler failure:(JSValue *)failureHandler context:(JSContext *)context;

@end
