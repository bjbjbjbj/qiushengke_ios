//
//  QiuMiHttpClient.m
//  Qiumi
//
//  Created by xieweijie on 15/4/13.
//  Copyright (c) 2015年 51viper.com. All rights reserved.
//

#import "QiuMiHttpClient.h"
@interface QiuMiHttpClient()
@property(nonatomic, strong)AFHTTPRequestOperationManager* manger;
@end
@implementation QiuMiHttpClient
+ (QiuMiHttpClient*)instance
{
    static QiuMiHttpClient* _current;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _current = [[QiuMiHttpClient alloc] init];
        _current.manger = [AFHTTPRequestOperationManager manager];
    });
    return _current;
}

- (void)GET:(NSString *)URLString
 parameters:(id)parameters
cachePolicy:(QiuMiHttpClientCachePolicy)cachePolicy
    success:(void (^)(AFHTTPRequestOperation *, id))success
    failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    [self GET:URLString parameters:parameters cachePolicy:cachePolicy prompt:nil success:success failure:failure];
}

- (void)GET:(NSString *)URLString
 parameters:(id)parameters
cachePolicy:(QiuMiHttpClientCachePolicy)cachePolicy
     prompt:(NSString *)prompt
    success:(void (^)(AFHTTPRequestOperation *, id))success
    failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    if (nil == prompt || 0 == prompt.length) {
        prompt = @"操作成功";
    }
    
    if (0 == [[parameters allKeys] count]) {
        parameters = nil;
    }
    NSMutableURLRequest *request = [self.manger.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:URLString relativeToURL:self.manger.baseURL] absoluteString] parameters:parameters error:nil];
    
    //先加缓存
    [request setCachePolicy:NSURLRequestReturnCacheDataDontLoad];
    NSCachedURLResponse* cache = [[NSURLCache sharedURLCache]cachedResponseForRequest:request];
    id respon = [self.manger.responseSerializer responseObjectForResponse:cache.response data:cache.data error:nil];
    
    [self.manger.requestSerializer setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    //请求超时
    self.manger.requestSerializer.timeoutInterval = 30;
    switch (cachePolicy) {
        case QiuMiHttpClientCachePolicyNoCache:
            [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
            break;
        case QiuMiHttpClientCachePolicyHttpFirst:
            break;
        case QiuMiHttpClientCachePolicyCacheFirst:
        {
            //先加缓存
            [request setCachePolicy:NSURLRequestReturnCacheDataDontLoad];
            AFHTTPRequestOperation *operation = [self.manger HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if ([[operation response] statusCode] == 200) {
                    success(operation, responseObject);
                }
                else
                {
                    NSString *domain = @"com.QiuMi.ErrorDomain";
                    NSString *desc = NSLocalizedString(@"api 404 or not statuscode == 0", @"");
                    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
                    NSError *error = [NSError errorWithDomain:domain code:-101 userInfo:userInfo];
                    failure(operation, error);
                    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
                }} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
            [self.manger.operationQueue addOperation:operation];
        }
            break;
        case QiuMiHttpClientCachePolicyHttpCache:
        default:
        {
            if (respon) {
                success(nil, respon);
            }
        }
            break;
    }
    
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
    //lastMotify
    NSMutableDictionary* last = [[NSMutableDictionary alloc]initWithStore:QIUMI_LASTMOTIFY];
    NSString* lastMotify = [last objectForKey:request.URL.absoluteString];
    if (last
        && lastMotify
        && [lastMotify length] > 0
        && respon != nil) {
        NSMutableDictionary* header = [[NSMutableDictionary alloc]initWithDictionary:request.allHTTPHeaderFields];
        [header setObject:lastMotify forKey:@"If-Modified-Since"];
        [header setObject:lastMotify forKey:@"Last-Modified"];
        [request setAllHTTPHeaderFields:header];
    }
    
//    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:@"liaogou168.com"]];
//    NSHTTPCookie *cookie;
//    for (cookie in cookies) {
//        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
//    }
//
//    cookie = [[NSHTTPCookie alloc]init];
//    NSMutableDictionary *fromappDict = [NSMutableDictionary dictionary];
//    [fromappDict setObject:@"fromapp" forKey:NSHTTPCookieName];
//    [fromappDict setObject:@"ios" forKey:NSHTTPCookieValue];
//    // kDomain是公司app网址
//    [fromappDict setObject:@"http://dev.shop.liaogou168.com" forKey:NSHTTPCookieDomain];
//    [fromappDict setObject:@"http://dev.shop.liaogou168.com" forKey:NSHTTPCookieOriginURL];
//    [fromappDict setObject:@"/" forKey:NSHTTPCookiePath];
//    [fromappDict setObject:@"0" forKey:NSHTTPCookieVersion];
//    
//    // 将可变字典转化为cookie
//    cookie = [NSHTTPCookie cookieWithProperties:fromappDict];
//    
//    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    
    
    AFHTTPRequestOperation *operation = [self.manger HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[operation response] statusCode] == 200) {
            if (0 == [responseObject integerForKey:@"code"]) {
                //lastmotify
                NSDictionary *headers = [operation.response allHeaderFields];
                NSString *lastModified = [headers objectForKey:@"Last-Modified"];
                if (lastModified && [lastModified length] > 0) {
                    NSMutableDictionary* data = [[NSMutableDictionary alloc]initWithStore:QIUMI_LASTMOTIFY];
                    [data setObject:lastModified forKey:[operation.response.URL absoluteString]];
                    [data writeToStore:QIUMI_LASTMOTIFY];
                }
                if ([responseObject objectForKey:@"exp"]) {
                    [QiuMiCommonPromptView showText:prompt withSecText:nil withDic:[responseObject objectForKey:@"exp"] withPrompt:QiuMiCommonPromptSuccess];
                }
            }
            success(operation, responseObject);
        }
        else
        {
            NSString *domain = @"com.QiuMi.ErrorDomain";
            NSString *desc = NSLocalizedString(@"api 404 or not statuscode == 0", @"");
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
            NSError *error = [NSError errorWithDomain:domain code:-101 userInfo:userInfo];
            if (failure) {
                failure(operation, error);
            }
        }} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (nil != operation && nil != operation.response && [operation.response statusCode] == 304 && respon) {
                success(operation, respon);
            }
            else
            {
//#warning 如果failure为空会出现问题
                //这种情况会导致动画停在原处
                if (failure) {
                     failure(operation, error);
                }
            }
        }];
    
    operation.securityPolicy.allowInvalidCertificates = YES;
    
    [self.manger.operationQueue addOperation:operation];
}

