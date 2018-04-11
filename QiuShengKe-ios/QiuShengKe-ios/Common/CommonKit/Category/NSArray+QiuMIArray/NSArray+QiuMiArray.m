//
//  NSArray+QiuMiArray.m
//  Qiumi
//
//  Created by Viper on 16/3/9.
//  Copyright © 2016年 51viper.com. All rights reserved.
//

#import "NSArray+QiuMiArray.h"

@implementation NSArray (QiuMiArray)

+ (NSArray *)orderForTheDateArray:(NSArray *)array{
    //日期数组
    NSArray *keyArr = [array copy];
    //排序
    keyArr = [keyArr sortedArrayUsingComparator:^(NSString * obj1, NSString * obj2){
        //日期排序
        return (NSComparisonResult)[obj2 compare:obj1 options:NSNumericSearch];
    }];
    return keyArr;
}

+ (NSArray *)gradeForTheDateArray:(NSArray *)array{
    //日期数组
    NSArray *keyArr = [array copy];
    //排序
    keyArr = [keyArr sortedArrayUsingComparator:^(NSString * obj1, NSString * obj2){
        //比赛日期排序
        return (NSComparisonResult)[obj1 compare:obj2 options:NSNumericSearch];
    }];
    return keyArr;
}

@end
