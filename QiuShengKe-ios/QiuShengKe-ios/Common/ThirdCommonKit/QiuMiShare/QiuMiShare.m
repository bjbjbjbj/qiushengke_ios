//
//  QiuMiShare.m
//  Qiumi
//
//  Created by xieweijie on 15/8/18.
//  Copyright (c) 2015年 51viper.com. All rights reserved.
//

#import "QiuMiShare.h"
@implementation QiuMiShareData

- (instancetype)init{
    self = [super init];
    if (self) {
        self.shareTitle = @"料狗";
    }
    return self;
}

@end

@implementation QiuMiShare
+ (void)shareWithImage:(UIImage *)image withText:(NSString *)text withShareType:(SSDKPlatformType)shareType withSuccess:(void (^)(BOOL))success
{
    if (nil == image) {
        return;
    }
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKEnableUseClientShare];
    [shareParams SSDKSetupShareParamsByText:text
                                     images:image
                                        url:nil
                                      title:text
                                       type:SSDKContentTypeAuto];
    
    switch (shareType) {
        case SSDKPlatformTypeSinaWeibo:
            [self share:shareParams withType:shareType withSuccess:success];
            break;
        case SSDKPlatformSubTypeWechatSession:
        {
            //定制微信好友信息
            [shareParams SSDKSetupWeChatParamsByText:text title:text url:nil thumbImage:image image:image musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];
            
            [self share:shareParams withType:shareType withSuccess:success];
        }
            break;
        case SSDKPlatformSubTypeWechatFav:
        {
            //定制微信收藏信息
            [shareParams SSDKSetupWeChatParamsByText:text title:text url:nil thumbImage:image image:image musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatFav];
            
            [self share:shareParams withType:shareType withSuccess:success];
        }
            break;
        case SSDKPlatformSubTypeQQFriend:
        {
            //定制QQ分享信息
            [shareParams SSDKSetupQQParamsByText:text title:text url:nil thumbImage:image image:image type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeQQFriend];
            
            [self share:shareParams withType:shareType withSuccess:success];
        }
            break;
        case SSDKPlatformSubTypeQZone:
        {
            //定制QQ空间信息
            [shareParams SSDKSetupQQParamsByText:text title:text url:nil thumbImage:image image:image type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeQZone];
            
            [self share:shareParams withType:shareType withSuccess:success];
        }
            break;
        case SSDKPlatformSubTypeWechatTimeline:
        {
            //定制微信朋友圈信息
            [shareParams SSDKSetupWeChatParamsByText:text title:text url:nil thumbImage:image image:image musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
            
            [self share:shareParams withType:shareType withSuccess:success];
        }
            break;
        default:
            break;
    }
}

