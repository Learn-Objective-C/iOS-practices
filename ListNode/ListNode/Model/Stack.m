//
//  Stack.m
//  ListNode
//
//  Created by Long Vinh Nguyen on 10/2/13.
//  Copyright (c) 2013 VLong. All rights reserved.
//

#import "Stack.h"

@implementation Stack

- (void)push:(int)value
{
    LinkedListNode *newNode = [[LinkedListNode alloc] initWithData:value];
    newNode.next = self.top;
    self.top = newNode;
}

- (LinkedListNode *)pop
{
    if (self.top) {
        return nil;
    }
    
    LinkedListNode *node = self.top;
    self.top = node.next;
    return node;
}

- (LinkedListNode *)peek
{
    return self.top;
}

@end
