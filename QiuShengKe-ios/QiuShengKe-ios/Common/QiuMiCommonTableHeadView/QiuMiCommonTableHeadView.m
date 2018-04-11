//
//  QiuMiCommonTableHeadView.m
//  Qiumi
//
//  Created by Viper on 16/3/22.
//  Copyright © 2016年 51viper.com. All rights reserved.
//

#import "QiuMiCommonTableHeadView.h"

@implementation QiuMiCommonTableHeadView
- (instancetype)initWithFrame:(CGRect)frame withIcon:(NSString *)iconString withTitle:(NSString *)titleString
{
    return [self initWithFrame:frame withIcon:iconString withTitle:titleString beginY:8];
}

- (instancetype)initWithFrame:(CGRect)frame withIcon:(NSString *)iconString withTitle:(NSString *)titleString beginY:(CGFloat)y{
//#warning icon_diamonds_blue.png 这个图注意
    self = [self initWithFrame:frame];
    [self setBackgroundColor:QIUMI_COLOR_G5];
    [self setClipsToBounds:YES];
    UIView * head = [[UIView alloc]initWithFrame:CGRectMake(0, y, SCREENWIDTH, frame.size.height - y)];
    [head setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:head];
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height - y - .5, SCREENWIDTH, 0.5)];
    self.line = line;
    [line setBackgroundColor:QIUMI_COLOR_G4];
    [head addSubview:line];
    if ([iconString length] == 0) {
        UIImageView * icon = [[UIImageView alloc]initWithFrame:CGRectMake(12, (frame.size.height - y - 20)/2, 4, 20)];
        [icon setBackgroundColor:COLOR(249, 66, 61, 1)];
//        icon.layer.cornerRadius = 2;
        icon.layer.masksToBounds = YES;
        [head addSubview:icon];
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(22, (frame.size.height - y - 18)/2, 200, 18)];
        [title setText:titleString];
        [title setTextAlignment:NSTextAlignmentLeft];
        [title setFont:[UIFont systemFontOfSize:16.0]];
        [title setTextColor:QIUMI_COLOR_G1];
        [head addSubview:title];
    }
    else{
        UIImageView * icon = [[UIImageView alloc]initWithFrame:CGRectMake(8, (head.frame.size.height - 22)/2, 22, 22)];
        [icon setImage:[UIImage imageNamed:iconString]];
//        [icon setBackgroundColor:QIUMI_COLOR_C1];
//        icon.layer.cornerRadius = 2;
//        icon.layer.masksToBounds = YES;
        [head addSubview:icon];
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(8+22+8, (head.frame.size.height - 18)/2, 200, 18)];
        [title setText:titleString];
        [title setTextAlignment:NSTextAlignmentLeft];
        [title setFont:[UIFont systemFontOfSize:16.0]];
        [title setTextColor:QIUMI_COLOR_G1];
        [head addSubview:title];
    }
    return self;

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
