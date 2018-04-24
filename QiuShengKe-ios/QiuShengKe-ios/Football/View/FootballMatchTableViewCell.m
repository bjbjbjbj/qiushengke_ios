//
//  FootballMatchTableViewCell.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/10.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "FootballMatchTableViewCell.h"

@implementation FootballMatchTableViewCell

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
    if([dic objectForKey:@"oumiddle2"] && ![[dic objectForKey:@"oumiddle2"] isKindOfClass:[NSNull class]]){
        [_ou setText:[NSString stringWithFormat:@"欧:%@ %@ %@",[dic stringForKey:@"ouup2" withDefault:@"-"],[dic stringForKey:@"oumiddle2" withDefault:@"-"],[dic stringForKey:@"oudown2" withDefault:@"-"]]];
    }
    else{
        [_ou setText:@"欧:- - -"];
    }
    [_league setText:[dic stringForKey:@"league" withDefault:@"-"]];
    
    if([dic integerForKey:@"status"] > 0 || [dic integerForKey:@"status"] == -1){
        [_hscore setText:[dic stringForKey:@"hscore" withDefault:@"-"]];
        [_ascore setText:[dic stringForKey:@"ascore" withDefault:@"-"]];
        [_hhscore setText:[dic stringForKey:@"hscorehalf" withDefault:@"-"]];
        [_ahscore setText:[dic stringForKey:@"ascorehalf" withDefault:@"-"]];
        
        [_hyellow setText:[dic stringForKey:@"h_yellow" withDefault:@"-"]];
        [_ayellow setText:[dic stringForKey:@"a_yellow" withDefault:@"-"]];
        [_hred setText:[dic stringForKey:@"h_red" withDefault:@"-"]];
        [_ared setText:[dic stringForKey:@"a_red" withDefault:@"-"]];
        
        if([dic integerForKey:@"status"] <= 0)
            [_time setText:[FootballMatchTableViewCell getStatusText:[dic integerForKey:@"status"]]];
        else{
            [_time setText:[dic stringForKey:@"current_time" withDefault:@"-"]];
        }
        [_time setTextColor:COLOR(203, 86, 70, 1)];
    }
    else{
        [_hscore setText:@"-"];
        [_ascore setText:@"-"];
        [_hhscore setText:@"-"];
        [_ahscore setText:@"-"];
        [_hyellow setHidden:YES];
        [_ayellow setHidden:YES];
        [_hred setHidden:YES];
        [_ared setHidden:YES];
        [_time setText:[NSDate stringWithFormat:@"HH:mm" withTime:[[dic objectForKey:@"time"] longLongValue]]];
        [_time setTextColor:QIUMI_COLOR_G1];
    }
    
    if ([dic integerForKey:@"pc_live"] > 0) {
        [_liveBtn setHidden:NO];
        if ([dic integerForKey:@"afterInReview"] == 0) {
            [_liveBtn setHidden:YES];
        }
    }
    else{
        [_liveBtn setHidden:YES];
    }
}

+ (NSString *)getStatusText:(NSInteger)status{
    //0未开始,1上半场,2中场休息,3下半场,-1已结束,-14推迟,-11待定,-10一支球队退赛
    switch (status) {
            case 0:
            return @"未开始";
            case 1:
            return @"上半场";
            case 2:
            return @"中场休息";
            case 3:
            return @"下半场";
            case -1:
            return @"已结束";
            case -14:
            return @"推迟";
            case -11:
            return @"待定";
            case -10:
            return @"退赛";
            case -99:
            return @"异常";
    }
    return @"";
}
@end

