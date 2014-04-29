//
//  XorkAlertView.m
//  Xork
//
//  Created by Long Vinh Nguyen on 4/29/14.
//  Copyright (c) 2014 Pietro Rea. All rights reserved.
//

#import "XorkAlertView.h"

@interface XorkAlertView()<UIAlertViewDelegate>

@property (nonatomic, strong) JSContext *cxtx;
@property (nonatomic, strong) JSManagedValue *successHandler;
@property (nonatomic, strong) JSManagedValue *failureHandler;

@end

@implementation XorkAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message success:(JSValue *)sucessHandler failure:(JSValue *)failureHandler context:(JSContext *)context
{
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    if (self) {
        _cxtx = context;
        _successHandler = [JSManagedValue managedValueWithValue:sucessHandler];
        _failureHandler = [JSManagedValue managedValueWithValue:failureHandler];
        [_cxtx.virtualMachine addManagedReference:_successHandler withOwner:self];
        [_cxtx.virtualMachine addManagedReference:_failureHandler withOwner:self];
    }
    
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        JSValue *function = [_failureHandler value];
        [function callWithArguments:@[]];
    } else {
        JSValue *function = [_successHandler value];
        [function callWithArguments:@[]];
    }
    
    [self.cxtx.virtualMachine removeManagedReference:_successHandler withOwner:self];
    [self.cxtx.virtualMachine removeManagedReference:_failureHandler withOwner:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
