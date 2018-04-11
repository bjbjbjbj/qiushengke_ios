//
//  QiuMiShareView.m
//  Qiumi
//
//  Created by xieweijie on 15/8/24.
//  Copyright (c) 2015年 51viper.com. All rights reserved.
//

#import "QiuMiShareView.h"
#define QIUMI_SHARE_ICON_WIDTH 44
@interface QiuMiShareView()
@property(nonatomic, strong)IBOutlet UIButton* cancelBtn;
@property(nonatomic, strong)IBOutlet UIScrollView* shareScrollView;

@property(nonatomic, strong)QiuMiShareData* dic;
@property(nonatomic, copy)QiuMiShareSuccess shareSuccessBlock;
@end

@implementation QiuMiShareView
+ (instancetype)instants
{
    static QiuMiShareView* _current;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _current = [[[NSBundle mainBundle]loadNibNamed:@"QiuMiShareView" owner:nil options:nil] objectAtIndex:0];
        [_current setFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        
        QiuMiLine* line = [[QiuMiLine alloc]initWithPosition:CGPointMake(10, 200) withType:QiuMiLineHorizontal withLength:SCREENWIDTH - 20];
        [line setTag:[@"line" hash]];
        [_current.alertView addSubview:line];
        [_current.bgView setBackgroundColor:[UIColor colorWithWhite:0 alpha:.6]];
    });
    return _current;
}

- (void)showWithDictory:(QiuMiShareData *)dic withSuccess:(QiuMiShareSuccess)success withAnimate:(BOOL)withAnimate
{
    if (dic == nil) {
        return;
    }
    self.dic = dic;
    self.shareSuccessBlock = success;
    
    [self setupUI];
    
//    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    //防止模态框导致消失，如actionsheet那种
    [self showAlert];
}

- (void)showWithDictory:(QiuMiShareData *)dic withSuccess:(QiuMiShareSuccess)success
{
    [self showWithDictory:dic withSuccess:success withAnimate:YES];
}

- (void)setupUI
{
    QiuMiViewSetOrigin([self.alertView viewWithTag:[@"line" hash]], CGPointMake(10, self.alertView.frame.size.height - 44 - .5));
    
    NSArray* shareItems = @[@""];
    //@"微信好友",@"微信朋友圈",@"QQ",@"微博",@"QQ空间",@"微信收藏"顺序对应0-5
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        if ([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]) {
            shareItems = @[@0,@1,@2,@3,@5];
        }
        else
        {
            shareItems = @[@0,@1,@3,@5];
        }
    }
    else
    {
        if ([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]) {
            shareItems = @[@2,@3];
        }
        else
        {
            shareItems = @[@3];
        }
    }
    
#if DEWEN
//    if ([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]) {
//        shareItems = @[@2,@3];
//    }
//    else
//    {
//        shareItems = @[@3];
//    }
#else
    
#endif
    
    for (int i = 0; i < [shareItems count]; i++) {
        NSString* buttonIcon = @"";
        NSString* labelName = @"";
        switch ([[shareItems objectAtIndex:i] integerValue]) {
            case 0:
                buttonIcon = @"icon_share_wechat";
                labelName = @"微信好友";
                break;
            case 1:
                buttonIcon = @"icon_share_moment";
                labelName = @"微信朋友圈";
                break;
            case 2:
                buttonIcon = @"icon_share_qq";
                labelName = @"QQ";
                break;
            case 3:
                buttonIcon = @"icon_share_weibo";
                labelName = @"微博";
                break;
            case 4:
                buttonIcon = @"icon_share_qzone";
                labelName = @"QQ空间";
                break;
            case 5:
                buttonIcon = @"icon_share_favourite";
                labelName = @"微信收藏";
                break;
            default:
                break;
        }
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTag:[[shareItems objectAtIndex:i] integerValue]];
        [button addTarget:self action:@selector(clickShare:) forControlEvents:UIControlEventTouchUpInside];
        [button setFrame:CGRectMake(24 + (44 + 24)*i, 20, 44, 44)];
        [button setImage:[UIImage imageNamed:buttonIcon] forState:UIControlStateNormal];
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(button.center.x - 65/2, 4 + CGRectGetMaxY(button.frame), 65, 15)];
        [label setText:labelName];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:QIUMI_COLOR_G1];
        [label setFont:[UIFont systemFontOfSize:10]];
        [_shareScrollView addSubview:button];
        [_shareScrollView addSubview:label];
    }
    [_shareScrollView setContentSize:CGSizeMake(24+(24+44)*[shareItems count], 100)];
}

- (IBAction)clickClose:(id)sender
{
    [self hideAlert];
}

- (IBAction)clickShareWeiXin:(id)sender
{
    if ([_dic.url length] == 0) {
        return;
    }
    //分享
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:_dic.url];
    [QiuMiPromptView showText:@"已复制到剪切板，请打开微信分享链接"];
    return;
    
    __weak typeof(self) wself = self;
    [QiuMiShare shareWithDictory:_dic withType:SSDKPlatformSubTypeWechatSession withSuccess:^(BOOL success) {
        if (wself.shareSuccessBlock) {
            wself.shareSuccessBlock(success);
        }
        [wself clickClose:nil];
    }];
}

- (IBAction)clickShareFriend:(id)sender
{
    __weak typeof(self) wself = self;
    [QiuMiShare shareWithDictory:_dic withType:SSDKPlatformSubTypeWechatTimeline withSuccess:^(BOOL success) {
        if (wself.shareSuccessBlock) {
            wself.shareSuccessBlock(success);
        }
        [wself clickClose:nil];
    }];
}

- (IBAction)clickShareSina:(id)sender
{
    __weak typeof(self) wself = self;
    [QiuMiShare shareWithDictory:_dic withType:SSDKPlatformTypeSinaWeibo withSuccess:^(BOOL success) {
        if (wself.shareSuccessBlock) {
            wself.shareSuccessBlock(success);
        }
        [wself clickClose:nil];
    }];
}

- (IBAction)clickShareFav:(id)sender
{
    __weak typeof(self) wself = self;
    [QiuMiShare shareWithDictory:_dic withType:SSDKPlatformSubTypeWechatFav withSuccess:^(BOOL success) {
        if (wself.shareSuccessBlock) {
            wself.shareSuccessBlock(success);
        }
        [wself clickClose:nil];
    }];
}

- (IBAction)clickShareQzone:(id)sender
{
    __weak typeof(self) wself = self;
    [QiuMiShare shareWithDictory:_dic withType:SSDKPlatformSubTypeQZone withSuccess:^(BOOL success) {
        if (wself.shareSuccessBlock) {
            wself.shareSuccessBlock(success);
        }
        [wself clickClose:nil];
    }];
}

- (IBAction)clickShareQQ:(id)sender
{
    __weak typeof(self) wself = self;
    [QiuMiShare shareWithDictory:_dic withType:SSDKPlatformSubTypeQQFriend withSuccess:^(BOOL success) {
        if (wself.shareSuccessBlock) {
            wself.shareSuccessBlock(success);
        }
        [wself clickClose:nil];
    }];
}

- (IBAction)clickShare:(UIButton*)sender
{
    switch (sender.tag) {
        case 0:
            [self clickShareWeiXin:sender];
            break;
        case 1:
            [self clickShareFriend:sender];
            break;
        case 2:
            [self clickShareQQ:sender];
            break;
        case 3:
            [self clickShareSina:sender];
            break;
        case 4:
            [self clickShareQzone:sender];
            break;
        case 5:
            [self clickShareFav:sender];
            break;
        default:
            break;
    }
}
@end
