//
//  LinkedListNode.h
//  ListNode
//
//  Created by VisiKard MacBook Pro on 9/5/13.
//  Copyright (c) 2013 VLong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LinkedListNode : NSObject

@property (nonatomic, strong) LinkedListNode *next;
@property (nonatomic, assign) int data;

- initWithData:(int)data;
- (LinkedListNode *)appendToTailWithData:(int32_t)data;
- (LinkedListNode *)deleteNodeData:(int)data headNode:(LinkedListNode *)head;
- (LinkedListNode *)getTail;

@end
