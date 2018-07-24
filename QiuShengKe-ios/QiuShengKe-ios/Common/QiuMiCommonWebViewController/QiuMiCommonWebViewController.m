//
//  QiuMiCommonWebViewController.m
//  Qiumi
//
//  Created by xieweijie on 14-12-15.
//  Copyright (c) 2014年 51viper.com. All rights reserved.
//

#import "QiuMiCommonWebViewController.h"
#import "ALAssetsLibrary+defaultAssetsLibrary.h"
//#import <AlipaySDK/AlipaySDK.h>

@interface QiuMiCommonWebViewController ()<UIWebViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate>
{
    UIImage* _image;
}
@property (strong, nonatomic) NSString* defaultUserAgent;
@end

@implementation QiuMiCommonWebViewController
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
    [[QiuMiCount instance]countPage:@"webview"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self forceSetOrientationPortrait];
}

- (void)loadView
{
    [super loadView];
    self.defaultUserAgent = [[UIWebView new] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
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
        [self.webView goBack];
        //用户交互关闭按钮
        if (self.navigationItem.leftBarButtonItems.count == 1) {
            UIButton* userCenterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [userCenterBtn setFrame:CGRectMake(0, 0, 44, 44)];
            [userCenterBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
            [userCenterBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
            [userCenterBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithCustomView:userCenterBtn];
            UIButton* stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [stopBtn setFrame:CGRectMake(44, 0, 44, 44)];
            [stopBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
            [stopBtn setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _navText;
    // Do any additional setup after loading the view.
    [self useDefaultBack];
    _image = nil;
    
    //修改useragent
    NSString* userAgent = [NSString stringWithFormat:@"%@/%@ AKQ (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
    NSDictionary *dictionary = @{@"UserAgent": [NSString stringWithFormat:@"%@", userAgent]};
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    
    UIButton* refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [refreshBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -18)];
    [refreshBtn setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithCustomView:refreshBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    if (![_url hasPrefix:@"http"]) {
        _url = [NSString stringWithFormat:@"http://%@", _url];
    }
    if ([_url isEqualToString:QIUMI_ABOUT_US]) {
        self.title = @"关于我们";
    }
    
//    _url = @"https://shop.liaogou168.com/tools/two_way";
    
    [self.webView setDelegate:self];
//    [self.webView setScalesPageToFit:YES];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    
    UILongPressGestureRecognizer *longPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    longPressed.delegate = self;
    [_webView addGestureRecognizer:longPressed];
    
//    self.hud.contentView = _webView;
//    [self.hud showloading];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)longPressed:(UITapGestureRecognizer*)recognizer{
    //只在长按手势开始的时候才去获取图片的url
    if (recognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    CGPoint touchPoint = [recognizer locationInView:self.webView];
    NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x*[UIScreen mainScreen].scale, touchPoint.y*[UIScreen mainScreen].scale];
    NSString *urlToSave = [self.webView stringByEvaluatingJavaScriptFromString:js];
    js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName", touchPoint.x*[UIScreen mainScreen].scale, touchPoint.y*[UIScreen mainScreen].scale];
    NSString *tagName = [self.webView stringByEvaluatingJavaScriptFromString:js];
    if (urlToSave.length == 0 || ![tagName isEqualToString:@"IMG"]) {
        return;
    }
    NSLog(@"获取到图片地址：%@",urlToSave);
    
    if (_image == nil) {
        SDWebImageDownloader* downer = [SDWebImageDownloader sharedDownloader];
        [downer downloadImageWithURL:[NSURL URLWithString:urlToSave] options:SDWebImageDownloaderHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            _image = image;
        }];
    }
    
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:@"保存二维码" delegate:self
                                             cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存" otherButtonTitles:nil];
    [sheet showInView:_webView];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        
    }
    else{
        [ALAssetsLibrary saveImage:_image withSuccess:^(NSURL *assetURL) {
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshWeb:(UIButton*)btn
{
    [self.webView reload];
}

- (void)share:(UIButton*)btn{
    NSString* paramsString = [_webView stringByEvaluatingJavaScriptFromString:@"appGetParams('ios')"];
    NSDictionary* dic = [paramsString objectFromJSONString];
    
    NSString* url = [dic objectForKey:@"url"];
    NSString* content = [dic objectForKey:@"content"];
    NSString * icon = [dic objectForKey:@"icon"];
    NSString * title = [dic objectForKey:@"title"];
    if ([content length] == 0) {
        content = [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('share_content')[0].content"];
        if ([content length] == 0) {
            content = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        }
    }
    
    if ([icon length] == 0) {
        icon = [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('share_icon')[0].content"];
    }
    
    if ([title length] == 0) {
        title = [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('share_title')[0].content"];
        if ([title length] == 0) {
            title = @"料狗";
        }
    }
    if ([url length] == 0) {
        url = [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('share_url')[0].content"];
        if ([url length] == 0) {
            url = _url;
        }
    }
    
    NSString* weixinContent = content;
    if ([weixinContent length] == 0) {
        weixinContent = [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('share_content')[0].content"];
        if ([weixinContent length] == 0) {
            weixinContent = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        }
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.hud hideloading];
    if ([_navText length] == 0) {
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    if ([webView.request.URL.absoluteString rangeOfString:@"/data/match_detail/"].location != NSNotFound) {
        NSString* _tmp = [webView stringByEvaluatingJavaScriptFromString:@"appNavName()"];
        if ([_tmp length] > 0) {
            self.title = _tmp;
        }
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    NSString* orderInfo = [[AlipaySDK defaultService]fetchOrderInfoFromH5PayUrl:[request.URL absoluteString]];
//    if (orderInfo.length > 0) {
//        [self payWithUrlOrder:orderInfo];
//        return NO;
//    }
    
    NSString* reqUrl = request.URL.absoluteString;
    if ([reqUrl hasPrefix:@"alipays://"] || [reqUrl hasPrefix:@"alipay://"]) {
        BOOL bSucc = [[UIApplication sharedApplication]openURL:request.URL];
        //bSucc是否成功调起支付宝
        return !bSucc;
    }
    
    if ([[[request URL] absoluteString] isEqualToString:@"liaogou://share"]){
        [self share:nil];
        return NO;
    }
    
    if ([QiuMiCommonViewController checkNav:[[request URL] absoluteString]]) {
        [QiuMiCommonViewController navTo:[[request URL] absoluteString]];
        return NO;
    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark   ============== URL pay 开始支付 ==============

//- (void)payWithUrlOrder:(NSString*)urlOrder
//{
//    if (urlOrder.length > 0) {
//        QiuMiWeakSelf(self);
//        [[AlipaySDK defaultService]payUrlOrder:urlOrder fromScheme:@"liaogou" callback:^(NSDictionary* result) {
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
