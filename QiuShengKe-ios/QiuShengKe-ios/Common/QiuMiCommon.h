//
//  QiuMiCommon.h
//  Qiumi
//
//  Created by xieweijie on 15-1-7.
//  Copyright (c) 2015年 51viper.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef enum {
    QiuMiCIPhotoEffectInstant = 0,  //怀旧
    QiuMiCIPhotoEffectNoir = 1,     //黑白
    QiuMiCIPhotoEffectTonal,    //色调
    QiuMiCIPhotoEffectTransfer, //岁月
    QiuMiCIPhotoEffectMono,     //单色
    QiuMiCIPhotoEffectFade,     //褪色
    QiuMiCIPhotoEffectProcess,  //冲印
    QiuMiCIPhotoEffectChrome,   //铬黄
    QiumiCIPhotoEffectNone      //无效果
}QiuMiFilterEffect;

@interface QiuMiCommon : NSObject
//是否审核中使用
@property(nonatomic, assign)BOOL isInReview;
//是否使用支付宝
@property(nonatomic, assign)BOOL useAli;
//帮助web
@property(nonatomic, strong)NSString* helpUrl;
//客服
@property(nonatomic, strong)NSString* kefu;
@property(nonatomic, strong)NSString* kefuIcon;

//广告
@property(nonatomic, strong)NSDictionary* ads;
/**
 * @brief 输入时间戳按规则返回显示时间
 @param time 时间戳，注意JAVA时间戳与unix时间戳有所不同，这里用的是java时间戳，如果使用unix时间戳请先乘以1000
 @returns 显示时间
 */
+ (NSString *)transformDateTime:(NSTimeInterval)time;

/*
 是否显示广告（推荐终端)
 */
+ (BOOL)showAd;

//单例
+ (QiuMiCommon*)instance;

/*
 @brief 返回表情图片本地文件(应该可以直接把图片放到app)
 */
+ (UIImage*)emojiImage:(NSString*)url;

/*
 @brief 获取表情列表
 */
+ (NSArray*)emojiList;

/*
 @brief 是否有emoji表情
 */
+ (BOOL)existEmoji:(NSString*)url;

/*
 @brief controller最后刷新时间是否处于app启动与退到后台时刻
 */
- (BOOL)isAfterLastTime:(NSString*)controllerName withSecond:(NSInteger)second;

/*
 @brief 刷新启动时间
 */
- (void)updateLastBecomeActiveTime;

/*
 @brief 刷新进入后台时间
 */
- (void)updateLastInBackgroundTime;

/*
 @brief 根据颜色返回图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/*
 @brief 添加球迷会搜索历史,如果text为nil返回所有
 */
+ (NSMutableArray*)clubHistoryAdd:(NSDictionary*)club;

/*
 @brief 删除球迷会搜索历史,如果text为nil返回所有
 */
+ (NSMutableArray*)clubHistoryDelete:(NSInteger)index;

/*
 @brief 返回系统light字体
 */
+ (UIFont*)systemLightFontWithSize:(float)fontSize;

/*
 @brief 判断图片是否存在缓存
 */
+ (BOOL)checkThePhotoInCacheWithPath:(NSString *)path;
/*
 @brief 就算年龄
 */
+ (NSString *)calculationAge:(NSString *)date;
/*
 @brief 根据类型返回衣服名字
 */
+ (NSString *)whitchClothes:(NSString *)clothes;
/*
 @brief 根据衣服类型返回type
 */
+ (NSInteger)whitchClothesType:(NSString *)clothes;

/*
 @brief 是否wifi
 */
- (BOOL)isWifi;

/*
 @brief 给image加滤镜 滤镜有分:
 CIPhotoEffectInstant 怀旧
 CIPhotoEffectNoir 黑白
 CIPhotoEffectTonal 色调
 CIPhotoEffectTransfer 岁月
 CIPhotoEffectMono 单色
 CIPhotoEffectFade 褪色
 CIPhotoEffectProcess 冲印
 CIPhotoEffectChrome 铬黄
 */
+ (void)targetImage:(UIImage *)targetImage withFilterName:(QiuMiFilterEffect)filterName FinishCallbackBlock:(void (^)(UIImage *result))block;
/*
 @brief 获取滤镜string
 */
+ (NSString*)getFilterNameByEnum:(QiuMiFilterEffect) filterName;
/*
 @brief 返回带属性的文字
 */
+ (NSMutableAttributedString *)attributedWithColor:(UIColor *)color withFont:(UIFont *)font withRange:(NSRange)range withString:(NSString *)string;

/**
 *  主要用于url拼凑UDID和token
 *
 *  @return 拼凑后的字符串
 */
+ (NSString *)appendUDIDandToken:(NSString*)string;
@end
