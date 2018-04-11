//
//  QiuMiNoDataView.h
//  Qiumi
//
//  Created by Viper on 15/8/4.
//  Copyright (c) 2015年 51viper.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#define QIUMI_NODATA_WITHTAB 53
#define QIUMI_NODATA_WITHHEAD_TAB 78
#define QIUMI_NODATA_NAV 140
#define QIUMI_NODATA_WITHCLUB 195

#define QIUMI_DEFAULT_NODATA_SAYHI @"icon_liaogou_black"

#define QIUMI_NODATA_TIP @"nodataView"

typedef void(^ClickBlock)();

@interface QiuMiNoDataView : UIView
@property (nonatomic , weak) IBOutlet UILabel * firstLable;
@property (nonatomic , weak) IBOutlet UILabel * secondLabel;
@property (nonatomic , weak) IBOutlet UIImageView * image;
@property (nonatomic, weak)IBOutlet UIView* bgView;
@property (nonatomic, copy)ClickBlock clickBlock;
//这两个一样了
+ (instancetype)createWithXib;
//清理空view
+ (void)clearNoDataView:(UIView *)view;

//设置数据，icon默认150*150，y代表图片举例顶部多少
- (void)updateWithFrame:(CGRect)frame withIcon:(NSString*)icon withFirst:(NSString*)first withSecond:(NSString*)second withY:(NSInteger)y;

//用say hi icon
- (void)updateSayHiWithFrame:(CGRect)frame withType:(NSInteger)type WithFirst:(NSString*)first withSecond:(NSString*)second;

//用哭 icon
- (void)updateCryWithFrame:(CGRect)frame withType:(NSInteger)type WithFirst:(NSString*)first withSecond:(NSString*)second;

//网络错误
- (void)updateNoWifiWithFrame:(CGRect)frame withType:(NSInteger)type withBlock:(ClickBlock)block;

//静态方法版本，方便用
//设置数据，icon默认150*150，y代表图片举例顶部多少
+ (QiuMiNoDataView*)updateWithFrame:(CGRect)frame withIcon:(NSString*)icon withFirst:(NSString*)first withSecond:(NSString*)second withY:(NSInteger)y;

//用say hi icon
+ (QiuMiNoDataView*)updateSayHiWithFrame:(CGRect)frame withType:(NSInteger)type WithFirst:(NSString*)first withSecond:(NSString*)second;

//用哭 icon
+ (QiuMiNoDataView*)updateCryWithFrame:(CGRect)frame withType:(NSInteger)type WithFirst:(NSString*)first withSecond:(NSString*)second;

//网络错误
+ (QiuMiNoDataView*)updateNoWifiWithFrame:(CGRect)frame withType:(NSInteger)type withBlock:(ClickBlock)block;
@end
