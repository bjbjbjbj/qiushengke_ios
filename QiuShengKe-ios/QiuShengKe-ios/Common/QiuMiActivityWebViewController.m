//
//  QiuMiActivityWebViewController.m
//  Qiumi
//
//  Created by xieweijie on 15/7/2.
//  Copyright (c) 2015年 51viper.com. All rights reserved.
//

#import "QiuMiActivityWebViewController.h"
//#import <AlipaySDK/AlipaySDK.h>

@interface QiuMiActivityWebViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) NSString* defaultUserAgent;

@end

@implementation QiuMiActivityWebViewController
- (void)dealloc
{
    if (_defaultUserAgent) {
        NSDictionary *dictionary = @{@"UserAgent": _defaultUserAgent};
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    }
    self.webView.delegate = nil;
    [self.hud hideloading];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO];
    [[QiuMiCount instance]countPage:@"webview"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self forceSetOrientationPortrait];
}

- (void)forceSetOrientationPortrait
{
    if (self.interfaceOrientation != UIInterfaceOrientationPortrait) {
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            SEL selector = NSSelectorFromString(@"setOrientation:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationPortrait;
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
    }
}

- (void)goBack:(id)sender
{
    if (self.webView.canGoBack) {
        self.title = @"料狗";
        [self.webView goBack];
        //用户交互关闭按钮
        if (self.navigationItem.leftBarButtonItems.count == 1) {
            UIButton* userCenterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [userCenterBtn setFrame:CGRectMake(0, 0, 40, 40)];
            [userCenterBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
            [userCenterBtn setImage:[UIImage imageNamed:@"btn_top_back"] forState:UIControlStateNormal];
            [userCenterBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithCustomView:userCenterBtn];
            UIButton* stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [stopBtn setFrame:CGRectMake(40, 0, 40, 40)];
            [stopBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
            [stopBtn setImage:[UIImage imageNamed:@"nav_stop_icon.png"] forState:UIControlStateNormal];
            [stopBtn addTarget:self action:@selector(stopWebView:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem* stopItem = [[UIBarButtonItem alloc]initWithCustomView:stopBtn];
            self.navigationItem.leftBarButtonItems = @[leftItem,stopItem];
        }
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)stopWebView:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadView
{
    [super loadView];
    self.defaultUserAgent = [[UIWebView new] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //修改useragent
    NSString* userAgent = [NSString stringWithFormat:@"%@/%@ Liaogou168 (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
    NSDictionary *dictionary = @{@"UserAgent": [NSString stringWithFormat:@"%@", userAgent]};
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    
    // Do any additional setup after loading the view.
    [self useDefaultBack];
    
    self.hud.contentView = _webView;
    [self.hud showloading];
    
    UIButton* refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [refreshBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -18)];
    [refreshBtn setImage:[UIImage imageNamed:@"btn_top_share"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(shareWeb:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithCustomView:refreshBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.title = @"";
    if (![_url hasPrefix:@"http"]) {
        _url = [NSString stringWithFormat:@"http://%@", _url];
    }
    self.webView.scalesPageToFit = YES;
    [self.webView setDelegate:self];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)shareWeb:(UIButton*)btn
{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self.hud hideloading];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    NSString* orderInfo = [[AlipaySDK defaultService]fetchOrderInfoFromH5PayUrl:[request.URL absoluteString]];
//    if (orderInfo.length > 0) {
//        [self payWithUrlOrder:orderInfo];
//        return NO;
//    }
    
    if ([[[request URL] absoluteString] rangeOfString:@"liaogou://"].location == NSNotFound) {
        return YES;
    }
    else
    {
        [QiuMiCommonViewController navTo:[[request URL] absoluteString]];
        return NO;
    }
}

#pragma mark   ============== URL pay 开始支付 ==============

//- (void)payWithUrlOrder:(NSString*)urlOrder
//{
//    if (urlOrder.length > 0) {
//        QiuMiWeakSelf(self);
//        [[AlipaySDK defaultService]payUrlOrder:urlOrder fromScheme:@"alisdkdemo" callback:^(NSDictionary* result) {
//            QiuMiStrongSelf(self);
//            // 处理支付结果
//            NSLog(@"%@", result);
//            // isProcessUrlPay 代表 支付宝已经处理该URL
//            if ([result[@"isProcessUrlPay"] boolValue]) {
//                // returnUrl 代表 第三方App需要跳转的成功页URL
//                NSString* urlStr = result[@"returnUrl"];
//                [self loadWithUrlStr:urlStr];
//            }
//        }];
//    }
//}

- (void)loadWithUrlStr:(NSString*)urlStr
{
    if (urlStr.length > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURLRequest *webRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                        cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                    timeoutInterval:30];
            [self.webView loadRequest:webRequest];
        });
    }
}

@end
