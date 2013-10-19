//
//  Queue.h
//  ListNode
//
//  Created by Long Vinh Nguyen on 10/2/13.
//  Copyright (c) 2013 VLong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LinkedListNode.h"

@interface Queue : NSObject

@property (nonatomic, strong) LinkedListNode *first;
@property (nonatomic, strong) LinkedListNode *last;

- (void)enqueue:(int)value;
- (LinkedListNode *)dequeue();

@end
