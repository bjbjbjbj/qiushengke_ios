//
//  QiuMiCommonRequst.h
//  Qiumi
//
//  Created by xieweijie on 15/6/10.
//  Copyright (c) 2015年 51viper.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
typedef void(^QiuMiCommonRequstSuccessBlock)(AFHTTPRequestOperation *operation,NSDictionary* dic, BOOL isFirstPage);
typedef void(^QiuMiCommonRequstFailBlock)(AFHTTPRequestOperation *operation);

@interface QiuMiCommonRequest : NSObject
{
    NSInteger _pageNo;
    NSInteger _pageSize;
    NSInteger _totalNo;//应该要被删的，球迷会粉丝接口有问题
    BOOL _hasNext;
    BOOL _isLoading;
}
@property(nonatomic, strong)NSArray* staticParams;
@property(nonatomic, strong)NSString* url;
@property(nonatomic, copy)QiuMiCommonRequstSuccessBlock successBlock;
@property(nonatomic, copy)QiuMiCommonRequstFailBlock failBlock;

- (BOOL)loading;

- (id)initWithUrl:(NSString*)url;
- (id)initWithUrl:(NSString*)url withStaticParam:(NSArray*)staticParams;
- (void)loadData:(NSDictionary*)params withCurrentUser:(BOOL)isCurrentUser withIsReload:(BOOL)isReload withSuccess:(QiuMiCommonRequstSuccessBlock)successBlock withFail:(QiuMiCommonRequstFailBlock)failBlock;
//是否最后一页
- (BOOL)isLastPage;
@end
