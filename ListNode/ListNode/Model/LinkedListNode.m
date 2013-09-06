//
//  LinkedListNode.m
//  ListNode
//
//  Created by VisiKard MacBook Pro on 9/5/13.
//  Copyright (c) 2013 VLong. All rights reserved.
//

#import "LinkedListNode.h"

@implementation LinkedListNode

- (id)initWithData:(int)data
{
    if (self = [super init]) {
        self.data = data;
    }
    
    return self;
}

- (id)init
{
    return [self initWithData:0];
}

- (LinkedListNode *)appendToTailWithData:(int)data
{
    LinkedListNode *newNode = [[LinkedListNode alloc] initWithData:data];
    LinkedListNode *current = self;
    while (current.next != nil) {
        current = current.next;
    }
    current.next = newNode;
    return newNode;
}

- (LinkedListNode *)deleteNodeData:(int)data headNode:(LinkedListNode *)head
{
    if (head == nil) return nil;
        
    if (head.data == data) {
        return head.next;
    }
    
    LinkedListNode *node = head;
    while (node.next != nil) {
        if (node.next.data == data) {
            NSLog(@"Found");
            node.next = node.next.next;
        }
        node = node.next;
    }
    
    return head;
}

- (LinkedListNode *)getTail
{
    LinkedListNode *currentNode = self;
    while (currentNode.next != nil) {
        currentNode = currentNode.next;
    }
    
    return currentNode;
    
}

@end
