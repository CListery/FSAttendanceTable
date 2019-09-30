//
// Created by yh.cai on 2019/9/29.
// Copyright (c) 2019 fangstar. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIColor;


@interface FSAttStatusCons : NSObject

#pragma mark - 控制显示自定义view绘制区域
#define ENABLE_TEST_RECT NO

typedef NS_ENUM(NSInteger, FSAttCheckStatus) {
    FSAttCheckStatus_UNKNOWN = 0,
    FSAttCheckStatus_NO_CHECK,
    FSAttCheckStatus_CHECK,
    FSAttCheckStatus_ASK_FOR_LEAVE,
    FSAttCheckStatus_REST,
    FSAttCheckStatus_GO_OUT,
    FSAttCheckStatus_BE_LATE,
    FSAttCheckStatus_LEAVE_EARLY,
    FSAttCheckStatus_NOT_PRESENT,
    FSAttCheckStatus_HOLIDAY
};

+(UIColor *)getStatusColor:(FSAttCheckStatus)status;

@end