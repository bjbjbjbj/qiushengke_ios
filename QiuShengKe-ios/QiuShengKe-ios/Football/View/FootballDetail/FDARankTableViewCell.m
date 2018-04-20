//
//  FDARankTableViewCell.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/12.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "FDARankTableViewCell.h"

@implementation FDARankTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
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

- (void)loadData:(NSDictionary *)dic withTeam:(NSString *)team{
    [_team setText:team];
    if (nil == dic) {
        [_rank setText:@"-"];
        [_result setText:[NSString stringWithFormat:@"%@/%@/%@",@"-",@"-",@"-"]];
        [_goal setText:[NSString stringWithFormat:@"%@/%@",@"-",@"-"]];
        [_count setText:@"-"];
        [_diff setText:@"-"];
        [_score setText:@"-"];
        return;
    }
    [_rank setText:[dic stringForKey:@"rank" withDefault:@"-"]];
    [_result setText:[NSString stringWithFormat:@"%@/%@/%@",[dic stringForKey:@"win" withDefault:@"-"],[dic stringForKey:@"draw" withDefault:@"-"],[dic stringForKey:@"lose" withDefault:@"-"]]];
    [_goal setText:[NSString stringWithFormat:@"%@/%@",[dic stringForKey:@"goal" withDefault:@"-"],[dic stringForKey:@"fumble" withDefault:@"-"]]];
    [_count setText:[dic stringForKey:@"count" withDefault:@"-"]];
    [_diff setText:[NSString stringWithFormat:@"%d",[dic integerForKey:@"goal"] - [dic integerForKey:@"fumble"]]];
    [_score setText:[dic stringForKey:@"score"]];
}
@end

