//
//  PlayerViewController.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/16.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "PlayerViewController.h"
#import <PLPlayerKit/PLPlayerKit.h>
@interface PlayerViewController ()<PLPlayerDelegate>
@property(nonatomic, strong) IBOutlet UILabel* tips;
@property(nonatomic, strong) IBOutlet UIView* toolView;
@property(nonatomic, strong) IBOutlet UIButton* playBtn;
@property(nonatomic, strong) IBOutlet UIView* navView;
@property(nonatomic, strong) PLPlayer  *player;
@property(nonatomic, strong) NSArray* channels;
@property(nonatomic, strong) UIAlertController* alertController;
@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    self.needToHideNavigationBar = YES;
    // Do any additional setup after loading the view.
    [self _loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    self.player.delegate = nil;
    [_player stop];
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickBack:(id)sender{
    UIViewController * controller = [self getCurrentVC];
    if (controller.interfaceOrientation != UIInterfaceOrientationPortrait) {
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
    [[QiuMiCommonViewController navigationController] popViewControllerAnimated:YES];
}

- (void)_loadData{
    QiuMiWeakSelf(self);
    [[QiuMiHttpClient instance] GET:[NSString stringWithFormat:QSK_MATCH_CHANNELS,(_sport == 1?@"foot":@"basket"),[@(_mid) stringValue]] parameters:nil cachePolicy:QiuMiHttpClientCachePolicyNoCache success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QiuMiStrongSelf(self);
        self.channels = responseObject;
        if ([self.channels count] > 0) {
            [self loadChannel:0];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)loadChannel:(NSInteger)index{
    NSDictionary* dic = [_channels objectAtIndex:index];
    NSInteger type = 2;
    if ([dic existForKey:@"anchor_id"]) {
        type = 2;
    }
    else{
        type = 1;
    }
    NSString* url = @"";
    if (type == 1) {
        NSString* content = [dic objectForKey:@"content"];
        content = [content lastPathComponent];
        content = [content stringByReplacingOccurrencesOfString:@".html" withString:@""];
        if ([[content componentsSeparatedByString:@"-"] count] > 2) {
            url = [NSString stringWithFormat:@"http://www.aikq.cc/match/live/url/match/pc/%@_%@.json",[content componentsSeparatedByString:@"-"][1],[content componentsSeparatedByString:@"-"][2]];
        }
    }
    else{
        url = [QIUMI_API_PREFIX stringByAppendingString:[NSString stringWithFormat:@"/json/live/channel/%@.json",[dic objectForKey:@"id"]]];
    }
    [[QiuMiHttpClient instance] GET:url parameters:nil cachePolicy:QiuMiHttpClientCachePolicyNoCache success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (type == 1) {
            if ([responseObject integerForKey:@"code"] == 0 && [responseObject existForKey:@"playurl"]) {
                self.urlString = [responseObject objectForKey:@"playurl"];
                [self _setupPlayer:_urlString];
            }
        }
        else{
            if ([responseObject integerForKey:@"code"] == 0 && [responseObject existForKey:@"url"]) {
                self.urlString = [responseObject objectForKey:@"url"];
                [self _setupPlayer:_urlString];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)_setupPlayer:(NSString*)urlStr{
    if (self.player) {
        [self.player stop];
        [self.player.playerView removeFromSuperview];
        self.player.delegate = nil;
        self.player = nil;
    }
    
//    urlStr = @"http://flvtx.plu.cn/onlive/7aa459e52bea4a5b902b40cd356be9fd.flv?txSecret=7f0136f1ac4889367efd2b17e4c5e6d2&txTime=5ad476e7";
    
    NSURL* url = [[NSURL alloc] initWithString:urlStr];
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    [option setOptionValue:@5 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
    [option setOptionValue:@(kPLLogInfo) forKey:PLPlayerOptionKeyLogLevel];
    self.player = [PLPlayer playerLiveWithURL:url option:option];
    self.player.delegate = self;
    self.player.playerView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.player.playerView];
    [self.view sendSubviewToBack:self.player.playerView];
    
    self.player.playerView.translatesAutoresizingMaskIntoConstraints = NO;
    // 添加 left 约束
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.player.playerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [self.view addConstraint:leftConstraint];
    // 添加 top 约束
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.player.playerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self.view addConstraint:topConstraint];
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.player.playerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self.view addConstraint:rightConstraint];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.player.playerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self.view addConstraint:bottomConstraint];
    [self.player play];
    
    [self performSelector:@selector(fail) withObject:nil afterDelay:10];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTap:)];
    [_player.playerView addGestureRecognizer:tap];
}

- (void)clickTap:(UITapGestureRecognizer*)tap{
    [_navView setHidden:!_navView.isHidden];
    [_toolView setHidden:!_toolView.isHidden];
}

- (IBAction)clickPause:(id)sender{
    if (_player.isPlaying) {
        [_player pause];
        [_playBtn setTitle:@"继续" forState:UIControlStateNormal];
    }
    else{
        [_player resume];
        [_playBtn setTitle:@"暂停" forState:UIControlStateNormal];
    }
}

- (IBAction)clickChannel:(id)sender{
    if (_alertController == nil) {
        // 初始化 添加 提示内容
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"频道" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        for (NSInteger i = 0 ; i < [_channels count] ; i++) {
            NSDictionary* dic = [_channels objectAtIndex:i];
            QiuMiWeakSelf(self);
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:[dic objectForKey:@"name"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                QiuMiStrongSelf(self);
                [self loadChannel:i];
            }];
            [alertController addAction:okAction];
        }
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"cancel");
        }];
        [alertController addAction:cancelAction];
        
        
        // 移除
        [alertController dismissViewControllerAnimated:YES completion:^{
            NSLog(@"dismiss");
        }];
        
        self.alertController = alertController;
    }
    
    // 出现
    [self presentViewController:_alertController animated:YES completion:^{
        NSLog(@"presented");
    }];
    
}

- (void)fail{
    [_tips setText:@"加载失败"];
}

- (void)player:(PLPlayer *)player stoppedWithError:(NSError *)error{
    NSLog(@"挂了");
}

- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state{
    if (state == PLPlayerStatusError) {
        NSLog(@"真挂了");
    }
    else if(state == PLPlayerStatusPlaying){
        [_tips setHidden:YES];
    }
}
@end
