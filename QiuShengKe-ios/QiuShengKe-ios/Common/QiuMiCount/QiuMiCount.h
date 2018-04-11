//
//  QiuMiCount.h
//  Qiumi
//
//  Created by xieweijie on 15/5/12.
//  Copyright (c) 2015年 51viper.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QiuMiCount : NSObject
+ (QiuMiCount*)instance;
- (void)countPage:(NSString*)pageName;
@end
