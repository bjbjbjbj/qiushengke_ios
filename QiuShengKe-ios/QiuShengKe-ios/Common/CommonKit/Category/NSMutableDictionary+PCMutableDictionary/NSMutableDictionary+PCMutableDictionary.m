//
//  NSMutableDictionary+PCMutableDictionary.m
//  PCGroupMagazine4iOS
//
//  Created by pc on 12-8-15.
//  Copyright (c) 2012年 Mao Zhijun. All rights reserved.
//

#import "NSMutableDictionary+PCMutableDictionary.h"

@implementation NSMutableDictionary (PCMutableDictionary)
static NSString *storePath__;
+ (void)ensureStorePath : (NSString *)path
{
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];

        BOOL isDir = NO;
        storePath__ = path;
        if ([fileManager fileExistsAtPath:path isDirectory:&isDir] && isDir) {
            return;
        }
        [fileManager createDirectoryAtPath:storePath__
               withIntermediateDirectories:true
                                attributes:nil
                                     error:nil];
        
    });
    
}

+ (NSString *)storePath
{
    return storePath__;
}

- (id)initWithStore:(NSString *)storeKey
{
#ifdef FILE_STORAGE_DIRECTORY
        [NSMutableDictionary ensureStorePath:FILE_STORAGE_DIRECTORY];
#endif
    NSString *filePath = [storePath__ stringByAppendingPathComponent:storeKey];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        self = [self initWithContentsOfFile:filePath];
    } else {
        self = [self init];
        [self writeToStore:storeKey];
    }
    return self;
}

- (void)writeToStore:(NSString *)storeKey
{
    @autoreleasepool {
#ifdef FILE_STORAGE_DIRECTORY
        [NSMutableDictionary ensureStorePath:FILE_STORAGE_DIRECTORY];
#endif
        NSString *filePath = [storePath__ stringByAppendingPathComponent:storeKey];
        [self writeToFile:filePath atomically:YES];
    }
}
@end
