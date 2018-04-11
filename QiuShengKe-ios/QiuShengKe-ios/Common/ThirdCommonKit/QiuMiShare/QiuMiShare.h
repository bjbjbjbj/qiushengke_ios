//
//  QiuMiShare.h
//  Qiumi
//
//  Created by xieweijie on 15/8/18.
//  Copyright (c) 2015年 51viper.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>

@interface QiuMiShareData : NSObject
/*
 * @brief 是否有图片
 */
@property(nonatomic, assign)BOOL hasImage;
/*
 * @brief 分享标题
 */
@property(nonatomic, strong)NSString * shareTitle;
/*
 * @brief 分享内容（只有文字的）
 */
@property(nonatomic, strong)NSString* publishContent;
/*
 * @brief 就新浪要加链接的。。。。
 */
@property(nonatomic, strong)NSString* contentWithUrl;
/*
 * @brief 微信用文案
 */
@property(nonatomic, strong)NSString* weixinContent;
/*
 * @brief 空间用的描述
 */
@property(nonatomic, strong)NSString* desContent;
 /*
 * @brief 内容链接
  */
@property(nonatomic, strong)NSString* url;
/*
 * @brief 分享的图片
 */
@property(nonatomic, strong)NSString* thumbUrl;
/*
 * @brief 微信要切正方形
 */
@property(nonatomic, strong)NSString* weixinThumbUrl;
/*
 * @brief 分享默认icon
 */
@property(nonatomic, strong)NSString* defaultShareIcon;
@end

@interface QiuMiShare : NSObject
/**
 @brief 分享图片，无UI
 */
+ (void)shareWithImage:(UIImage*)image withText:(NSString*)text withShareType:(SSDKPlatformType)shareType withSuccess:(void (^)(BOOL))success;

/*
 分享url，无UI
 */
+ (void)shareWithDictory:(QiuMiShareData*)shareData withType:(SSDKPlatformType)shareType withSuccess:(void(^)(BOOL success))success;
@end
