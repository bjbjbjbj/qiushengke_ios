//
//  QiuMiLabel.m
//  Qiumi
//
//  Created by Viper on 16/1/20.
//  Copyright © 2016年 51viper.com. All rights reserved.
//

#import "QiuMiLabel.h"

@implementation QiuMiLabel
- (void)setIsBlue:(BOOL)isBlue{
    if (isBlue) {
        self.textColor = QIUMI_COLOR_C1;
    }else{
        self.textColor = QIUMI_COLOR_G1;
    }
}


- (void)setIsTitle:(BOOL)isTitle{
    if (isTitle) {
        self.textColor = QIUMI_COLOR_G1;
    }
}

- (void)setIsSectionTitle:(BOOL)isSectionTitle{
    if (isSectionTitle) {
        self.textColor = QIUMI_COLOR_G2;
    }
}

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
            [self setTextColor:QIUMI_COLOR_G1];
        }
        else if ([@"g2" isEqualToString:_qiumiColor]) {
            [self setTextColor:QIUMI_COLOR_G2];
        }
        else if ([@"g4" isEqualToString:_qiumiColor]) {
            [self setTextColor:QIUMI_COLOR_G4];
        }
        else if ([@"g5" isEqualToString:_qiumiColor]) {
            [self setTextColor:QIUMI_COLOR_G5];
        }
        else if ([@"g7" isEqualToString:_qiumiColor]) {
            [self setTextColor:QIUMI_COLOR_G7];
        }
        else if ([@"g6" isEqualToString:_qiumiColor]) {
            [self setTextColor:QIUMI_COLOR_G6];
        }
        else if ([@"c1" isEqualToString:_qiumiColor]) {
            [self setTextColor:QIUMI_COLOR_C1];
        }
        else if ([@"c1d" isEqualToString:_qiumiColor]) {
            [self setTextColor:QIUMI_COLOR_C1_D];
        }
        else if ([@"c2" isEqualToString:_qiumiColor]) {
            [self setTextColor:QIUMI_COLOR_C2];
        }
        else if ([@"c3" isEqualToString:_qiumiColor]) {
            [self setTextColor:QIUMI_COLOR_C3];
        }
        else if ([@"c4" isEqualToString:_qiumiColor]) {
            [self setTextColor:QIUMI_COLOR_C4];
        }
        else if ([@"d1" isEqualToString:_qiumiColor]) {
            [self setTextColor:QIUMI_COLOR_D1];
        }
        else if([@"g85" isEqualToString:_qiumiColor]){
            [self setTextColor:QIUMI_COLOR_G85];
        }
        else if([@"g11" isEqualToString:_qiumiColor]){
            [self setTextColor:QIUMI_COLOR_G11];
        }
        else if([@"c5d" isEqualToString:_qiumiColor]){
            [self setTextColor:QIUMI_COLOR_C5_D];
        }
        else
        {
            NSLog(@"not found color");
        }
    }
    
    if (nil != _qiumiColorBG) {
        if ([@"g1" isEqualToString:_qiumiColorBG]) {
            [self setBackgroundColor:QIUMI_COLOR_G1];
        }
        else if ([@"g2" isEqualToString:_qiumiColorBG]) {
            [self setBackgroundColor:QIUMI_COLOR_G2];
        }
        else if ([@"g4" isEqualToString:_qiumiColorBG]) {
            [self setBackgroundColor:QIUMI_COLOR_G4];
        }
        else if ([@"g5" isEqualToString:_qiumiColorBG]) {
            [self setBackgroundColor:QIUMI_COLOR_G5];
        }
        else if ([@"g7" isEqualToString:_qiumiColorBG]) {
            [self setBackgroundColor:QIUMI_COLOR_G7];
        }
        else if ([@"g6" isEqualToString:_qiumiColorBG]) {
            [self setBackgroundColor:QIUMI_COLOR_G6];
        }
        else if ([@"c1" isEqualToString:_qiumiColorBG]) {
            [self setBackgroundColor:QIUMI_COLOR_C1];
        }
        else if ([@"c1d" isEqualToString:_qiumiColorBG]) {
            [self setBackgroundColor:QIUMI_COLOR_C1_D];
        }
        else if ([@"c2" isEqualToString:_qiumiColorBG]) {
            [self setBackgroundColor:QIUMI_COLOR_C2];
        }
        else if ([@"c3" isEqualToString:_qiumiColorBG]) {
            [self setBackgroundColor:QIUMI_COLOR_C3];
        }
        else if ([@"c4" isEqualToString:_qiumiColorBG]) {
            [self setBackgroundColor:QIUMI_COLOR_C4];
        }
        else if ([@"d1" isEqualToString:_qiumiColorBG]) {
            [self setBackgroundColor:QIUMI_COLOR_D1];
        }
        else
        {
            NSLog(@"not found color");
        }
    }
}

@end
