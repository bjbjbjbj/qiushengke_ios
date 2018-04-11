//
//  QSKCommon.h
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/10.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSKCommon : NSObject
+ (NSDictionary*)getMatchOdds:(float)handicap type:(NSInteger)type sport:(NSInteger)sport;

+ (NSString*)oddString:(float)handicap;
@end
