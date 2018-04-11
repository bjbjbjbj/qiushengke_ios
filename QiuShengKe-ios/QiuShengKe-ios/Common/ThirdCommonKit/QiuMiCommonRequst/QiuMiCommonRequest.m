//
//  QiuMiCommonRequst.m
//  Qiumi
//
//  Created by xieweijie on 15/6/10.
//  Copyright (c) 2015年 51viper.com. All rights reserved.
//

#import "QiuMiCommonRequest.h"
@interface QiuMiCommonRequest()
@property(nonatomic, strong)NSString* timeStamp;
@end

@implementation QiuMiCommonRequest

- (BOOL)loading
{
    return _isLoading;
}

- (id)initWithUrl:(NSString *)url
{
    return [self initWithUrl:url withStaticParam:nil];
}

- (id)initWithUrl:(NSString *)url withStaticParam:(NSArray *)staticParams
{
    self = [super init];
    if (self) {
        self.url = url;
        _pageNo = -1;
        _isLoading = NO;
        _totalNo = 0;
        _hasNext = YES;
        if (nil != staticParams) {
            self.staticParams = staticParams;
        }
    }
    return self;
}

- (void)loadData:(NSDictionary *)params withCurrentUser:(BOOL)isCurrentUser withIsReload:(BOOL)isReload withSuccess:(QiuMiCommonRequstSuccessBlock)successBlock withFail:(QiuMiCommonRequstFailBlock)failBlock
{
    if (_isLoading) {
        return;
    }
    
    if (isReload) {
        _pageNo = -1;
        _pageSize = 0;
        _totalNo = 0;
        _hasNext = YES;
        self.timeStamp = @"";
    }
    
    if (!_hasNext) {
        //没有下一页
        return;
    }
    
    _isLoading = YES;
    
    NSMutableDictionary* dic = params ? [[NSMutableDictionary alloc]initWithDictionary:params] : [[NSMutableDictionary alloc]init];
    
    //分页
    if (_pageNo > -1 && nil == [params objectForKey:@"pageNo"]) {
        [dic setObject:[NSNumber numberWithInteger:_pageNo + 1] forKey:@"pageNo"];
    }
    if (_pageSize > 0 && nil == [params objectForKey:@"pageSize"]) {
        [dic setObject:[NSNumber numberWithInteger:_pageSize] forKey:@"pageSize"];
    }
    if (0 < _timeStamp.length && nil == [params objectForKey:@"timestamp"]) {
        [dic setObject:_timeStamp forKey:@"timestamp"];
    }
    
    //登录信息
    //静态连接不需要再显式传token
    if (isCurrentUser && nil == _staticParams) {
        [dic setObject:[OpenUDID value] forKey:@"udid"];
    }
    
    //请求url
    NSString* url = _url;
    
    //静态参数
    for (int i = 0; i < [_staticParams count]; i++) {
        NSString* key = [_staticParams objectAtIndex:i];
        NSString* value;
        if (nil == [dic objectForKey:key]) {
            value = @"";
        }
        else
        {
            if ([[[dic objectForKey:key] class] isSubclassOfClass:[NSNumber class]]) {
                value = [[dic objectForKey:key] stringValue];
            }
            else
            {
                value = [dic objectForKey:key];
            }
        }
        
        value = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //系统方法没有把英文和"-"编译
        value = [value stringByReplacingOccurrencesOfString:@"-" withString:@"%2D"];
        if (0 == i) {
            url = [NSString stringWithFormat:@"%@/%@", url , value];
        }
        else
        {
            url = [NSString stringWithFormat:@"%@-%@", url , value];
        }
    }
    
    
    __block typeof(self) wself = self;
    
    [[QiuMiHttpClient instance]GET:url parameters:nil == _staticParams ? dic : nil cachePolicy:_pageNo == -1 ? QiuMiHttpClientCachePolicyHttpCache : QiuMiHttpClientCachePolicyHttpFirst success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation) {
            _isLoading = NO;
        }
        
        BOOL isFirstPage = NO;
        if ([responseObject objectForKey:@"code"] && [responseObject integerForKey:@"code"] == 0) {
            if (operation != nil && _pageNo == [responseObject integerForKey:@"pageNo"]) {
                //                return;
            }
            
            if (_pageNo == -1) {
                isFirstPage = YES;
            }
            //有pageSize的时候用pageSize，没有的的时候用默认值20
            //当后台没有pageSize字段用-1
            if ([responseObject objectForKey:@"pageSize"]) {
                if ([responseObject integerForKey:@"pageSize"]) {
                    _pageSize = [responseObject integerForKey:@"pageSize"];
                }else{
                    _pageSize = 20;
                }
            }
            else{
                _pageSize = -1;
            }
            
            
            _totalNo = [responseObject integerForKey:@"totalNo"] - 1;
            _pageNo = [responseObject integerForKey:@"pageNo"];
            _hasNext = [wself judgmentNext:[responseObject objectForKey:@"data"]];
            
            if ( [responseObject integerForKey:@"pageNo"] == 0) {
                isFirstPage = YES;
            }
            
            if (isFirstPage && nil != [responseObject objectForKey:@"timestamp"]) {
                wself.timeStamp = [[responseObject objectForKey:@"timestamp"] stringValue];
            }
        }
        if (successBlock) {
            successBlock(operation, responseObject, isFirstPage);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _isLoading = NO;
        
        //网络环境好差（公司)
        if (-1009 == [operation.error code] ||
            -1001 == [operation.error code] ||
            -1004 == [operation.error code]) {
            [QiuMiPromptView showText:QIUMI_NO_NETWORK_TIP_TEXT];
        }
        else{
            [QiuMiPromptView showText:QIUMI_NETWORK_TIP_TEXT];
        }
        
        if (failBlock) {
            failBlock(operation);
        }
    }];
}

- (BOOL)isLastPage
{
    return !_hasNext;
}

- (BOOL)judgmentNext:(id)data
{
    if ([data isKindOfClass:[NSArray class]]) {
        if (_pageNo == -1) {
            return NO;
        }
        if (_totalNo > 0) {
            return _totalNo > _pageNo;
        }
        else{
            return [data count] > 0;
        }
    }
    else
    {
#warning 最终要返NO
        NSLog(@"respone data is not array, please create a sub class of QiuMiCommonRequest");
        //需要特殊处理的东东，如果是粉丝，首页自己要特殊搞个子类重载这个方法
        return YES;
    }
}
@end
