//
//  WXManager.h
//  SimpleWeather
//
//  Created by 徐杨 on 15/7/5.
//  Copyright (c) 2015年 xuyang. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "WXCondition.h"

@interface WXManager : NSObject <CLLocationManagerDelegate>

+ (instancetype)sharedManager;

@property (nonatomic, strong, readonly) CLLocation *currentLocation;
@property (nonatomic, strong, readonly) WXCondition *currentCondition;
@property (nonatomic, strong, readonly) NSArray *hourlyForecast;
@property (nonatomic, strong, readonly) NSArray *dailyForecast;

- (void)findCurrentLocation;

@end
