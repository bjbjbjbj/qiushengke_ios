//
//  NSArray+QiuMiArray.h
//  Qiumi
//
//  Created by Viper on 16/3/9.
//  Copyright © 2016年 51viper.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (QiuMiArray)

/*
 日期升序
 */
+ (NSArray *)orderForTheDateArray:(NSArray *)array;

/*
 日期降序
 */
+ (NSArray *)gradeForTheDateArray:(NSArray *)array;

@end
