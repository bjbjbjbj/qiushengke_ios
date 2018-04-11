//
//  NSDictionary+CommonKit.h
//  Qiumi
//
//  Created by xieweijie on 16/8/22.
//  Copyright © 2016年 51viper.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (CommonKit)
- (NSString*)stringForKey:(NSString *)key;
- (NSString*)stringForKey:(NSString *)key withDefault:(NSString*)defaultString;
- (NSInteger)integerForKey:(NSString *)key;
+ (NSDictionary *)httpParametersWithUri:(NSString *)uri;
- (void)writeToStore:(NSString *)stroeKey;
@end
