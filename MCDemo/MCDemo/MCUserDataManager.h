//
//  MCUserDataManager.h
//  MCDemo
//
//  Created by LongNV on 7/11/14.
//  Copyright (c) 2014 Home Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCUserDataManager : NSObject

+ (instancetype)shared;

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, strong) UIImage *avatarImage;
@property (nonatomic, strong) UIImage *avatarIcon;

@end
