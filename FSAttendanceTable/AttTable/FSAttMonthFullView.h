//
//  FSAttMonthFullView.h
//  StarMate
//
//  Created by yh.cai on 2019/7/26.
//  Copyright © 2019 fangstar.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSAttCalendarModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FSAttMonthFullView : UIView

- (void)setupData:(NSMutableArray<FSAttCalendarModel *> *)calendarModelArr;

- (CGFloat)getViewH;

@end

NS_ASSUME_NONNULL_END
