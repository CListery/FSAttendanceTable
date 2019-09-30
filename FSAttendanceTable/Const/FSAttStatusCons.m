//
// Created by yh.cai on 2019/9/29.
// Copyright (c) 2019 fangstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSAttStatusCons.h"
#import "UIColor+FSUtility.h"


@implementation FSAttStatusCons

+ (UIColor *)getStatusColor:(FSAttCheckStatus)status {
    switch (status) {
        case FSAttCheckStatus_UNKNOWN:
            return [UIColor colorWithHexString:@"FF0000"];
        case FSAttCheckStatus_NO_CHECK:
            return [UIColor colorWithHexString:@"FF0000"];
        case FSAttCheckStatus_CHECK:
            return [UIColor colorWithHexString:@"212425"];
        case FSAttCheckStatus_ASK_FOR_LEAVE:
            return [UIColor colorWithHexString:@"449156"];
        case FSAttCheckStatus_REST:
            return [UIColor colorWithHexString:@"449156"];
        case FSAttCheckStatus_GO_OUT:
            return [UIColor colorWithHexString:@"449156"];
        case FSAttCheckStatus_BE_LATE:
            return [UIColor colorWithHexString:@"FC7A32"];
        case FSAttCheckStatus_LEAVE_EARLY:
            return [UIColor colorWithHexString:@"FD3A47"];
        case FSAttCheckStatus_NOT_PRESENT:
            return [UIColor colorWithHexString:@"FD3A47"];
        case FSAttCheckStatus_HOLIDAY:
            return [UIColor colorWithHexString:@"212425"];
        default:
            return [UIColor colorWithHexString:@"212325"];
    }
}


@end