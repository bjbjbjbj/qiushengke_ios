//
//  NSUserDefaults+UserDefaults.m
//  PCCoreKit
//
//  Created by Mao Zhijun on 12-8-7.
//  Copyright (c) 2012年 PConline.com. All rights reserved.
//

#import "NSUserDefaults+PCUserDefaults.h"

#define kPCUserDefaultCommonKey  @"PCCommonKey"

@implementation NSUserDefaults (PCUserDefaults)

//访问NSUserDefaults的公共数据
+ (id) getObjectFromNSUserDefaultsWithKeyPC:(NSString *)key
{
    return [[[NSUserDefaults standardUserDefaults] dictionaryForKey:kPCUserDefaultCommonKey] objectForKey:key];
}

+ (void) setObjectToNSUserDefaultsPC:(id)object withKey:(NSString *)key
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (object == nil) {
        return;
    }
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:[ud dictionaryForKey:kPCUserDefaultCommonKey]];
    [mDic setObject:object forKey:key];
    [ud setObject:mDic forKey:kPCUserDefaultCommonKey];
    [ud synchronize];
}

+ (void) removeObjectFromNSUserDefaultsWithKeyPC:(NSString *)key
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:[ud dictionaryForKey:kPCUserDefaultCommonKey]];
    [mDic removeObjectForKey:key];
    [ud setObject:mDic forKey:kPCUserDefaultCommonKey];
    [ud synchronize];
}

@end