+ (void)shareWithDictory:(QiuMiShareData *)shareData withType:(SSDKPlatformType)shareType withSuccess:(void (^)(BOOL))success
{
    if (nil == shareData.defaultShareIcon || shareData.defaultShareIcon.length == 0 || nil == [UIImage imageNamed:shareData.defaultShareIcon]) {
        shareData.defaultShareIcon = @"icon_face";
    }
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKEnableUseClientShare];
    [shareParams SSDKSetupShareParamsByText:shareData.contentWithUrl
                                     images:nil
                                        url:[NSURL URLWithString:shareData.url]
                                      title:shareData.shareTitle
                                       type:SSDKContentTypeAuto];
    
    switch (shareType) {
        case SSDKPlatformTypeSinaWeibo:
            [shareParams SSDKSetupSinaWeiboShareParamsByText:shareData.contentWithUrl
                                                       title:shareData.shareTitle
                                                       image:shareData.hasImage ? [[SSDKImage alloc]initWithURL:[NSURL URLWithString:shareData.thumbUrl]] : nil
                                                         url:[NSURL URLWithString:shareData.url]
                                                    latitude:0
                                                   longitude:0
                                                    objectID:nil
                                                        type:SSDKContentTypeAuto];
            [self share:shareParams withType:shareType withSuccess:success];
            break;
        case SSDKPlatformSubTypeWechatSession:
        {
            //定制微信好友信息
            SSDKImage* thumbImage = [[SSDKImage alloc]initWithImage:[UIImage imageNamed:shareData.defaultShareIcon] format:SSDKImageFormatPng settings:nil];
            if(shareData.hasImage)
            {
                thumbImage = [[SSDKImage alloc]initWithURL:[NSURL URLWithString:shareData.weixinThumbUrl]];
            }
            [shareParams SSDKSetupWeChatParamsByText:shareData.weixinContent title:shareData.shareTitle url:[NSURL URLWithString:shareData.url] thumbImage:thumbImage image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];
            
            [self share:shareParams withType:shareType withSuccess:success];
        }
            break;
        case SSDKPlatformSubTypeWechatFav:
        {
            //定制微信收藏信息
            SSDKImage* thumbImage = [[SSDKImage alloc]initWithImage:[UIImage imageNamed:shareData.defaultShareIcon] format:SSDKImageFormatPng settings:nil];
            if(shareData.hasImage)
            {
                thumbImage = [[SSDKImage alloc]initWithURL:[NSURL URLWithString:shareData.weixinThumbUrl]];
            }
            [shareParams SSDKSetupWeChatParamsByText:shareData.publishContent title:shareData.shareTitle url:[NSURL URLWithString:shareData.url] thumbImage:thumbImage image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatFav];
            
            [self share:shareParams withType:shareType withSuccess:success];
        }
            break;
        case SSDKPlatformSubTypeQQFriend:
        {
            //定制QQ分享信息
            SSDKImage* thumbImage = [[SSDKImage alloc]initWithImage:[UIImage imageNamed:shareData.defaultShareIcon] format:SSDKImageFormatPng settings:nil];
            if(shareData.hasImage)
            {
                thumbImage = [[SSDKImage alloc]initWithURL:[NSURL URLWithString:shareData.weixinThumbUrl]];
            }
            
            [shareParams SSDKSetupQQParamsByText:shareData.publishContent title:shareData.shareTitle url:[NSURL URLWithString:shareData.url] thumbImage:thumbImage image:thumbImage type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeQQFriend];
            
            [self share:shareParams withType:shareType withSuccess:success];
        }
            break;
        case SSDKPlatformSubTypeQZone:
        {
            //定制QQ空间信息
            SSDKImage* thumbImage = [[SSDKImage alloc]initWithImage:[UIImage imageNamed:shareData.defaultShareIcon] format:SSDKImageFormatPng settings:nil];
            if(shareData.hasImage)
            {
                thumbImage = [[SSDKImage alloc]initWithURL:[NSURL URLWithString:shareData.thumbUrl]];
            }
            [shareParams SSDKSetupQQParamsByText:shareData.publishContent title:shareData.shareTitle url:[NSURL URLWithString:shareData.url] thumbImage:thumbImage image:thumbImage type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeQZone];
            
            [self share:shareParams withType:shareType withSuccess:success];
        }
            break;
        case SSDKPlatformSubTypeWechatTimeline:
        {
            //定制微信朋友圈信息
            SSDKImage* thumbImage = [[SSDKImage alloc]initWithImage:[UIImage imageNamed:shareData.defaultShareIcon] format:SSDKImageFormatPng settings:nil];
            if(shareData.hasImage)
            {
                thumbImage = [[SSDKImage alloc]initWithURL:[NSURL URLWithString:shareData.weixinThumbUrl]];
            }
            [shareParams SSDKSetupWeChatParamsByText:shareData.weixinContent title:shareData.shareTitle url:[NSURL URLWithString:shareData.url] thumbImage:thumbImage image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
            
            [self share:shareParams withType:shareType withSuccess:success];
        }
            break;
        default:
            break;
    }
}

+ (void)share:(NSMutableDictionary*)publishContent withType:(SSDKPlatformType)type withSuccess:(void(^)(BOOL))success
{
    [ShareSDK share:type
         parameters:publishContent
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         if (state == SSDKResponseStateSuccess)
         {
             if (success) {
                 success(YES);
             }
             
             if (type == SSDKPlatformSubTypeWechatFav) {
//                 [QiuMiDetailPromptView showText:@"收藏成功" withDic:nil withPrompt:QiuMiDetailPromptDefault];
             }
             else if(type == SSDKPlatformSubTypeQZone ||
                     type == SSDKPlatformTypeSinaWeibo ||
                     type == SSDKPlatformSubTypeWechatTimeline)
             {
                 [QiuMiPromptView showText:@"分享成功"];
             }
             
             NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
             switch (type) {
                 case SSDKPlatformTypeSinaWeibo:
                     [MobClick event:@"share" label:@"微博"];
                     break;
                 case SSDKPlatformSubTypeWechatSession:
                     [MobClick event:@"share" label:@"微信"];
                     break;
                 case SSDKPlatformSubTypeWechatTimeline:
                     [MobClick event:@"share" label:@"朋友圈"];
                     break;
                 case SSDKPlatformSubTypeQQFriend:
                     [MobClick event:@"share" label:@"QQ"];
                     break;
                 case SSDKPlatformSubTypeQZone:
                     [MobClick event:@"share" label:@"QQ空间"];
                     break;
                 default:
                     break;
             }
         }
         else if (state == SSDKResponseStateFail)
         {
             if (success) {
                 success(NO);
             }
             
             if (type == SSDKPlatformSubTypeWechatFav) {
                 [QiuMiPromptView showText:@"收藏失败"];
             }
             else{
                 [QiuMiPromptView showText:@"分享失败"];
             }
//             NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
         }
     }];
}
@end
