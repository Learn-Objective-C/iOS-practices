//
//  main.m
//  ListNode
//
//  Created by VisiKard MacBook Pro on 9/5/13.
//  Copyright (c) 2013 VLong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model/LinkedListNode.h"


void printInfoListNode(LinkedListNode *head)
{
    while (head != nil) {
        NSLog(@"node data %d", head.data);
        head = head.next;
    }
}

void printReverseInfoList(LinkedListNode *head)
{
    if (head !=nil) {
        printReverseInfoList(head.next);
        NSLog(@"Reverse data %d", head.data);
    }
}

int deleteDuplicateNodes(LinkedListNode *head)
{
    if (head == nil) {
        return 0;
    }
    
    NSMutableSet *mySet = [NSMutableSet new];
    LinkedListNode *previous = nil;
    while (head != nil) {
        if ([mySet containsObject:@(head.data)]) {
            previous.next = head.next;
        } else {
            [mySet addObject:@(head.data)];
            previous = head;
        }
        head = head.next;
    }
    return 0;
}

BOOL deleteNode(LinkedListNode *node)
{
    if (node == nil) return false;
    
    LinkedListNode *nextNode = node.next;
    node.data = nextNode.data;
    node.next = nextNode.next;
    
    return true;
}

LinkedListNode * kthElementFromLast(LinkedListNode *head, int k, int *i)
{
    if (head == nil) {
        return NULL;
    }
    
    LinkedListNode *node = kthElementFromLast(head.next, k, i);
    *i = *i + 1;
    
    if (*i == k) {
        return head;
    }
    
    return node;
}

LinkedListNode * partitionList(LinkedListNode *head, int number)
{
    LinkedListNode *beforeStart = nil;
    LinkedListNode *beforeEnd = nil;
    LinkedListNode *afterStart = nil;
    LinkedListNode *afterEnd = nil;
    

    
    while (head != nil) {
        LinkedListNode *nextNode = head.next;
        head.next = nil;
        
        if (head.data < number) {
            if (beforeStart == nil) {
                beforeStart = head;
                beforeEnd = head;
            } else {
                beforeEnd.next = head;
                beforeEnd = head;
            }
        } else {
            if (afterStart == nil) {
                afterStart = head;
                afterEnd = head;
            } else {
                afterEnd.next = head;
                afterEnd = head;
            }
        }
        
        head = nextNode;
    }
    
    if (beforeStart == nil) {
        return afterStart;
    }
    
    beforeEnd.next = afterStart;
    
    return beforeStart;
}

LinkedListNode  *insertBeforeNode(LinkedListNode *node, int data)
{
    LinkedListNode *newNode = [[LinkedListNode alloc] initWithData:data];
    if (node != nil) {
        newNode.next = node;
    }
    return newNode;
}


LinkedListNode *addList(LinkedListNode *l1, LinkedListNode *l2, int carry)
{
    if (l1 == nil && l2 == nil) return nil;
    
    int value = carry;
    
    if (l1 != nil) {
        value += l1.data;
    }
    
    if (l2 != nil) {
        value += l2.data;
    }
    
    int result = value % 10;

    
    LinkedListNode *node = [[LinkedListNode alloc] initWithData:result];
    
//    if (l1.next == nil && l2.next == nil) {
//        if (value > 10) {
//            [node appendToTailWithData:value/10];
//            printInfoListNode(node);
//        }
//    }
//    node.next = addList(l1.next?l1.next:nil, l2.next?l2.next:nil, value/10?1:0);
    

    if (l1 != nil || l2 != nil) {
        LinkedListNode *more = addList(l1.next?l1.next:nil, l2.next?l2.next:nil, value>10?1:0);
        node.next = more;
    }
        
    return node;
}

void bubleSort(NSMutableArray *listNumbers)
{
    BOOL swapped = false;
    do {
        swapped = false;
        for (int i = 1; i < listNumbers.count; i++) {
            if ([listNumbers[i] compare:listNumbers[i - 1]] == NSOrderedAscending) {
                NSNumber *temp = listNumbers[i-1];
                listNumbers[i-1] = listNumbers[i];
                listNumbers[i] = temp;
                swapped = true;
            }
        }
    } while (swapped);
}

LinkedListNode *getLoopStartOfCircularLinkList(LinkedListNode *head)
{
    LinkedListNode *slow = head;
    LinkedListNode *fast = head;
    
    while (fast != nil) {
        slow = slow.next;
        fast = fast.next.next;
        
        if (slow == fast) {
            break;
        }
    }
    
    if (slow == nil || slow.next == nil) {
        return nil;
    }
    
    slow = head;

    while (slow != fast) {
        slow = slow.next;
        fast = fast.next;
    }

    return slow;

}

