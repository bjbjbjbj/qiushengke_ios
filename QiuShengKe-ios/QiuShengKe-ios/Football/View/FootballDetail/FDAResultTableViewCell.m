//
//  FDAResultTableViewCell.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/13.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "FDAResultTableViewCell.h"

@implementation FDAResultTableViewCell

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

- (void)loadData:(NSDictionary *)dic{
    [_result setText:@"-/-/-"];
    [_winP setText:@"-%"];
    [_big setText:@"-"];
    [_bigP setText:@"-%"];
    [_small setText:@"-"];
    [_smallP setText:@"-%"];
    if (dic == nil) {
        return;
    }
    [_result setText:[NSString stringWithFormat:@"%@/%@/%@",[dic stringForKey:@"asiaWin" withDefault:@"-"],[dic stringForKey:@"asiaDraw" withDefault:@"-"],[dic stringForKey:@"asiaLose" withDefault:@"-"]]];
    [_winP setText:[NSString stringWithFormat:@"%@%%",[dic stringForKey:@"asiaPercent" withDefault:@"-"]]];
    [_big setText:[dic stringForKey:@"goalBig" withDefault:@"-"]];
    [_bigP setText:[[dic stringForKey:@"goalBigPercent" withDefault:@"-"] stringByAppendingString:@"%"]];
    [_small setText:[dic stringForKey:@"goalSmall" withDefault:@"-"]];
    [_smallP setText:[[dic stringForKey:@"goalSmallPercent" withDefault:@"-"] stringByAppendingString:@"%"]];
}
@end
