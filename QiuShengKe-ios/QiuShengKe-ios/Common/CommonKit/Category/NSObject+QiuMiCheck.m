//
//  NSObject+QiuMiCheck.m
//  Qiumi
//
//  Created by Viper on 16/8/7.
//  Copyright © 2016年 51viper.com. All rights reserved.
//

#import "NSObject+QiuMiCheck.h"

@implementation NSObject (QiuMiCheck)
- (NSObject*)cobjectAtIndex:(NSInteger)index{
    if ([self isKindOfClass:[NSArray class]]) {
        if (([(NSArray*)self count] > index) && ([(NSArray*)self objectAtIndex:index]) && (index >= 0)) {
            return [(NSArray*)self objectAtIndex:index];
        }
        else{
            return nil;
        }
    }
    else{
        return nil;
    }
}

- (NSObject*)cobjectForKey:(NSString*)key{
    if ([self isKindOfClass:[NSDictionary class]]) {
        if ([(NSDictionary*)self objectForKey:key]) {
            return [(NSDictionary*)self objectForKey:key];
        }
        else{
            return nil;
        }
    }
    else{
        return nil;
    }
}

- (NSNumber*)ccount{
    if ([self isKindOfClass:[NSArray class]]) {
        if ([(NSArray*)self count] > 0) {
            return [NSNumber numberWithInteger:[(NSArray*)self count]];
        }
        else{
            return nil;
        }
    }
    else{
        return nil;
    }
}

- (NSNumber*)ccountZero{
    if ([self isKindOfClass:[NSArray class]]) {
        if ([(NSArray*)self count] == 0) {
            return [NSNumber numberWithInteger:[(NSArray*)self count]];
        }
        else{
            return nil;
        }
    }
    else{
        return nil;
    }
}
@end