BOOL isListNodePalindrome(LinkedListNode *head)
{
    LinkedListNode *slow = head;
    LinkedListNode *fast = head;
    
    NSMutableArray *stack = [NSMutableArray new];
    while (fast != nil && fast.next != nil) {
        [stack addObject:slow];
        slow = slow.next;
        fast = fast.next.next;
    }
    
    if (fast != nil) {
        slow = slow.next;
    }
    
    while (slow != nil) {
        LinkedListNode *node = [stack lastObject];
        [stack removeLastObject];
        if (node.data != slow.data) {
            return false;
        }
        slow = slow.next;
    }

    return true;
}

@interface PartialSum : NSObject

@property (nonatomic, strong) LinkedListNode *sum;
@property (nonatomic, assign) int carry;

@end

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        LinkedListNode *head = [[LinkedListNode alloc] initWithData:7];
        [head appendToTailWithData:18];
        [head appendToTailWithData:90];
        [head appendToTailWithData:10];
        LinkedListNode *a =  [head appendToTailWithData:11];
        [head appendToTailWithData:10];
        [head appendToTailWithData:18];
        
        int i =0;
        LinkedListNode *node = kthElementFromLast(head, 5, &i);
        NSLog(@"Node %d", node.data);
        
        NSLog(@"--------Print Forward------");
        printInfoListNode(head);
        
        NSLog(@"--------Print Backward------");
        printReverseInfoList(head);
        
        NSLog(@"--------Tail------");
        LinkedListNode *tail = [head getTail];
        printInfoListNode(tail);
        
        deleteNode(a);
        
        NSLog(@"--------After delete------");
        printInfoListNode(head);
        
        NSLog(@"--------After delete duplicate------");
        deleteDuplicateNodes(head);
        printInfoListNode(head);
        
        
        NSLog(@"--------Partition List------");
        LinkedListNode *partitionListNode = partitionList(head, 70);
        printInfoListNode(partitionListNode);
        
//        LinkedListNode *list1 = [[LinkedListNode alloc] initWithData:7];
//        [list1 appendToTailWithData:2];
//        [list1 appendToTailWithData:6];
//        
//        LinkedListNode *list2 = [[LinkedListNode alloc] initWithData:5];
//        [list2 appendToTailWithData:9];
//        [list2 appendToTailWithData:2 ];
        
        LinkedListNode *list1 = [[LinkedListNode alloc] initWithData:6];
        [list1 appendToTailWithData:2];
        [list1 appendToTailWithData:7];
        
        LinkedListNode *list2 = [[LinkedListNode alloc] initWithData:2];
        [list2 appendToTailWithData:9];
        [list2 appendToTailWithData:5];

        
        
        
        NSLog(@"--------Add List------");
        LinkedListNode *sumNode = addList(list1, list2, 0);
        printInfoListNode(sumNode);
        
        NSMutableArray *numbers = [NSMutableArray arrayWithObjects:@(5), @(9),@(8),@(7), @(2), @(100), @(9), @(78), @(6), nil];
        NSLog(@"--------Before bublle sort------");
        NSLog(@"%@", numbers);
        bubleSort(numbers);
        NSLog(@"--------After bublle sort------");
        NSLog(@"%@", numbers);
        
        
        LinkedListNode *list3 = [[LinkedListNode alloc] initWithData:1];
        [list3 appendToTailWithData:2];
        LinkedListNode *node1 = [list3 appendToTailWithData:5];
        [list3 appendToTailWithData:6];
        LinkedListNode *lastNode = [list3 appendToTailWithData:8];
        lastNode.next = node1;
        
        NSLog(@"--------Get Loop Node------");
        LinkedListNode *loopNode = getLoopStartOfCircularLinkList(list3);
        NSLog(@"%d", loopNode.data);
        
        NSLog(@"--------Check List Node Palindrome-----");
        LinkedListNode *list4 = [[LinkedListNode alloc] initWithData:0];
        [list4 appendToTailWithData:1];
        [list4 appendToTailWithData:1];
        [list4 appendToTailWithData:0];
        
        if (isListNodePalindrome(list4)) {
            NSLog(@"This is Palindrome list");
        } else {
            NSLog(@"This is not Palindrome list");
        }
        
        
        
        
    }
    return 0;
}




