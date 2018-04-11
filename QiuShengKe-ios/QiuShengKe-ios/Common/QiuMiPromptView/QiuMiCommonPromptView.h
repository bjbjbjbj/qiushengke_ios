//
//  QiuMiCommonPromptView.h
//  Qiumi
//
//  Created by Viper on 16/5/9.
//  Copyright © 2016年 51viper.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#define QIUMI_COMMONPROMPT_TIP @"qiumi_commonprompt_tip"
#define QIUMI_NETWORK_TIP_TEXT @"请求异常请稍后再试"
#define QIUMI_TEXT_NODATA_TIP @"暂时还没有内容"
#define QIUMI_NO_NETWORK_TIP_TEXT @"你的网络被汹涌的红单阻断了"
#define QIUMI_NETWORK_SUCCESS @"加载成功"
#define QIUMI_NETWORK_FAIL @"加载失败"
#define QIUMI_NO_NETWORK @"网络不佳"

typedef enum
{
    //没有样式
    QiuMiCommonPromptNone = 0,
    //一般样式
    QiuMiCommonPromptDefualt = 1,
    //失败样式样式
    QiuMiCommonPromptFail = 2,
    //网络失败样式
    QiuMiCommonPromptNetFail = 3,
    //成功样式
    QiuMiCommonPromptSuccess = 4
}QiuMiCommonPromptType;

@interface QiuMiCommonPromptView : UIView
//出现的contentView
@property (nonatomic, weak) UIView * contentView;
+ (void)showLoading;
/**
 * @brief 显示提示
 * @param text 提示文本
 * @param secText 副提示文案
 * @param dic 积分经验相关
 * @param type 提示类型
 */
+ (void)showText:(NSString *)text withSecText:(NSString *)secText withDic:(NSDictionary *)dic withPrompt:(QiuMiCommonPromptType)type;
/*成功样式
  失败样式(分普通失败与网络失败)
  text:主标题
  secText:副标题
 */
+ (void)hideWithText:(NSString *)text withSecText:(NSString *)secText withType:(QiuMiCommonPromptType)type;

+ (void)hideWithText:(NSString *)text withSecText:(NSString *)secText withDic:(NSDictionary *)dic withType:(QiuMiCommonPromptType)type;
+ (void)hide;

- (void)showText:(NSString *)text withSecText:(NSString *)secText withDic:(NSDictionary *)dic withPrompt:(QiuMiCommonPromptType)type inContentView:(UIView *)view;
- (void)hideWithText:(NSString *)text withSecText:(NSString *)secText withType:(QiuMiCommonPromptType)type;
- (void)hideWithText:(NSString *)text withSecText:(NSString *)secText withDic:(NSDictionary *)dic withType:(QiuMiCommonPromptType)type;
- (void)hide;

- (void)showloadingWithY:(NSInteger)y;
- (void)showloading;
- (void)showNetWorkFail:(NSString*)text;
- (void)showloadingWithText:(NSString*)text;
- (void)hideloading;
- (void)hideloadingWithText:(NSString*)text;
//出现黑色错误层
- (void)hideloadingWhenFailWithText:(NSString*)text;
//网络失败那种
- (void)hideloadingWhenNoNet;
- (void)hideloadingWhenNoNetWithText:(NSString*)text;

@end
