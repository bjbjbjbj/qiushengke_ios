//
//  NSDate+PCDate.m
//  PCCoreKit
//
//  Created by Mao Zhijun on 12-8-7.
//  Copyright (c) 2012年 PConline.com. All rights reserved.
//

#import "NSDate+PCDate.h"

@implementation NSDate (PCDate)

+ (NSString *) getDateFormatYYYYMMDDHHmmssWithTime:(NSTimeInterval)time
{
    return [self stringWithFormat:@"yyyy-MM-dd HH:mm:ss" withTime:time];
}

+ (NSString *) getDateFormatYYYYMMDDHHmmWithTime:(NSTimeInterval)time{
    return [self stringWithFormat:@"yyyy-MM-dd HH:mm" withTime:time];
}

+ (NSString *) getDateFormatYYYYMMDDWithTime:(NSTimeInterval)time{
    return [self stringWithFormat:@"yyyy-MM-dd" withTime:time];
}

+ (NSString *) getDateFormatHHMMWithTime:(NSTimeInterval)time{
    return [self stringWithFormat:@"HH:mm" withTime:time];
}

+ (NSString *) getCurrentDateWithFormatYYYYMMDD{
    NSDateFormatter *customDateFormatter = [[NSDateFormatter alloc] init];
    [customDateFormatter setLocale:[NSLocale currentLocale]];
    [customDateFormatter setDateFormat:@"HHmm"];
    return  [customDateFormatter stringFromDate:[NSDate date]];
}

+ (NSInteger) getCurrentTimezoneWithIntPC{
    NSInteger secondsFromGMT = [NSTimeZone systemTimeZone].secondsFromGMT;
    return secondsFromGMT%3600==0?secondsFromGMT/3600:secondsFromGMT/3600>0?secondsFromGMT/3600+1:secondsFromGMT/3600-1;
}

+ (NSString *)stringWithFormat:(NSString *)format withTime:(NSTimeInterval)time
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setLocale:[NSLocale currentLocale]];
    return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
}

- (NSDate *)firstDayOfMonth
{
    NSDate *startDate = nil;
//    BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitMonth startDate:&startDate interval:NULL forDate:self];
//    NSAssert1(ok, @"Failed to calculate the first day of the month based on %@", self);
    return startDate;
}

- (NSDate *)lastDayOfMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:self];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }
    return endDate;
}

//这个月有多少周
- (NSUInteger)numberOfWeeksInCurrentMonth
{
    NSUInteger weekday = [[self firstDayOfMonth] weeklyOrdinality];
    
    NSUInteger days = [self numberOfDaysInCurrentMonth];
    NSUInteger weeks = 0;
    
    if (weekday > 1) {
        weeks += 1, days -= (7 - weekday + 1);
    }
    
    weeks += days / 7;
    weeks += (days % 7 > 0) ? 1 : 0;
    
    return weeks;
}

//这个月有多少天
- (NSUInteger)numberOfDaysInCurrentMonth
{
    // 频繁调用 [NSCalendar currentCalendar] 可能存在性能问题
    return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length;
}

//今天是星期几，默认1为星期日
- (NSUInteger)weeklyOrdinality
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger count = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:self];
    return count;
}

- (NSDateComponents*)YMDComponents
{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //  通过已定义的日历对象，获取某个时间点的NSDateComponents表示，并设置需要表示哪些信息（NSYearCalendarUnit, NSMonthCalendarUnit, NSDayCalendarUnit等）
    NSDateComponents *dateComponents = [greCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:self];
    return dateComponents;
}

+ (NSDateComponents *)calendarDayWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    return components;
}
@end
