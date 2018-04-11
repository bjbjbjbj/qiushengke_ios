//
//  QiuMiButton.m
//  Qiumi
//
//  Created by xieweijie on 16/3/28.
//  Copyright © 2016年 51viper.com. All rights reserved.
//

#import "QiuMiButton.h"

@implementation QiuMiButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
    [super awakeFromNib];
    if (nil != _qiumiColor) {
        if ([@"g1" isEqualToString:_qiumiColor]) {
            [self setTitleColor:QIUMI_COLOR_G1 forState:UIControlStateNormal];
        }
        else if ([@"g2" isEqualToString:_qiumiColor]) {
            [self setTitleColor:QIUMI_COLOR_G2 forState:UIControlStateNormal];
        }
        else if ([@"g4" isEqualToString:_qiumiColor]) {
            [self setTitleColor:QIUMI_COLOR_G4 forState:UIControlStateNormal];
        }
        else if ([@"g5" isEqualToString:_qiumiColor]) {
            [self setTitleColor:QIUMI_COLOR_G5 forState:UIControlStateNormal];
        }
        else if ([@"g7" isEqualToString:_qiumiColor]) {
            [self setTitleColor:QIUMI_COLOR_G7 forState:UIControlStateNormal];
        }
        else if ([@"g6" isEqualToString:_qiumiColor]) {
            [self setTitleColor:QIUMI_COLOR_G6 forState:UIControlStateNormal];
        }
        else if ([@"c1" isEqualToString:_qiumiColor]) {
            [self setTitleColor:QIUMI_COLOR_C1 forState:UIControlStateNormal];
        }
        else if ([@"c1d" isEqualToString:_qiumiColor]) {
            [self setTitleColor:QIUMI_COLOR_C1_D forState:UIControlStateNormal];
        }
        else if ([@"c2" isEqualToString:_qiumiColor]) {
            [self setTitleColor:QIUMI_COLOR_C2 forState:UIControlStateNormal];
        }
        else if ([@"d1" isEqualToString:_qiumiColor]) {
            [self setTitleColor:QIUMI_COLOR_D1 forState:UIControlStateNormal];
        }
        else if ([@"c3" isEqualToString:_qiumiColor]) {
            [self setTitleColor:QIUMI_COLOR_C3 forState:UIControlStateNormal];
        }
        else if ([@"c4" isEqualToString:_qiumiColor]) {
            [self setTitleColor:QIUMI_COLOR_C4 forState:UIControlStateNormal];
        }
        else
        {
            NSLog(@"not found color");
        }
    }
    
    if (nil != _qiumiBGColor) {
        if ([@"g1" isEqualToString:_qiumiBGColor]) {
            [self setBackgroundColor:QIUMI_COLOR_G1];
        }
        else if ([@"g2" isEqualToString:_qiumiBGColor]) {
            [self setBackgroundColor:QIUMI_COLOR_G2];
        }
        else if ([@"g4" isEqualToString:_qiumiBGColor]) {
            [self setBackgroundColor:QIUMI_COLOR_G4];
        }
        else if ([@"g5" isEqualToString:_qiumiBGColor]) {
            [self setBackgroundColor:QIUMI_COLOR_G5];
        }
        else if ([@"g7" isEqualToString:_qiumiBGColor]) {
            [self setBackgroundColor:QIUMI_COLOR_G7];
        }
        else if ([@"g6" isEqualToString:_qiumiBGColor]) {
            [self setBackgroundColor:QIUMI_COLOR_G6];
        }
        else if ([@"c1" isEqualToString:_qiumiBGColor]) {
            [self setBackgroundColor:QIUMI_COLOR_C1];
        }
        else if ([@"c1d" isEqualToString:_qiumiBGColor]) {
            [self setBackgroundColor:QIUMI_COLOR_C1_D];
        }
        else if ([@"c2" isEqualToString:_qiumiBGColor]) {
            [self setBackgroundColor:QIUMI_COLOR_C2];
        }
        else if ([@"d1" isEqualToString:_qiumiBGColor]) {
            [self setBackgroundColor:QIUMI_COLOR_D1];
        }
        else if ([@"c3" isEqualToString:_qiumiBGColor]) {
            [self setBackgroundColor:QIUMI_COLOR_C3];
        }
        else if ([@"c4" isEqualToString:_qiumiBGColor]) {
            [self setBackgroundColor:QIUMI_COLOR_C4];
        }
        else
        {
            NSLog(@"not found color");
        }
    }
}
@end
