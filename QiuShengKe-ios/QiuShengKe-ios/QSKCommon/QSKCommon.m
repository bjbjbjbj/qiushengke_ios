//
//  QSKCommon.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/10.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "QSKCommon.h"

@implementation QSKCommon
+ (QSKCommon*)instance
{
    static QSKCommon* _current;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _current = [[QSKCommon alloc] init];
    });
    return _current;
}

- (NSString *)baseUrl{
    NSDictionary* config = [[NSMutableDictionary alloc] initWithStore:QKS_CONFIG];
    if ([[config objectForKey:@"host"] length] > 0) {
        return [config objectForKey:@"host"];
    }
    return @"http://www.aikq.cc";
}

+ (PlayerViewController*)getPlayerControllerWithMid:(NSInteger)mid sport:(NSInteger)sport{
    PlayerViewController* player = (PlayerViewController*)[QiuMiCommonViewController controllerWithStoryBoardName:@"Football" withControllerName:@"PlayerViewController"];
    [player setMid:mid];
    [player setSport:sport];
    return player;
}

+ (NSDictionary *)getMatchOdds:(float)handicap type:(NSInteger)type sport:(NSInteger)sport{
    return nil;
}

+ (NSString*)paramWithMid:(NSInteger)mid{
    NSString* result = [[NSNumber numberWithInteger:mid] stringValue];
    return [NSString stringWithFormat:@"%@/%@/%@",[result substringWithRange:NSMakeRange(0, 2)],[result substringWithRange:NSMakeRange(2, 2)],result];
}

+ (NSString *)oddString:(float)handicap{
    NSString* prefix = @"";
    if (handicap < 0) {
        prefix = @"-";
    }
    NSInteger tmp = abs(handicap*100);
    NSString* string = @"";
    switch (tmp%100) {
            case 0:
            string = [NSString stringWithFormat:@"%.1f",tmp/100.00];
            break;
            case 25:
            string = [NSString stringWithFormat:@"%@/%@",[NSString stringWithFormat:@"%.0f",(tmp - 25)/100.00],[NSString stringWithFormat:@"%.1f",(tmp + 25)/100.00]];
            break;
            break;
            case 50:
            string = [NSString stringWithFormat:@"%.1f",tmp/100.00];
            break;
            case 75:
            string = [NSString stringWithFormat:@"%@/%@",[NSString stringWithFormat:@"%.1f",(tmp - 25)/100.00],[NSString stringWithFormat:@"%.0f",(tmp + 25)/100.00]];
            break;
        default:
            break;
    }
    return [NSString stringWithFormat:@"%@%@",prefix,string];
}

+ (NSInteger)getMatchAsiaOddResult:(NSInteger)hscore ascore:(NSInteger)ascore handicap:(float)middle isHost:(BOOL)isHomeTeam
{
    NSInteger result = -1;
    NSInteger count = hscore - middle - ascore;
    if (isHomeTeam) {
        if (count < 0) {
            result = 0; //输
        } else if (count == 0) {
            result = 1; //走
        } else {
            result = 3; //赢
        }
    } else {
        if (count < 0) {
            result = 3; //赢
        } else if (count == 0) {
            result = 1; //走
        } else {
            result = 0; //输
        }
    }
    return result;
}

@end

