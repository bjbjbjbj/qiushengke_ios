//
//  NSMutableArray+PCMutableArray.h
//  PCGroupMagazine4iOS
//
//  Created by pc on 12-8-15.
//  Copyright (c) 2012年 PCGroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (PCMutableArray)

+ (void)ensureStorePath : (NSString *)path;
- (id)initWithStore:(NSString *)storeKey;
- (void)writeToStore:(NSString *)stroeKey;

@end
