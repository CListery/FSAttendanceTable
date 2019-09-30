//
// Created by yh.cai on 2019/9/29.
// Copyright (c) 2019 fangstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (FSUtility)

+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format;

@property (nonatomic, readonly) NSInteger year; ///< Year component
@property (nonatomic, readonly) NSInteger month; ///< Month component (1~12)
@property (nonatomic, readonly) NSInteger day; ///< Day component (1~31)
@property (nonatomic, readonly) NSInteger hour; ///< Hour component (0~23)
@property (nonatomic, readonly) NSInteger minute; ///< Minute component (0~59)
@property (nonatomic, readonly) NSInteger second; ///< Second component (0~59)
@property (nonatomic, readonly) NSInteger weekday; ///< Weekday component (1~7, first day is based on user setting)

@property (nonatomic, readonly) NSInteger weekOfMonth; ///< WeekOfMonth component (1~5)

@property (nonatomic, readonly) NSInteger dayOfMonth; //

@end