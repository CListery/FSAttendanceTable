//
// Created by yh.cai on 2019/9/29.
// Copyright (c) 2019 fangstar. All rights reserved.
//

#import "FSAttCalendarModel.h"
#import "FMUString.h"
#import "NSDate+FSUtility.h"

@implementation FSAttCalendarModel

+ (instancetype)initWithTime:(NSTimeInterval)time {
    FSAttCalendarModel *cal = [[FSAttCalendarModel alloc] init];

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];

    cal.time = date.timeIntervalSince1970;
    cal.year = date.year;
    cal.month = date.month;
    cal.day = date.day;

    return cal;
}

- (BOOL)isEqual:(id)object {
    if (nil == object) {
        return NO;
    }
    if ([object isKindOfClass:FSAttCalendarModel.class]) {
        FSAttCalendarModel *model = object;
        if (model.year == self.year && model.month == self.month && model.day == self.day) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)hasScheme {
    if ([self.schemes count] > 0) {
        for (FSAttScheme *scheme in self.schemes) {
            if (![FMUString isEmptyString:scheme.hexColorStr]) {
                return YES;
            }
        }
    }
    return NO;
}

@end