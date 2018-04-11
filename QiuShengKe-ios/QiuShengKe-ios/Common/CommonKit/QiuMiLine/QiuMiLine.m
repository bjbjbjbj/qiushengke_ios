//
//  QiuMiLine.m
//  Qiumi
//
//  Created by xieweijie on 15/8/31.
//  Copyright (c) 2015年 51viper.com. All rights reserved.
//

#import "QiuMiLine.h"
#ifdef QIUMI_COLOR_G4
#define LINE_COLOR QIUMI_COLOR_G4
#else
#define LINE_COLOR COLOR(208,214,225,1)
#endif

@implementation QiuMiLine

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithPosition:(CGPoint)point withType:(QiuMiLineType)type withLength:(int)length
{
    return [self initWithPosition:point withType:type withLength:length withColor:LINE_COLOR];
}

- (id)initWithPosition:(CGPoint)point withType:(QiuMiLineType)type withLength:(int)length withColor:(UIColor *)color
{
    if (type == QiuMiLineHorizontal) {
        self = [super initWithFrame:CGRectMake(point.x, point.y + .5, length, .5)];
    }
    else
    {
        self = [super initWithFrame:CGRectMake(point.x, point.y, .5, length)];
    }
    [self setBackgroundColor:color];
    return self;
}
@end
