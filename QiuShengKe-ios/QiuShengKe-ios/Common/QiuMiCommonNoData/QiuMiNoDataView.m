//
//  QiuMiNoDataView.m
//  Qiumi
//
//  Created by Viper on 15/8/4.
//  Copyright (c) 2015年 51viper.com. All rights reserved.
//

#import "QiuMiNoDataView.h"

@interface QiuMiNoDataView ()
@end

@implementation QiuMiNoDataView

+ (instancetype)createWithXib{
    return [[NSBundle mainBundle] loadNibNamed:@"QiuMiNoDataView" owner:self options:nil][0];
}

+(void)clearNoDataView:(UIView *)view
{
    [[view viewWithTag:[QIUMI_NODATA_TIP hash]] removeFromSuperview];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setTag:[QIUMI_NODATA_TIP hash]];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickView:)];
    [self addGestureRecognizer:tap];
}

- (void)clickView:(UITapGestureRecognizer*)ges
{
    if (_clickBlock) {
        _clickBlock();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSInteger)getY:(NSInteger)type
{
    NSInteger y = type*(1.0*SCREENWIDTH/320);
    return y;
}

- (void)updateWithFrame:(CGRect)frame withIcon:(NSString *)icon withFirst:(NSString *)first withSecond:(NSString *)second withY:(NSInteger)y
{
    [self setFrame:frame];
    [self setTag:[QIUMI_NODATA_TIP hash]];
    [_image setImage:[UIImage imageNamed:icon]];
    [_firstLable setText:first];
    [_secondLabel setText:second];
    
    QiuMiViewSetOrigin(_bgView, CGPointMake((SCREENWIDTH - 320)/2, y));
}

- (void)updateSayHiWithFrame:(CGRect)frame withType:(NSInteger)type WithFirst:(NSString *)first withSecond:(NSString *)second
{
    [self updateWithFrame:frame withIcon:QIUMI_DEFAULT_NODATA_SAYHI withFirst:first withSecond:second withY:[self getY:type]];
}

- (void)updateCryWithFrame:(CGRect)frame withType:(NSInteger)type WithFirst:(NSString *)first withSecond:(NSString *)second
{
    [self updateWithFrame:frame withIcon:@"icon_liaogou_black" withFirst:first withSecond:second withY:type];
}

- (void)updateNoWifiWithFrame:(CGRect)frame withType:(NSInteger)type withBlock:(ClickBlock)block
{
    [self setTag:[QIUMI_NODATA_TIP hash]];
    [self updateWithFrame:frame withIcon:@"icon_liaogou_black" withFirst:@"抱歉，当前网络不佳" withSecond:@"请联网后点击刷新" withY:[self getY:type]];
    self.clickBlock = block;
}

+ (QiuMiNoDataView *)updateNoWifiWithFrame:(CGRect)frame withType:(NSInteger)type withBlock:(ClickBlock)block
{
    QiuMiNoDataView* nodata = [QiuMiNoDataView createWithXib];
    [nodata updateNoWifiWithFrame:frame withType:type withBlock:block];
    return nodata;
}

+ (QiuMiNoDataView *)updateCryWithFrame:(CGRect)frame withType:(NSInteger)type WithFirst:(NSString *)first withSecond:(NSString *)second
{
    QiuMiNoDataView* nodata = [QiuMiNoDataView createWithXib];
    [nodata updateCryWithFrame:frame withType:type WithFirst:first withSecond:second];
    return nodata;
}

+ (QiuMiNoDataView *)updateSayHiWithFrame:(CGRect)frame withType:(NSInteger)type WithFirst:(NSString *)first withSecond:(NSString *)second
{
    QiuMiNoDataView* nodata = [QiuMiNoDataView createWithXib];
    [nodata updateSayHiWithFrame:frame withType:type WithFirst:first withSecond:second];
    return nodata;
}

+ (QiuMiNoDataView *)updateWithFrame:(CGRect)frame withIcon:(NSString *)icon withFirst:(NSString *)first withSecond:(NSString *)second withY:(NSInteger)y
{
    QiuMiNoDataView* nodata = [QiuMiNoDataView createWithXib];
    [nodata updateWithFrame:frame withIcon:icon withFirst:first withSecond:second withY:y];
    return nodata;
}
@end
