//
// Created by yh.cai on 2019/9/29.
// Copyright (c) 2019 fangstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSAttScheme.h"

@interface FSAttCalendarModel : NSObject

@property (nonatomic, assign) NSTimeInterval time;//时间戳

@property (nonatomic, assign) NSInteger year; //年
@property (nonatomic, assign) NSInteger month; //月
@property (nonatomic, assign) NSInteger day; //日

@property (nonatomic, assign) BOOL isSelected; //
@property (nonatomic, assign) BOOL isCurrentDay; // 是否是今天
@property (nonatomic, assign) BOOL isFutureDate; // 是否是未来日期

@property (nonatomic, strong) NSMutableArray<FSAttScheme *> * schemes; // 多标记

@property (nonatomic, weak) id obj;

+ (instancetype)initWithTime:(NSTimeInterval)time;
- (BOOL)hasScheme;

@end