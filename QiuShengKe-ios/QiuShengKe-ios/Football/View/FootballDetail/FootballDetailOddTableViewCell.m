//
//  FootballDetailOddTableViewCell.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/12.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "FootballDetailOddTableViewCell.h"

@implementation FootballDetailOddTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSInteger)heightOfCell{
    return 46;
}

+ (NSInteger)heightOfCell2{
    return 60;
}

- (void)loadDataTitle:(NSInteger)type{
    switch (type) {
        case 0:
            [_up1 setText:@"主队"];
            [_down1 setText:@"客队"];
            [_middle1 setText:@"让球"];
            break;
        case 1:
            [_up1 setText:@"主胜"];
            [_down1 setText:@"客胜"];
            [_middle1 setText:@"平局"];
            break;
        case 2:
            [_up1 setText:@"大球"];
            [_down1 setText:@"小球"];
            [_middle1 setText:@"盘口"];
            break;
        default:
            break;
    }
}

- (void)loadData:(NSDictionary *)dic{
    [_comName setText:[dic stringForKey:@"name" withDefault:@"-"]];
    [_up1 setText:[dic stringForKey:@"up1" withDefault:@"-"]];
    [_middle1 setText:[dic stringForKey:@"middle1" withDefault:@"-"]];
    [_down1 setText:[dic stringForKey:@"down1" withDefault:@"-"]];
    if (![[dic stringForKey:@"up2" withDefault:@"-"] isEqualToString:@"-"]) {
        if ([dic floatForKey:@"up2"] > [dic floatForKey:@"up1"]) {
            [_up2 setTextColor:COLOR(188, 28, 37, 1)];
        }
        else if ([dic floatForKey:@"up2"] < [dic floatForKey:@"up1"]) {
            [_up2 setTextColor:QIUMI_COLOR_C1];
        }
        else{
            [_up2 setTextColor:QIUMI_COLOR_G1];
        }
    }
    if (![[dic stringForKey:@"middle2" withDefault:@"-"] isEqualToString:@"-"]) {
        if ([dic floatForKey:@"middle2"] > [dic floatForKey:@"middle1"]) {
            [_middle2 setTextColor:COLOR(188, 28, 37, 1)];
        }
        else if ([dic floatForKey:@"middle2"] < [dic floatForKey:@"middle1"]) {
            [_middle2 setTextColor:QIUMI_COLOR_C1];
        }
        else{
            [_middle2 setTextColor:QIUMI_COLOR_G1];
        }
    }
    if (![[dic stringForKey:@"down2" withDefault:@"-"] isEqualToString:@"-"]) {
        if ([dic floatForKey:@"down2"] > [dic floatForKey:@"down1"]) {
            [_down2 setTextColor:COLOR(188, 28, 37, 1)];
        }
        else if ([dic floatForKey:@"down2"] < [dic floatForKey:@"down1"]) {
            [_down2 setTextColor:QIUMI_COLOR_C1];
        }
        else{
            [_down2 setTextColor:QIUMI_COLOR_G1];
        }
    }
    [_up2 setText:[dic stringForKey:@"up2" withDefault:@"-"]];
    [_middle2 setText:[dic stringForKey:@"middle2" withDefault:@"-"]];
    [_down2 setText:[dic stringForKey:@"down2" withDefault:@"-"]];
}

@end
