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
    return 75;
}

- (void)loadData:(NSDictionary *)dic{
    [_hostName setText:[dic objectForKey:@"hname"]];
    [_awayName setText:[dic objectForKey:@"aname"]];

    [_league setText:[[dic stringForKey:@"league_name" withDefault:@""] stringByAppendingString:[NSString stringWithFormat:@" %@",[[dic objectForKey:@"time"] substringWithRange:NSMakeRange(10, 6)]]]];
    
    if ([[dic objectForKey:@"isMatching"] boolValue]) {
        [_live setHidden:NO];
        [_vs setHidden:YES];
    }
    else{
        [_live setHidden:YES];
        [_vs setHidden:NO];
    }
    [_live setHidden:NO];
    [_vs setHidden:YES];
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

