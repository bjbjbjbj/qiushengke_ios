//
//  QSKCommon.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/10.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "QSKCommon.h"

@implementation QSKCommon
+ (NSDictionary *)getMatchOdds:(float)handicap type:(NSInteger)type sport:(NSInteger)sport{
    return nil;
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
@end

