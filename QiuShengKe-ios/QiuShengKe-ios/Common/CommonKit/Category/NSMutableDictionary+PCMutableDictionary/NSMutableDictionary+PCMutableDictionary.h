//
//  NSMutableDictionary+PCMutableDictionary.h
//  PCGroupMagazine4iOS
//
//  Created by pc on 12-8-15.
//  Copyright (c) 2012年 Mao Zhijun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (PCMutableDictionary)

+ (void)ensureStorePath : (NSString *)path;
- (id)initWithStore:(NSString *)storeKey;
- (void)writeToStore:(NSString *)stroeKey;
+ (NSString*)storePath;
@end
