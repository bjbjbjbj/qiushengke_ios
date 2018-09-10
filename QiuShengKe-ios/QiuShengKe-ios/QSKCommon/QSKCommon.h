//
//  QSKCommon.h
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/10.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerViewController.h"
@interface QSKCommon : NSObject
+ (QSKCommon*)instance;
+ (NSDictionary*)getMatchOdds:(float)handicap type:(NSInteger)type sport:(NSInteger)sport;
+ (NSString*)paramWithMid:(NSInteger)mid;
+ (NSString*)oddString:(float)handicap;
+ (NSInteger)getMatchAsiaOddResult:(NSInteger)hscore ascore:(NSInteger)ascore handicap:(float)middle isHost:(BOOL)isHomeTeam;
+ (PlayerViewController*)getPlayerControllerWithMid:(NSInteger)mid sport:(NSInteger)sport;
- (NSString*)baseUrl;
- (NSString*)socketUrl;
@end
