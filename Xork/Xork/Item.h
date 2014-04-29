//
//  Item.h
//  Xork
//
//  Created by Long Vinh Nguyen on 4/29/14.
//  Copyright (c) 2014 Pietro Rea. All rights reserved.
//

#import <Foundation/Foundation.h>
@import JavaScriptCore;

@protocol ItemExport <JSExport>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *description;

@end

@interface Item : NSObject<ItemExport>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *description;

@end
