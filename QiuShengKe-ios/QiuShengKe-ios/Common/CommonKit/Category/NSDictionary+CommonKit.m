//
//  NSDictionary+CommonKit.m
//  Qiumi
//
//  Created by xieweijie on 16/8/22.
//  Copyright © 2016年 51viper.com. All rights reserved.
//

#import "NSDictionary+CommonKit.h"

@implementation NSDictionary (CommonKit)
- (NSString *)stringForKey:(NSString *)key
{
    return [self stringForKey:key withDefault:@""];
}

- (BOOL)existForKey:(NSString *)key{
    if ([[self objectForKey:key] isKindOfClass:[NSNull class]]) {
        return false;
    }
    
    if (nil == [self objectForKey:key]) {
        return false;
    }
    
    return true;
}

- (NSString *)stringForKey:(NSString *)key withDefault:(NSString *)defaultString
{
    if (nil == defaultString) {
        defaultString = @"";
    }
    
    if ([[self objectForKey:key] isKindOfClass:[NSNull class]]) {
        return defaultString;
    }
    
    NSString* result = @"";
    if ([self objectForKey:key]) {
        result = [NSString stringWithFormat:@"%@",[self objectForKey:key]];
    }
    if (nil == result) {
        result = defaultString;
        return result;
    }
    if ([result length] == 0) {
        result = defaultString;
    }
    return result;
}

- (float)floatForKey:(NSString *)key
{
    id result = [self objectForKey:key];
    
    if (result == [NSNull null]) {
        return 0;
    }
    
    if (result) {
        return [result floatValue];
    }
    return 0;
}


- (NSInteger)integerForKey:(NSString *)key
{
    id result = [self objectForKey:key];
    
    if (result == [NSNull null]) {
        return 0;
    }
    
    if (result) {
        return [result integerValue];
    }
    return 0;
}

+ (NSDictionary *)httpParametersWithUri:(NSString *)uri
{
    if ([[uri componentsSeparatedByString:@"?"] count] == 2) {
        NSRange pos = [uri rangeOfString:@"?"];
        if (pos.location == NSNotFound)
            return nil;
        
        return [NSDictionary httpParametersWithFormEncodedData:[uri substringFromIndex:pos.location + 1]];
    }
    else
    {
        return nil;
    }
}

+ (NSDictionary *)httpParametersWithFormEncodedData:(NSString *)formData
{
    NSArray *params = [formData componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (NSString * param in params) {
        NSArray *pv = [param componentsSeparatedByString:@"="];
        NSString *v = @"";
        if ([pv count] == 2)
            v = [[pv objectAtIndex:1] decodeURIComponent];
        [result setObject:v forKey:[pv objectAtIndex:0]];
    }
    
    return result;
}

- (void)writeToStore:(NSString *)storeKey
{
    @autoreleasepool {
#ifdef FILE_STORAGE_DIRECTORY
        [NSMutableDictionary ensureStorePath:FILE_STORAGE_DIRECTORY];
#endif
        NSString *filePath = [[NSMutableDictionary storePath] stringByAppendingPathComponent:storeKey];
        NSMutableDictionary* tmp = [NSMutableDictionary dictionaryWithDictionary:self];
        [tmp writeToFile:filePath atomically:YES];
    }
}
@end
