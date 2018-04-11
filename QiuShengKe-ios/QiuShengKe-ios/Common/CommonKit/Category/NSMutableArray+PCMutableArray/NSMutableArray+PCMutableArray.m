//
//  NSMutableArray+PCMutableArray.m
//  PCGroupMagazine4iOS
//
//  Created by pc on 12-8-15.
//  Copyright (c) 2012年 PCGroup. All rights reserved.
//

#import "NSMutableArray+PCMutableArray.h"

@implementation NSMutableArray (PCMutableArray)
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

- (id)initWithStore:(NSString *)storeKey
{
#ifdef FILE_STORAGE_DIRECTORY
        [NSMutableArray ensureStorePath:FILE_STORAGE_DIRECTORY];
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
#ifdef FILE_STORAGE_DIRECTORY
        [NSMutableArray ensureStorePath:FILE_STORAGE_DIRECTORY];
#endif
    NSString *filePath = [storePath__ stringByAppendingPathComponent:storeKey];
    [self writeToFile:filePath atomically:YES];
}
@end
