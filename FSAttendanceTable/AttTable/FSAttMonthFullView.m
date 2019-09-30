//
//  FSAttMonthFullView.m
//  StarMate
//
//  Created by yh.cai on 2019/7/26.
//  Copyright © 2019 fangstar.net. All rights reserved.
//

#import "FSAttMonthFullView.h"
#import "UIColor+FSUtility.h"
#import "NSString+FSUtility.h"
#import "FMUString.h"
#import "NSDate+FSUtility.h"

@implementation FSAttMonthFullView{
    NSMutableArray<FSAttCalendarModel *> * mCalendarData;
    NSInteger mMonthStartOffset;//第一个日期的星期偏移量 = firstWeek - 1
    
    CGFloat mDefTxtSize;//默认字体大小
    CGFloat mItemHeight;//itemH
    CGFloat mWeekBarHeight;//星期视图高度
    CGFloat mLineCount;//总行数 = (mCalendarData.size + mMonthStartOffset) / 7
    CGFloat mHeight;//整个视图的高度 = (mLineCount * mItemHeight) + mWeekBarHeight
    CGFloat mItemWidth;//(width - paddingStart - paddingEnd) / 7
    CGFloat mWeekTextSize;//星期字体大小
    
    CGFloat SCHEME_TEXT_SIZE;//标记字体大小
    CGFloat mRadiusBackground;//选中的背景半径
    CGFloat mRadiusForeground;//标记的背景半径
    CGFloat mRadiusPadding;//当天的背景半径Padding
    CGFloat mCurDayPointRadius;//当前的白色圆点半径
    
    UIColor * mSelectedPaint;
    UIColor * mCurDayPointPaint;
    UIColor * mWhitePoint;
    UIColor * mMonthTextPaint;
}

- (void)dealloc
{
    mSelectedPaint = nil;
    mCurDayPointPaint = nil;
    mWhitePoint = nil;
    mMonthTextPaint = nil;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self initAttrs];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initAttrs];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self initAttrs];
}

-(void)initAttrs{
    mDefTxtSize = 14;
    mItemHeight = 65;
    mWeekBarHeight = 40;
    mWeekTextSize  = 12;
    
    SCHEME_TEXT_SIZE = 10;
    mRadiusBackground = 20;
    mRadiusForeground = 18;
    mRadiusPadding = mRadiusBackground - mRadiusForeground;
    mCurDayPointRadius = 2;
    
    mLineCount = 0;
    mCalendarData = [[NSMutableArray alloc] init];
    
    mSelectedPaint = [UIColor colorWithHexString:@"EDF1FC"];
    mCurDayPointPaint = [UIColor colorWithHexString:@"215BF1"];
    mWhitePoint = [UIColor whiteColor];
    mMonthTextPaint = [UIColor colorWithHexString:@"212325"];
}

- (void)layoutSubviews{
    
    mHeight = (mLineCount * mItemHeight) + mWeekBarHeight;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, mHeight);
    
    mItemWidth = self.frame.size.width / 7;
    
    [super layoutSubviews];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [mWhitePoint set];
    CGContextFillRect(ctx, rect);
    
    [self drawWeekBar:ctx];
    
    if(mLineCount <= 0 || mCalendarData.count <= 0){
        return;
    }
    
    for(NSUInteger index = 0; index < mCalendarData.count; index++){
        FSAttCalendarModel * cal = mCalendarData[index];
        BOOL hasPre = index > 0;
        BOOL hasNext = index < mCalendarData.count - 1;
        if(hasPre){
            FSAttCalendarModel * preCal = mCalendarData[index - 1];
            hasPre = preCal.isSelected;
        }
        if(hasNext){
            FSAttCalendarModel * nextCal = mCalendarData[index + 1];
            hasNext = nextCal.isSelected;
        }
        [self draw:ctx calendar:cal row:(index + mMonthStartOffset) / 7 column:(index + mMonthStartOffset) % 7 isSelectedPre:hasPre isSelectedNext:hasNext];
    }
}

