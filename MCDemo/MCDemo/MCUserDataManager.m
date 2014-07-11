//
//  MCUserDataManager.m
//  MCDemo
//
//  Created by LongNV on 7/11/14.
//  Copyright (c) 2014 Home Inc. All rights reserved.
//

#import "MCUserDataManager.h"

@implementation MCUserDataManager

+ (instancetype)shared
{
    static MCUserDataManager *userManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userManager = [[MCUserDataManager alloc] init];
    });
    
    return userManager;
}

- (UIImage *)avatarIcon
{
    if (!_avatarIcon) {
        UIGraphicsBeginImageContext(CGSizeMake(34, 34));
        [_avatarImage drawInRect:CGRectMake(0, 0, 34, 34)];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        _avatarImage = image;
    }
    
    return _avatarIcon;
}


- (UIImage *)avatarImage
{
    if (!_avatarImage) {
        return [UIImage imageNamed:@"anonymous"];
    }
    
    return _avatarImage;
}

- (NSString *)userName
{
    if (!_userName) {
        _userName = [UIDevice currentDevice].name;
    }
    
    return _userName;
}

@end
