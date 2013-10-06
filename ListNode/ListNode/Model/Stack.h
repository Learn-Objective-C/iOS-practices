//
//  Stack.h
//  ListNode
//
//  Created by Long Vinh Nguyen on 10/2/13.
//  Copyright (c) 2013 VLong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LinkedListNode.h"

@interface Stack : NSObject

@property (nonatomic, strong) LinkedListNode *top;

- (void)push:(int)value;
- (LinkedListNode *)pop;
- (LinkedListNode *)peek;

@end