- (void)draw:(CGContextRef)canvas calendar:(FSAttCalendarModel *)calendar row:(long)row column:(long)column isSelectedPre:(BOOL)isSelectedPre isSelectedNext:(BOOL)isSelectedNext{
    CGFloat x = column * mItemWidth;
    CGFloat y = row * mItemHeight + mWeekBarHeight;

    BOOL isSelected = calendar.isSelected;
    BOOL hasScheme = [calendar hasScheme];
    
    if(isSelected) {
        [self onDrawSelected:canvas calendar:calendar x:x y:y isSelectedPre:isSelectedPre isSelectedNext:isSelectedNext];
    }
    if(hasScheme) {
        [self onDrawScheme:canvas calendar:calendar x:x y:y isSelected:isSelected];
    }
    [self onDrawText:canvas calendar:calendar x:x y:y hasScheme:hasScheme isSelected:isSelected];
    
#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCDFAInspection"
    if(ENABLE_TEST_RECT){
        CGContextSetLineWidth(canvas, 1);
        CGContextSetStrokeColorWithColor(canvas, [UIColor grayColor].CGColor);
        CGContextAddRect(canvas, CGRectMake(x, y, mItemWidth, mItemHeight));
        CGContextDrawPath(canvas, kCGPathStroke);
    }
#pragma clang diagnostic pop
}

