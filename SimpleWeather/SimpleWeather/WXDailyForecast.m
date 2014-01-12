//
//  WXDailyForecast.m
//  SimpleWeather
//
//  Created by Long Vinh Nguyen on 1/11/14.
//  Copyright (c) 2014 VLong. All rights reserved.
//

#import "WXDailyForecast.h"

@implementation WXDailyForecast


+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSMutableDictionary *paths = [[super JSONKeyPathsByPropertyKey] mutableCopy];
    paths[@"tempHigh"] = @"temp.max";
    paths[@"tempLow"] = @"temp.min";
    
    return paths;
}


@end
