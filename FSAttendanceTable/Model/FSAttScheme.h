//
// Created by yh.cai on 2019/9/29.
// Copyright (c) 2019 fangstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSAttStatusCons.h"


@interface FSAttScheme : NSObject

@property(nonatomic, strong) NSString *hexColorStr; //
@property(nonatomic, strong) NSString *schemeStr; //
@property(nonatomic, assign) BOOL isForeground;

+ (instancetype)initWithStatus:(FSAttCheckStatus)status;

@end