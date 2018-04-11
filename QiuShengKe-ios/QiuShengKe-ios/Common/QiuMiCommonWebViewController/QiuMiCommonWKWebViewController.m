//
//  QiuMiCommonWKWebViewController.m
//  LiaoGou
//
//  Created by xieweijie on 2017/8/16.
//  Copyright © 2017年 xieweijie. All rights reserved.
//

#import "QiuMiCommonWKWebViewController.h"
#import <WebKit/WebKit.h>
#import "WKCookieSyncManager.h"
@interface QiuMiCommonWKWebViewController ()<WKNavigationDelegate>{
    UIImage* _image;
    BOOL _first;
}
@property(nonatomic, strong) WKWebView* webview;
@property(nonatomic, strong) CALayer* progresslayer;
@end

@implementation QiuMiCommonWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needToHideNavigationBar = NO;
//    [self.navigationController.navigationBar setBackgroundColor:QIUMI_COLOR_C1];
    _first = YES;
    // Do any additional setup after loading the view.
    [self useDefaultBack];
    
    self.title = _navText;
    // Do any additional setup after loading the view.
    _image = nil;
    
    //修改useragent
    NSString* userAgent = [NSString stringWithFormat:@"%@/%@ Liaogou168 (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
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
    
    WKCookieSyncManager *cookiesManager = [WKCookieSyncManager sharedWKCookieSyncManager];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.processPool = cookiesManager.processPool;
    configuration.allowsInlineMediaPlayback = YES;//是否允许内联(YES)或使用本机全屏控制器(NO)，默认是NO。
    configuration.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeVideo;
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - STATUSHEIGHT - self.navigationController.navigationBar.frame.size.height) configuration:configuration];
    [self.view addSubview:webView];
    
    self.webview = webView;
    [_webview setNavigationDelegate:self];
    
//    self.url = @"http://192.168.30.104/newsell2/video.html";
//    self.url = @"http://www.lg310.com/live/player.html?cid=4270";
    
    NSURL *url = [NSURL URLWithString:_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [_webview loadRequest:request];
    
//    UIWebView* bj = [[UIWebView alloc]initWithFrame:webView.frame];
//    [bj loadRequest:request];
//    [self.view addSubview:bj];
    
    [self setupPro];
}

