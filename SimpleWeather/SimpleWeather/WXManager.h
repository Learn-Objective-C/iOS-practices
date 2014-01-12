//
//  WXManager.h
//  SimpleWeather
//
//  Created by Long Vinh Nguyen on 1/12/14.
//  Copyright (c) 2014 VLong. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;
@import Foundation;
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "WXCondition.h"

@interface WXManager : NSObject<CLLocationManagerDelegate>

+ (instancetype)sharedManager;

@property (nonatomic, strong, readonly) CLLocation *currentLocation;
@property (nonatomic, strong, readonly) WXCondition *currentCondition;
@property (nonatomic, strong, readonly) NSArray *hourlyForecast;
@property (nonatomic, strong, readonly) NSArray *dailyForecast;


- (void)findCurrentLocation;

@end
