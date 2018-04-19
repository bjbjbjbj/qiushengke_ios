//
//  BasketballMatchTableViewCell.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/18.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "BasketballMatchTableViewCell.h"

@implementation BasketballMatchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSInteger)heightOfCell{
    return 95;
}

- (void)loadData:(NSDictionary *)dic{
    [_hostName setText:[dic objectForKey:@"hname"]];
    [_awayName setText:[dic objectForKey:@"aname"]];
    [_hicon qiumi_setImageWithURLString:[dic stringForKey:@"hicon"] withHoldPlace:QIUMI_DEFAULT_IMAGE];
    [_aicon qiumi_setImageWithURLString:[dic stringForKey:@"aicon"] withHoldPlace:QIUMI_DEFAULT_IMAGE];
    
    if([dic objectForKey:@"asiamiddle2"] && ![[dic objectForKey:@"asiamiddle2"] isKindOfClass:[NSNull class]]){
        NSString* mid  = [QSKCommon oddString:[[dic valueForKey:@"asiamiddle2"] floatValue]];
        if([[dic valueForKey:@"asiamiddle2"] floatValue] == 0){
            mid = @"0";
        }
        [_asia setText:[NSString stringWithFormat:@"亚:%@ %@ %@",[dic stringForKey:@"asiaup2" withDefault:@"-"],mid,[dic stringForKey:@"asiadown2" withDefault:@"-"]]];
    }
    else{
        [_asia setText:@"亚:- - -"];
    }
    if([dic objectForKey:@"goalmiddle2"] && ![[dic objectForKey:@"goalmiddle2"] isKindOfClass:[NSNull class]]){
        NSString* mid  = [QSKCommon oddString:[[dic valueForKey:@"goalmiddle2"] floatValue]];
        [_goal setText:[NSString stringWithFormat:@"大:%@ %@ %@",[dic stringForKey:@"goalup2" withDefault:@"-"],mid,[dic stringForKey:@"goaldown2" withDefault:@"-"]]];
    }
    else{
        [_goal setText:@"大:- - -"];
    }
    if([dic objectForKey:@"ouup2"] && ![[dic objectForKey:@"ouup2"] isKindOfClass:[NSNull class]]){
        [_ou setText:[NSString stringWithFormat:@"欧:%@ %@",[dic stringForKey:@"ouup2" withDefault:@"-"],[dic stringForKey:@"oudown2" withDefault:@"-"]]];
    }
    else{
        [_ou setText:@"欧:- -"];
    }
    [_league setText:[dic stringForKey:@"league" withDefault:@"-"]];
    [[_livingBtn superview] setHidden:YES];
    if([dic integerForKey:@"status"] > 0 || [dic integerForKey:@"status"] == -1){
        [_hscore setText:[dic stringForKey:@"hscore" withDefault:@"-"]];
        [_ascore setText:[dic stringForKey:@"ascore" withDefault:@"-"]];
        [_hscore1 setText:[dic stringForKey:@"hscore_1st" withDefault:@"-"]];
        [_ascore1 setText:[dic stringForKey:@"ascore_1st" withDefault:@"-"]];
        [_hscore2 setText:[dic stringForKey:@"hscore_2nd" withDefault:@"-"]];
        [_ascore2 setText:[dic stringForKey:@"ascore_2nd" withDefault:@"-"]];
        [_hscore3 setText:[dic stringForKey:@"hscore_3rd" withDefault:@"-"]];
        [_ascore3 setText:[dic stringForKey:@"ascore_3rd" withDefault:@"-"]];
        [_hscore4 setText:[dic stringForKey:@"hscore_4th" withDefault:@"-"]];
        [_ascore4 setText:[dic stringForKey:@"ascore_4th" withDefault:@"-"]];
        
        if([dic existForKey:@"h_ot"]||[dic existForKey:@"a_ot"]){
            [_hscoreOT setHidden:NO];
            [_ascoreOT setHidden:NO];
            NSInteger total = 0;
            for (NSNumber* tmp in [dic objectForKey:@"h_ot"]) {
                total += [tmp integerValue];
            }
            [_hscoreOT setText:[NSString stringWithFormat:@"%d",total]];
            total = 0;
            for (NSNumber* tmp in [dic objectForKey:@"a_ot"]) {
                total += [tmp integerValue];
            }
            [_ascoreOT setText:[NSString stringWithFormat:@"%d",total]];
        }
        else{
            [_hscoreOT setHidden:YES];
            [_ascoreOT setHidden:YES];
        }
        
        [_time setText:[BasketballMatchTableViewCell getStatusText:[dic integerForKey:@"status"] system:[dic integerForKey:@"system"]]];
        [_time setTextColor:COLOR(203, 86, 70, 1)];
        [[[_hscore superview] superview] setHidden:NO];
        if ([dic integerForKey:@"status"] > 0 && [dic integerForKey:@"pc_live"] > 0) {
            [[_livingBtn superview] setHidden:NO];
        }
    }
    else{
        [[[_hscore superview] superview] setHidden:YES];
        [_time setText:[NSDate stringWithFormat:@"HH:mm" withTime:[[dic objectForKey:@"time"] longLongValue]]];
        [_time setTextColor:QIUMI_COLOR_G1];
    }
    
    if ([dic integerForKey:@"status"] == 0 && [dic integerForKey:@"pc_live"] > 0) {
        [_liveBtn setHidden:NO];
    }
    else{
        [_liveBtn setHidden:YES];
    }
}

+ (NSString *)getStatusText:(NSInteger)status system:(NSInteger)system{
    switch (status) {
        case 0:
            return @"未开始";
        case 1:
            return system == 1 ? @"上半场" : @"第一节";
        case 2:
            return @"第二节";
        case 3:
            return system == 1 ? @"下半场" : @"第三节";
        case 4:
            return @"第四节";
        case 5:
            return @"加时1";
        case 6:
            return @"加时2";
        case 7:
            return @"加时3";
        case 50:
            return @"中场休息";
        case -1:
            return @"已结束";
        case -5:
            return @"推迟";
        case -2:
            return @"待定";
        case -12:
            return @"腰斩";
        case -10:
            return @"退赛";
        case -99:
            return @"异常";
    }
    return @"异常";
}
@end
