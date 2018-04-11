//
//  NSDate+PCDate.h
//  PCCoreKit
//
//  Created by Mao Zhijun on 12-8-7.
//  Copyright (c) 2012年 PConline.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
	常用时间函数
	@author Mao Zhijun
 */
@interface NSDate (PCDate)

/**
	返回指定日期的yyyy-MM-dd HH:mm:ss格式
	@param  time 日期类
	@returns 返回指定日期的yyyy-MM-dd HH:mm:ss格式
 */
+ (NSString *) getDateFormatYYYYMMDDHHmmssWithTime:(NSTimeInterval)time;//yyyy-MM-dd HH:mm:ss
//yyyy-MM-dd HH:mm
+ (NSString *) getDateFormatYYYYMMDDHHmmWithTime:(NSTimeInterval)time;
//yyyy-MM-dd
+ (NSString *) getDateFormatYYYYMMDDWithTime:(NSTimeInterval)time;
//HH:MM
+ (NSString *) getDateFormatHHMMWithTime:(NSTimeInterval)time;
//根据时间返回格式
+ (NSString *)stringWithFormat:(NSString *)format withTime:(NSTimeInterval)time;

/**
	返回当前时间的yyyyMMdd格式
	@returns 返回当前时间的yyyyMMdd格式
 */
+ (NSString *) getCurrentDateWithFormatYYYYMMDD;

/**
	返回当前时区
	@returns 返回当前时区
 */
+ (NSInteger) getCurrentTimezoneWithIntPC;

/**
	@brief 返回当前月份第一天
 */
- (NSDate*)firstDayOfMonth;

/**
	@brief 返回当前月份最后一天
 */
- (NSDate*)lastDayOfMonth;

//这个月有多少周
- (NSUInteger)numberOfWeeksInCurrentMonth;

//这个月有多少天
- (NSUInteger)numberOfDaysInCurrentMonth;

//今天是星期几，默认1为星期日
- (NSUInteger)weeklyOrdinality;

- (NSDateComponents*)YMDComponents;

+ (NSDateComponents *)calendarDayWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
@end
