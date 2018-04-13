//
//  FDAScheduleTableViewCell.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/12.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "FDAScheduleTableViewCell.h"

@implementation FDAScheduleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSInteger)heightOfCell{
    return 40;
}

+ (NSInteger)heightOfTitle{
    return 22;
}

- (void)loadData:(NSDictionary *)dic teamId:(NSInteger)tid{
    NSString* timeStr = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"time"] componentsSeparatedByString:@" "][0]];
    [_time setText:timeStr];
    [_hname setText:[dic objectForKey:@"hname"]];
    [_aname setText:[dic objectForKey:@"aname"]];
    [_sep setText:[dic objectForKey:@"day"]];
    [_league setText:[dic objectForKey:@"league"]];
    if ([dic integerForKey:@"hid"] == tid) {
        [_hname setTextColor:QIUMI_COLOR_C1];
    }
    else{
        [_hname setTextColor:QIUMI_COLOR_G1];
    }
    if ([dic integerForKey:@"aid"] == tid) {
        [_aname setTextColor:QIUMI_COLOR_C1];
    }
    else{
        [_aname setTextColor:QIUMI_COLOR_G1];
    }
}
@end
