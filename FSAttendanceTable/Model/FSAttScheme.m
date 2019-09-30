//
// Created by yh.cai on 2019/9/29.
// Copyright (c) 2019 fangstar. All rights reserved.
//

#import "FSAttScheme.h"


@implementation FSAttScheme {

}

+ (instancetype)initWithStatus:(FSAttCheckStatus)status {
    FSAttScheme *scheme = [[FSAttScheme alloc] init];

    switch (status) {
        case FSAttCheckStatus_ASK_FOR_LEAVE: {
            scheme.hexColorStr = @"215BF1";
            scheme.schemeStr = @"假";
            scheme.isForeground = true;
        }
            break;
        case FSAttCheckStatus_REST: {
            scheme.hexColorStr = @"215BF1";
            scheme.schemeStr = @"休";
            scheme.isForeground = true;
        }
            break;
        case FSAttCheckStatus_GO_OUT: {
            scheme.hexColorStr = @"215BF1";
            scheme.schemeStr = @"外";
            scheme.isForeground = true;
        }
            break;
        case FSAttCheckStatus_BE_LATE: {
            scheme.hexColorStr = @"FD3A47";
            scheme.schemeStr = @"迟";
            scheme.isForeground = true;
        }
            break;
        case FSAttCheckStatus_LEAVE_EARLY: {
            scheme.hexColorStr = @"FD3A47";
            scheme.schemeStr = @"退";
            scheme.isForeground = true;
        }
            break;
        case FSAttCheckStatus_NOT_PRESENT: {
            scheme.hexColorStr = @"FD3A47";
            scheme.schemeStr = @"旷";
            scheme.isForeground = true;
        }
            break;
        case FSAttCheckStatus_HOLIDAY: {
            scheme.hexColorStr = @"B5B6BA";
            scheme.schemeStr = @"节";
            scheme.isForeground = false;
        }
            break;
        default:
            return scheme;
    }

    return scheme;
}

@end