- (void)onDrawText:(CGContextRef)canvas calendar:(FSAttCalendarModel *)calendar x:(CGFloat)x y:(CGFloat)y hasScheme:(BOOL)hasScheme isSelected:(BOOL)isSelected{
    CGFloat cx = x + mItemWidth / 2;
    CGFloat top = y + mRadiusBackground/2;
    
    if(calendar.isCurrentDay) {
        if(!hasScheme) {
            CGContextAddEllipseInRect(canvas, CGRectMake(cx - mRadiusForeground, y + mRadiusPadding, mRadiusForeground * 2, mRadiusForeground * 2));
            CGContextSetFillColorWithColor(canvas, mWhitePoint.CGColor);
            CGContextFillPath(canvas);
        }
        CGContextAddEllipseInRect(canvas, CGRectMake(cx - mRadiusForeground, y + mRadiusPadding, mRadiusForeground * 2, mRadiusForeground * 2));
        CGContextSetStrokeColorWithColor(canvas, mCurDayPointPaint.CGColor);
        CGContextStrokePath(canvas);
        
        CGContextAddEllipseInRect(canvas, CGRectMake(cx - mCurDayPointRadius,
                                                     y + mRadiusBackground * 1.75F - mCurDayPointRadius * 2,// + mRadiusPadding,
                                                     mCurDayPointRadius * 2,
                                                     mCurDayPointRadius * 2));
        if(hasScheme){
            CGContextSetFillColorWithColor(canvas, mWhitePoint.CGColor);
        }else{
            CGContextSetFillColorWithColor(canvas, mCurDayPointPaint.CGColor);
        }
        CGContextFillPath(canvas);
        NSDictionary * attrs;
        UIFont * dayFont = [UIFont systemFontOfSize:mDefTxtSize];
        NSString * dayStr = [NSString stringWithFormat:@"%@", @(calendar.day)];
        CGFloat txtW = [dayStr widthForFont:dayFont];
        UIColor * dayColor;
        if(hasScheme){
            dayColor = mWhitePoint;
        }else{
            dayColor = mCurDayPointPaint;
        }
        attrs = @{ NSFontAttributeName:dayFont, NSForegroundColorAttributeName:dayColor };
        [dayStr drawInRect:CGRectMake(cx - txtW/2, top, txtW, dayFont.lineHeight) withAttributes:attrs];
    } else {
        NSDictionary * attrs;
        UIFont * dayFont = [UIFont systemFontOfSize:mDefTxtSize];
        NSString * dayStr = [NSString stringWithFormat:@"%@", @(calendar.day)];
        CGFloat txtW = [dayStr widthForFont:dayFont];
        UIColor * dayColor;
        
        if(hasScheme){
            dayColor = mWhitePoint;
        }else if(isSelected){
            dayColor = mMonthTextPaint;
        }else if(calendar.isFutureDate){
            dayColor = [UIColor colorWithHexString:@"E1E1E1"];
        }else{
            dayColor = mMonthTextPaint;
        }
        
        attrs = @{ NSFontAttributeName:dayFont, NSForegroundColorAttributeName:dayColor };
        [dayStr drawInRect:CGRectMake(cx - txtW/2, top, txtW, dayFont.lineHeight) withAttributes:attrs];
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-parameter"
- (void)onDrawScheme:(CGContextRef)canvas calendar:(FSAttCalendarModel *)calendar x:(CGFloat)x y:(CGFloat)y isSelected:(BOOL)isSelected{
    NSMutableArray<FSAttScheme*>* schemes = calendar.schemes;
    
    CGFloat space = 6.f;
    CGFloat cx = x + mItemWidth / 2;
    UIFont * schemeFont = [UIFont systemFontOfSize:SCHEME_TEXT_SIZE];
    CGFloat txtSize = schemeFont.pointSize;
    CGFloat top = y + mRadiusBackground * 2;
    
    NSString * schemeBgColor = nil;
    for(NSUInteger index = 0; index < schemes.count; index++){
        FSAttScheme * scheme = schemes[index];
        if([FMUString isEmptyString:scheme.hexColorStr]){
            continue;
        }
        
        if(([FMUString isEmptyString:schemeBgColor] || scheme.isForeground)){
            schemeBgColor = scheme.hexColorStr;
        }
        UIColor * shcemeColor = [UIColor colorWithHexString:scheme.hexColorStr];
        NSDictionary *attrs = @{ NSFontAttributeName:schemeFont, NSForegroundColorAttributeName:shcemeColor };
        
        CGFloat txtW = [scheme.schemeStr widthForFont:schemeFont];
        
        [scheme.schemeStr drawInRect:CGRectMake((cx - space/2 - txtW) + (txtSize * index) + (space * index),
                                                top + space,
                                                txtSize,
                                                schemeFont.lineHeight)
                      withAttributes:attrs];
    }
    
    if(![FMUString isEmptyString:schemeBgColor]){
        CGContextAddEllipseInRect(canvas, CGRectMake(cx - mRadiusForeground, y + mRadiusPadding, mRadiusForeground * 2, mRadiusForeground * 2));
        CGContextSetFillColorWithColor(canvas, [UIColor colorWithHexString:schemeBgColor].CGColor);
        CGContextFillPath(canvas);
    }
}
#pragma clang diagnostic pop

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-parameter"
- (void)onDrawSelected:(CGContextRef)canvas calendar:(FSAttCalendarModel *)calendar x:(CGFloat)x y:(CGFloat)y isSelectedPre:(BOOL)isSelectedPre isSelectedNext:(BOOL)isSelectedNext{
    
    CGFloat cx = x + mItemWidth / 2;
    CGFloat cy = y + mRadiusBackground;
    if(isSelectedPre) {
        if(isSelectedNext) {
            [mSelectedPaint set];
            CGContextFillRect(canvas, CGRectMake(x, cy - mRadiusBackground, mItemWidth, mRadiusBackground * 2));
        } else {//最后一个，the last
            [mSelectedPaint set];
            CGContextFillRect(canvas, CGRectMake(x, cy - mRadiusBackground, mItemWidth / 2, mRadiusBackground * 2));
            
            CGContextAddArc(canvas, cx, cy, mRadiusBackground, -M_PI_2, M_PI_2, 0);
            CGContextSetFillColorWithColor(canvas, mSelectedPaint.CGColor);
            CGContextFillPath(canvas);
        }
    } else {
        if(isSelectedNext) {
            [mSelectedPaint set];
            CGContextFillRect(canvas, CGRectMake(cx, cy - mRadiusBackground, mItemWidth, mRadiusBackground * 2));
        }
        CGContextAddEllipseInRect(canvas, CGRectMake(cx - mRadiusBackground, cy - mRadiusBackground, mRadiusBackground * 2, mRadiusBackground * 2));
        CGContextSetFillColorWithColor(canvas, mSelectedPaint.CGColor);
        CGContextFillPath(canvas);
    }
}
#pragma clang diagnostic pop

- (void)drawWeekBar:(CGContextRef)canvas{
    UIColor * color = [UIColor colorWithHexString:@"CFD3DE"];
    UIFont * font = [UIFont systemFontOfSize:mDefTxtSize];
    NSDictionary * weekAttrs = @{ NSFontAttributeName:font, NSForegroundColorAttributeName:color };
    
    for(int week = 0;week < 7;week++){
        NSString * weekStr;
        switch (week) {
            case 0:
                weekStr = @"一";
                break;
            case 1:
                weekStr = @"二";
                break;
            case 2:
                weekStr = @"三";
                break;
            case 3:
                weekStr = @"四";
                break;
            case 4:
                weekStr = @"五";
                break;
            case 5:
                weekStr = @"六";
                break;
            case 6:
                weekStr = @"日";
                break;
            default:break;
        }
        
        CGFloat txtW = [weekStr widthForFont:font];
        CGRect weekRect = CGRectMake(week * mItemWidth + ((mItemWidth - txtW) / 2), (mWeekBarHeight - font.lineHeight) / 2, txtW, mWeekBarHeight);
        [weekStr drawInRect:weekRect withAttributes:weekAttrs];
        
#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCDFAInspection"
        if(ENABLE_TEST_RECT){
            CGContextSetLineWidth(canvas, 1);
            CGContextSetStrokeColorWithColor(canvas, [UIColor redColor].CGColor);
            CGContextAddRect(canvas, CGRectMake(week * mItemWidth, 0, mItemWidth, mWeekBarHeight));
            CGContextDrawPath(canvas, kCGPathStroke);
        }
#pragma clang diagnostic pop
        
    }
}

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"
- (CGFloat)getViewH{
    return mHeight;
}
#pragma clang diagnostic pop

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"
- (void)setupData:(NSMutableArray<FSAttCalendarModel *> *)calendarModelArr{
    if([calendarModelArr count] <= 0){
        return;
    }
    
    NSArray * sortedCalendarArr = [calendarModelArr sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2){
        if([obj1 isKindOfClass:FSAttCalendarModel.class] && [obj2 isKindOfClass:FSAttCalendarModel.class]){
            FSAttCalendarModel* cal1 = (FSAttCalendarModel *)obj1;
            FSAttCalendarModel* cal2 = (FSAttCalendarModel *)obj2;
            
            if(cal1.time <= 0 || cal2.time <= 0){
                return NSOrderedSame;
            }
            if(cal1.time > cal2.time){
                return NSOrderedDescending;
            }else if(cal1.time == cal2.time){
                return NSOrderedSame;
            }else{
                return NSOrderedAscending;
            }
        }else{
            return NSOrderedSame;
        }
    }];

    [mCalendarData removeAllObjects];
    [mCalendarData addObjectsFromArray:sortedCalendarArr];
    
    FSAttCalendarModel * firstCal = mCalendarData[0];
    
    NSInteger firstWeek = [[NSDate dateWithTimeIntervalSince1970:firstCal.time] weekday] - 1;
    mMonthStartOffset = firstWeek - 1;
    if(mMonthStartOffset < 0){
        mMonthStartOffset += 7;
    }
    
    NSInteger count = mCalendarData.count + mMonthStartOffset;
    mLineCount = count / 7;
    if(count % 7 > 0){
        mLineCount++;
    }
    
    NSDate * now = [NSDate date];
    for(FSAttCalendarModel * cal in mCalendarData){
        cal.isCurrentDay = NO;
        cal.isFutureDate = NO;
        if(cal.year > now.year || cal.month > now.month || cal.day > now.day){
            cal.isFutureDate = YES;
            continue;
        }
        if(cal.year == now.year){
            if(cal.month == now.month){
                if(cal.day == now.day){
                    cal.isCurrentDay = YES;
                }
            }
        }
    }
    
    mHeight = (mLineCount * mItemHeight) + mWeekBarHeight;
    
    [self setNeedsLayout];
    [self setNeedsDisplay];
}
#pragma clang diagnostic pop

@end
