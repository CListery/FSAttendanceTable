//
// Created by yh.cai on 2019/9/29.
// Copyright (c) 2019 fangstar. All rights reserved.
//

#import "FMUString.h"


@implementation FMUString

+ (BOOL)isEmptyString:(NSString *)_str {
    return nil == _str || _str.length <= 0;
}

@end