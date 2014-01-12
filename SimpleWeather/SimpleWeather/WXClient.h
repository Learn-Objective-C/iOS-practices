//
//  WXClient.h
//  SimpleWeather
//
//  Created by Long Vinh Nguyen on 1/12/14.
//  Copyright (c) 2014 VLong. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;
@import Foundation;
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface WXClient : NSObject

- (RACSignal *)fetchJSONfromURL:(NSURL *)url;
- (RACSignal *)fetchCurrentConditionsforLocation:(CLLocationCoordinate2D)coordinate;
- (RACSignal *)fetchHourlyForecastForLocation:(CLLocationCoordinate2D)coordinate;
- (RACSignal *)fetchDailyForecastForLocation:(CLLocationCoordinate2D)coordinate;

@end
