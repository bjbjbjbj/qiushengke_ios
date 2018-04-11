//
//  QiuMiCount.m
//  Qiumi
//
//  Created by xieweijie on 15/5/12.
//  Copyright (c) 2015年 51viper.com. All rights reserved.
//

#import "QiuMiCount.h"
@interface QiuMiCount()
@property(nonatomic, strong)NSString* lastPage;
@end
@implementation QiuMiCount
+ (QiuMiCount*)instance
{
    static QiuMiCount* _current;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _current = [[QiuMiCount alloc] init];
    });
    return _current;
}

- (void)countPage:(NSString *)pageName
{
    if (pageName == nil || [pageName length] == 0) {
        NSLog(@"页面路径传参不能为空");
        return;
    }
    
    if([pageName isEqualToString:_lastPage])
    {
        NSLog(@"页面路径统计相同，不做处理");
        return;
    }
    
    if (_lastPage && [_lastPage length] > 0) {
        [MobClick endLogPageView:_lastPage];
    }
    
    self.lastPage = pageName;
    [MobClick beginLogPageView:pageName];
}
@end
