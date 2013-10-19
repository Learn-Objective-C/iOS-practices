//
//  Queue.m
//  ListNode
//
//  Created by Long Vinh Nguyen on 10/2/13.
//  Copyright (c) 2013 VLong. All rights reserved.
//

#import "Queue.h"

@implementation Queue

- (void)enqueue:(int)value
{
    LinkedListNode *item = [[LinkedListNode alloc] initWithData:value];
    if (!self.first) {
        self.first = item;
        self.last = item;
    } else {
        self.last.next = item;
        self.last = self.last.next;
    }
}

- (LinkedListNode *)dequeue
{
    if (!self.first) {
        LinkedListNode *item = self.first;
        self.first = self.first.next;
        return item;
    }
    
    return nil;
}

@end