- (void)GET:(NSString *)URLString
cachePolicy:(QiuMiHttpClientCachePolicy)cachePolicy
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
{
    [self GET:URLString parameters:nil cachePolicy:cachePolicy success:success failure:nil];
}

- (void)POST:(NSString *)URLString parameters:(id)parameters prompt:(NSString *)prompt success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    if (nil == prompt || 0 == prompt.length) {
        prompt = @"操作成功";
    }
    
    AFHTTPRequestOperationManager *operation = [AFHTTPRequestOperationManager manager];
    operation.securityPolicy.allowInvalidCertificates = YES;
    [operation POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[operation response] statusCode] == 200) {
            success(operation, responseObject);
        }
        else
        {
            NSString *domain = @"com.QiuMi.ErrorDomain";
            NSString *desc = NSLocalizedString(@"api 404 or not statuscode == 0", @"");
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
            NSError *error = [NSError errorWithDomain:domain code:-101 userInfo:userInfo];
            failure(operation, error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}

- (void)POST:(NSString *)URLString withShowPromptText:(NSString *)text withPromptSecText:(NSString *)secText parameters:(id)parameters prompt:(NSString *)prompt success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    if (nil == prompt || 0 == prompt.length) {
        prompt = @"操作成功";
    }
    [QiuMiCommonPromptView showText:text?:@"请稍后..." withSecText:secText withDic:nil withPrompt:QiuMiCommonPromptDefualt];
    AFHTTPRequestOperationManager *operation = [AFHTTPRequestOperationManager manager];
    operation.securityPolicy.allowInvalidCertificates = YES;
    [operation POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[operation response] statusCode] == 200) {
            if ([responseObject objectForKey:@"exp"]) {
                [QiuMiCommonPromptView hideWithText:prompt withSecText:nil withDic:[responseObject objectForKey:@"exp"] withType:QiuMiCommonPromptSuccess];
            }else{
                if ([responseObject integerForKey:@"code"] == 0) {
                    [QiuMiCommonPromptView hideWithText:prompt withSecText:nil withType:QiuMiCommonPromptSuccess];
                }else{
                    [QiuMiCommonPromptView hideWithText:@"请求失败" withSecText:[responseObject objectForKey:@"message"] withType:QiuMiCommonPromptFail];
                }
            }
            success(operation, responseObject);
        }
        else
        {
            [QiuMiCommonPromptView hideWithText:QIUMI_NETWORK_FAIL withSecText:nil withType:QiuMiCommonPromptFail];
            NSString *domain = @"com.QiuMi.ErrorDomain";
            NSString *desc = NSLocalizedString(@"api 404 or not statuscode == 0", @"");
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
            NSError *error = [NSError errorWithDomain:domain code:-101 userInfo:userInfo];
            failure(operation, error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [QiuMiCommonPromptView hideWithText:QIUMI_NO_NETWORK withSecText:@"请检查网络" withType:QiuMiCommonPromptNetFail];
        failure(operation,error);
    }];
}

- (void)POST:(NSString *)URLString noTipsWithparameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    AFHTTPRequestOperationManager *operation = [AFHTTPRequestOperationManager manager];
    operation.securityPolicy.allowInvalidCertificates = YES;
    [operation POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[operation response] statusCode] == 200) {
            success(operation, responseObject);
        }
        else
        {
            NSString *domain = @"com.QiuMi.ErrorDomain";
            NSString *desc = NSLocalizedString(@"api 404 or not statuscode == 0", @"");
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
            NSError *error = [NSError errorWithDomain:domain code:-101 userInfo:userInfo];
            failure(operation, error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}

- (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    [self POST:URLString parameters:parameters prompt:nil success:success failure:failure];
}

- (void)cleanCache:(NSString *)url
{
    NSMutableURLRequest *request = [self.manger.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:url relativeToURL:self.manger.baseURL] absoluteString] parameters:nil error:nil];
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
}

- (void)oGET:(NSString *)URLString parameters:(id)parameters cachePolicy:(QiuMiHttpClientCachePolicy)cachePolicy success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    NSMutableURLRequest *request = [self.manger.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:URLString relativeToURL:self.manger.baseURL] absoluteString] parameters:parameters error:nil];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    AFHTTPRequestOperation *operation = [self.manger HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[operation response] statusCode] == 200) {
            success(operation, responseObject);
        }
        else
        {
            NSString *domain = @"com.QiuMi.ErrorDomain";
            NSString *desc = NSLocalizedString(@"api 404 or not statuscode == 0", @"");
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
            NSError *error = [NSError errorWithDomain:domain code:-101 userInfo:userInfo];
            if (failure) {
                failure(operation, error);
            }
        }} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failure) {
                failure(operation, error);
            }
        }];
    
    operation.securityPolicy.allowInvalidCertificates = YES;
    
    [self.manger.operationQueue addOperation:operation];
}
@end