- (void)dealloc{
    [self.webview removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)setupPro{
    //进度条
    [_webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    UIView *progress = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 3)];
    progress.backgroundColor = [UIColor clearColor];
    [self.view addSubview:progress];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 0, 3);
    layer.backgroundColor = QIUMI_COLOR_C1.CGColor;
    [progress.layer addSublayer:layer];
    self.progresslayer = layer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progresslayer.opacity = 1;
        //不要让进度条倒着走...有时候goback会出现这种情况
        if ([change[@"new"] floatValue] < [change[@"old"] floatValue]) {
            return;
        }
        self.progresslayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[@"new"] floatValue], 3);
        if ([change[@"new"] floatValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.opacity = 0;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.frame = CGRectMake(0, 0, 0, 3);
            });
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)goBack:(id)sender{
    if (self.webview.canGoBack) {
        [self.webview goBack];
        //用户交互关闭按钮
        if (self.navigationItem.leftBarButtonItems.count == 1) {
            UIButton* userCenterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [userCenterBtn setFrame:CGRectMake(0, 0, 44, 44)];
            [userCenterBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -28, 0, 0)];
            [userCenterBtn setImage:[UIImage imageNamed:@"match_icon_back_n"] forState:UIControlStateNormal];
            [userCenterBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithCustomView:userCenterBtn];
            UIButton* stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [stopBtn setFrame:CGRectMake(44, 0, 44, 44)];
            [stopBtn setContentEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
            [stopBtn setTitle:@"关闭" forState:UIControlStateNormal];
            [stopBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
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

#pragma mark - webview
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
//    NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
//    NSArray *cookies =[NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:response.URL];
//    //读取wkwebview中的cookie 方法1
//    for (NSHTTPCookie *cookie in cookies) {
//        //        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
//        NSLog(@"wkwebview中的cookie:%@", cookie);
//        
//    }
//    //读取wkwebview中的cookie 方法2 读取Set-Cookie字段
//    NSString *cookieString = [[response allHeaderFields] valueForKey:@"Set-Cookie"];
//    NSLog(@"wkwebview中的cookie:%@", cookieString);
//    
//    //看看存入到了NSHTTPCookieStorage了没有
//    NSHTTPCookieStorage *cookieJar2 = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (NSHTTPCookie *cookie in cookieJar2.cookies) {
//        NSLog(@"NSHTTPCookieStorage中的cookie%@", cookie);
//    }
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *URL = navigationAction.request.URL;
    NSString *reqUrl = [URL absoluteString];
    if ([reqUrl hasPrefix:@"alipays://"] || [reqUrl hasPrefix:@"alipay://"]) {
        BOOL bSucc = [[UIApplication sharedApplication]openURL:URL];
        //bSucc是否成功调起支付宝
        if (bSucc) {
            decisionHandler(WKNavigationActionPolicyCancel);
        }
        else{
            decisionHandler(WKNavigationActionPolicyAllow);
        }
        return;
    }
    
    if ([reqUrl isEqualToString:@"liaogou://share"]){
        [self share:nil];
         decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    if ([QiuMiCommonViewController checkNav:reqUrl]) {
        [QiuMiCommonViewController navTo:reqUrl];
         decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    if ([_navText length] == 0) {
        [self.webview evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
            self.title = title;
        }];
    }
    NSString* url = webView.URL.absoluteString;
    if ([url rangeOfString:@"/data/match_detail/"].location != NSNotFound) {
        [self.webview evaluateJavaScript:@"appNavName()" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
            self.title = title;
        }];
    }
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}
#pragma mark - 分享
- (void)refreshWeb:(UIButton*)btn
{
    [self.webview reload];
}

- (void)share:(UIButton*)btn{
    [self.webview evaluateJavaScript:@"appGetParams('ios')" completionHandler:^(id _Nullable paramsString, NSError * _Nullable error) {
        NSDictionary* dic = [paramsString objectFromJSONString];
        
        __block NSString* url = [dic objectForKey:@"url"];
        __block NSString* content = [dic objectForKey:@"content"];
        __block NSString * icon = [dic objectForKey:@"icon"];
        __block NSString * title = [dic objectForKey:@"title"];
        if ([content length] == 0) {
             [_webview evaluateJavaScript:@"document.getElementsByName('share_content')[0].content" completionHandler:^(id _Nullable text, NSError * _Nullable error) {
                content = text;
            }];
            if ([content length] == 0) {
                [_webview evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable text, NSError * _Nullable error) {
                    content = text;
                }];
            }
        }
        
        if ([icon length] == 0) {
            [_webview evaluateJavaScript:@"document.getElementsByName('share_icon')[0].content" completionHandler:^(id _Nullable text, NSError * _Nullable error) {
                icon = text;
            }];
        }
        
        if ([title length] == 0) {
            [_webview evaluateJavaScript:@"document.getElementsByName('share_title')[0].content" completionHandler:^(id _Nullable text, NSError * _Nullable error) {
                title = text;
            }];
            if ([title length] == 0) {
                title = @"料狗";
            }
        }
        if ([url length] == 0) {
            [_webview evaluateJavaScript:@"document.getElementsByName('share_url')[0].content" completionHandler:^(id _Nullable text, NSError * _Nullable error) {
                url = text;
            }];
            if ([url length] == 0) {
                url = _url;
            }
        }
        
        NSString* weixinContent = content;
        
//        QiuMiShareData* shareData = [[QiuMiShareData alloc]init];
//        shareData.publishContent = weixinContent;
//        shareData.hasImage = icon.length > 0;
//        shareData.contentWithUrl = [NSString stringWithFormat:@"%@ %@",content, url];
//        shareData.desContent = weixinContent;
//        shareData.weixinContent = content;
//        shareData.shareTitle = title;
//        shareData.url = url;
//        if (icon.length > 0) {
//            shareData.thumbUrl = icon;
//            shareData.weixinThumbUrl = icon;
//        }
//        [[QiuMiShareView instants]showWithDictory:shareData withSuccess:nil];
    }];
}

@end
