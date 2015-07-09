//
//  WXCondition.h
//  SimpleWeather
//
//  Created by 徐杨 on 15/7/5.
//  Copyright (c) 2015年 xuyang. All rights reserved.
//

#import <Mantle.h>

@interface WXCondition : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSDate *date;     // 日期
@property (nonatomic, strong) NSNumber *humidity;   // 湿度
@property (nonatomic, strong) NSNumber *temperature;    // 温度
@property (nonatomic, strong) NSNumber *tempHigh;   // 最高温度
@property (nonatomic, strong) NSNumber *tempLow;    // 最低温度
@property (nonatomic, strong) NSString *locationName;   // 定位
@property (nonatomic, strong) NSDate *sunrise;  // 日出时间
@property (nonatomic, strong) NSDate *sunset;   // 日落时间
@property (nonatomic, strong) NSString *conditionDescription;
@property (nonatomic, strong) NSString *condition;
@property (nonatomic, strong) NSNumber *windBear;   // 风力
@property (nonatomic, strong) NSNumber *windSpeed;  // 风速
@property (nonatomic, strong) NSString *icon;

- (NSString *)imageName;

@end
