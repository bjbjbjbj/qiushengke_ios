//
//  PlayerViewController.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/16.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import <MediaPlayer/MPVolumeView.h>
#import "QiuShengKe-ios-Bridging-Header.h"
#import "AKQDMTableViewCell.h"
#import "AppDelegate.h"
@import SocketIO;
#import "GCDAsyncSocket.h"
#import "PlayerViewController.h"
#import <PLPlayerKit/PLPlayerKit.h>
#import "RSA.h"
#import <CommonCrypto/CommonCryptor.h>
#import "Base64.h"

@interface PlayerViewController ()<PLPlayerDelegate,GCDAsyncSocketDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate>
{
    NSTimeInterval _lastPostTime;
}
//音量调节
@property(nonatomic, assign)BOOL isPaning;
@property(nonatomic, assign)BOOL isVolume;
@property (strong, nonatomic) MPVolumeView *volumeView;//控制音量的view
@property (strong, nonatomic) UISlider* volumeViewSlider;//控制音量

@property(nonatomic, assign) BOOL isFullScreen;
@property(nonatomic, strong) IBOutlet UIView* toolView;
@property(nonatomic, strong) IBOutlet UIButton* rightBtn;
@property(nonatomic, strong) IBOutlet UIView* navView;
@property(nonatomic, strong) IBOutlet UITextField* text;
@property(nonatomic, strong) IBOutlet UIButton* openBtn;
@property(nonatomic, strong) IBOutlet UIView* playView;
@property(nonatomic, strong) IBOutlet UITableView* tableview;

@property(nonatomic, strong) IBOutlet UIView* tipsView;
@property(nonatomic, strong) IBOutlet UIImageView* tipsImage;
@property(nonatomic, strong) IBOutlet UILabel* tipsTime;
@property(nonatomic, strong) IBOutlet UILabel* tipsDetail;

@property(nonatomic, strong) PLPlayer  *player;
@property(nonatomic, strong) NSArray* channels;
@property(nonatomic, strong) UIAlertController* alertController;

@property (nonatomic, strong) OCBarrageManager *barrageManager;

@property (strong, nonatomic) SocketIOClient *bj;
@property (strong, nonatomic) SocketManager *bj2;

@property (strong, nonatomic) NSMutableArray* chats;
@property (strong, nonatomic) NSTimer* timer;
@property (assign, nonatomic) long long matchTime;
@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [(UILabel*)[_navView viewWithTag:99] setText:_navTitle];
    
    [self setupTips];
    self.isPaning = NO;
    self.isVolume = NO;
    [self volumeView];
    
    AppDelegate* appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //允许转成横屏
    appDelegate.allowRotation = YES;
    
    [self.playView setFrame:CGRectMake(0, 64, SCREENWIDTH, 210*(SCREENWIDTH/375))];
    [self.tipsView setFrame:CGRectMake(0, 64, SCREENWIDTH, 210*(SCREENWIDTH/375))];
    
    float bottom = 0;
    if (@available(iOS 11.0, *)) {
        bottom = [[UIApplication sharedApplication] keyWindow].safeAreaInsets.bottom;
    } else {
        // Fallback on earlier versions
    }
    [_tableview setFrame:CGRectMake(0, CGRectGetMaxY(_playView.frame), SCREENWIDTH, SCREENHEIGHT - CGRectGetMaxY(_playView.frame) - bottom - [[_text superview] superview].frame.size.height)];
    [_tipsView setHidden:YES];
    
    [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableview setBackgroundColor:COLOR(242, 242, 242, 1)];
    
    self.chats = [[NSMutableArray alloc]init];
    _isFullScreen = NO;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.playView setBackgroundColor:[UIColor blackColor]];
    self.needToHideNavigationBar = YES;
    // Do any additional setup after loading the view.
    if (_sport == 99) {
        [self _loadAnchorData];
        [_rightBtn removeFromSuperview];
    }
    else{
        [self _loadData];
    }
//    [self _setupPlayer:@"rtmp://live.hkstv.hk.lxdns.com/live/hks"];
//    [self _setupPlayer:@"http://hdl1201.plures.net/onlive/26cb8333d0494d0f80a1667df469b81f.flv?txSecret=87de0f0c3166bb249898ebff62658468&txTime=5b46d375"];
    
    _text.superview.layer.borderWidth = .5;
    _text.superview.layer.cornerRadius = 2;
    _text.superview.layer.borderColor = COLOR(207, 207, 207, 1).CGColor;
    _text.superview.backgroundColor = COLOR(242, 242, 242, 1);
    NSAttributedString* attStr = [[NSAttributedString alloc] initWithString:@"发个言呗，兄dei" attributes:@{
                                                                                                      NSForegroundColorAttributeName:COLOR(158, 158, 158, 1)
                                                                                                      }];
    _text.attributedPlaceholder = attStr;
    [self setupSocket];
    [self setupDM];
    [self setUIRoute];
    [self addNotification];
    
    UILabel* head = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 150)];
    [head setTextColor:QIUMI_COLOR_G2];
    [head setTextAlignment:NSTextAlignmentCenter];
    [head setFont:[UIFont systemFontOfSize:16]];
    [head setText:@"暂时没有新弹幕"];
    [_tableview setTableHeaderView:head];
    [_tableview setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)]];
    
    if ([[NSUserDefaults getObjectFromNSUserDefaultsWithKeyPC:@"user_name"] length] > 0) {
    }
    else{
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"请输入用户名" message:@"用户名无法更改，请谨慎输入" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [alert show];
    }
}

#pragma mark - 有iv
const NSString *key = @"Cheer402";
const NSString *iv = @"20180710";
+(NSString *) encryptUseDES:(NSString *)plainText
{
    NSData* ivData = [iv dataUsingEncoding: NSUTF8StringEncoding];
    Byte *ivBytes = (Byte *)[ivData bytes];
    NSString *ciphertext = nil;
    NSData *textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [textData length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          ivBytes,
                                          [textData bytes], dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [data base64EncodedString];
    }
    return ciphertext;
}

+(NSString *)decryptUseDES:(NSString *)cipherText
{
    NSData* ivData = [iv dataUsingEncoding: NSUTF8StringEncoding];
    Byte *ivBytes = (Byte *)[ivData bytes];
    NSString *plaintext = nil;
    NSData *cipherdata = [cipherText base64DecodedData];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          ivBytes,
                                          [cipherdata bytes], [cipherdata length],
                                          buffer, 1024,
                                          &numBytesDecrypted);
    if(cryptStatus == kCCSuccess) {
        NSData *plaindata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plaintext = [[NSString alloc]initWithData:plaindata encoding:NSUTF8StringEncoding];
    }
    return plaintext;
}

- (void)setupTips{
    NSDictionary* dic = [[NSMutableDictionary alloc] initWithStore:@"config"];
    if (dic && [[dic objectForKey:@"icon"] length] > 0) {
        [_tipsImage qiumi_setImageWithURLString:[dic objectForKey:@"icon"]];
    }
    if (dic && [[dic objectForKey:@"weixin"] length] > 0) {
        NSMutableAttributedString* text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"加微信 %@\n与球迷赛事交流，乐享高清精彩赛事！",[dic objectForKey:@"weixin"]]];
        [text addAttributes:@{
                              NSForegroundColorAttributeName:COLOR(237, 247, 76, 1)
                                  } range:NSMakeRange(4, [[dic objectForKey:@"weixin"] length])];
        [_tipsDetail setAttributedText:text];
    }
    [_tipsTime setHidden:YES];
}

-(void)setupDM{
    self.barrageManager = [[OCBarrageManager alloc] init];
    [self.playView addSubview:self.barrageManager.renderView];
    [self.playView bringSubviewToFront:self.barrageManager.renderView];
    self.barrageManager.renderView.frame = CGRectMake(0.0, 0, self.playView.frame.size.width, self.playView.frame.size.height);
    //    self.barrageManager.renderView.center = self.view.center;
    self.barrageManager.renderView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)setupSocket{
//    NSURL* url = [[NSURL alloc] initWithString:@"http://bj.xijiazhibo.cc"];
        NSURL* url = [[NSURL alloc] initWithString:@"http://localhost:6001"];
//        NSURL* url = [[NSURL alloc] initWithString:@"http://ws.aikq.cc"];
    SocketManager* manager = [[SocketManager alloc] initWithSocketURL:url config:@{@"log": @YES, @"compress": @YES}];
    self.bj2 = manager;
    SocketIOClient* socket = manager.defaultSocket;
    self.bj = socket;
    
    QiuMiWeakSelf(self);
    [socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket connected");
        QiuMiStrongSelf(self);
        
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval time = [dat timeIntervalSince1970];
        NSString* tmp = [@(time) stringValue];
        tmp = [tmp componentsSeparatedByString:@"."][0];
        if ([tmp length] <= 2) {
            return;
        }
        NSString* first = [tmp substringWithRange:NSMakeRange([tmp length] - 1, 1)];
        NSString* second = [tmp substringWithRange:NSMakeRange([tmp length] - 2, 2)];
        NSString* midStr = [NSString stringWithFormat:@"%@_%@",@(self.sport),@(self.mid)];
        NSString* verification =  [PlayerViewController md5:[NSString stringWithFormat:@"%@?%@_%@",midStr,first,second]];
        
        NSDictionary* params = @{
                                 @"mid": midStr,
                                 @"time":tmp,
                                 @"verification":verification
                                 };
        if ([[NSUserDefaults getObjectFromNSUserDefaultsWithKeyPC:@"user_name"] length] > 0) {
            params = @{
                       @"mid": midStr,
                       @"time":tmp,
                       @"verification":verification,
                       @"nickname":[NSUserDefaults getObjectFromNSUserDefaultsWithKeyPC:@"user_name"]
                       };
        }
        [socket emit:@"user_mid" with:@[params]];
    }];
    
    [socket on:@"server_send_message" callback:^(NSArray* data, SocketAckEmitter* ack) {
        QiuMiStrongSelf(self);
        [self addNormalBarrage:[[data objectAtIndex:0] objectForKey:@"message"]];
        [self.chats addObject:[data objectAtIndex:0]];
        if ([self.chats count] > 0) {
            [self.tableview setTableHeaderView:nil];
        }
        [self.tableview reloadData];
    }];
    
    [socket connect];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //禁用侧滑手势方法
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //禁用侧滑手势方法
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [_barrageManager stop];
    self.barrageManager = nil;
    [_bj disconnect];
    self.bj = nil;
    self.player.delegate = nil;
    [_player stop];
    [self.timer invalidate];
    self.timer = nil;
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
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
    //点击导航栏返回按钮的时候调用，所以Push出的控制器最好禁用侧滑手势：
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = NO;//关闭横屏仅允许竖屏
    //切换到竖屏
    [UIDevice switchNewOrientation:UIInterfaceOrientationPortrait];
    [[QiuMiCommonViewController navigationController] popViewControllerAnimated:YES];
}

- (void)_loadAnchorData{
    QiuMiWeakSelf(self);
    [[QiuMiHttpClient instance] GET:[NSString stringWithFormat:QSK_ANCHOR_URL,[@(_mid) stringValue]] parameters:nil cachePolicy:QiuMiHttpClientCachePolicyNoCache success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QiuMiStrongSelf(self);
        if ([responseObject integerForKey:@"code"] == 0) {
            if ([responseObject integerForKey:@"status"] == 1) {
                [self.tipsView setHidden:YES];
                [self _setupPlayer:[PlayerViewController decryptUseDES:[responseObject objectForKey:@"live_url"]]];
                [(UILabel*)[_navView viewWithTag:99] setText:[responseObject objectForKey:@"title"]];
            }
            else{
                [QiuMiPromptView showText:@"主播还没开播"];
                [self.tipsView setHidden:NO];
            }
        }
        else{
            [QiuMiPromptView showText:@"加载直播地址失败"];
            [self.tipsView setHidden:NO];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QiuMiStrongSelf(self);
        [self.tipsView setHidden:NO];
    }];
}

- (void)_loadData{
    QiuMiWeakSelf(self);
    [[QiuMiHttpClient instance] GET:[NSString stringWithFormat:QSK_MATCH_CHANNELS,(_sport == 1?@"1":(_sport == 2 ? @"2":@"3")),[@(_mid) stringValue]] parameters:nil cachePolicy:QiuMiHttpClientCachePolicyNoCache success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QiuMiStrongSelf(self);
        NSArray* channels = [[responseObject objectForKey:@"live"] objectForKey:@"channels"];
        NSMutableArray* result = [[NSMutableArray alloc] init];
        for (NSDictionary* channel in channels) {
            if (![[channel objectForKey:@"link"] containsString:@"leqiuba.cc"]) {
                [result addObject:channel];
            }
        }
        self.channels = result;
        if ([self.channels count] > 0) {
            [self loadChannel:0];
        }
        
        if ([responseObject integerForKey:@"show_live"] > 0 || [[responseObject objectForKey:@"match"] integerForKey:@"status"] > 0) {
            [self.tipsView setHidden:YES];
        }
        else{
            NSString *dateStr = [[responseObject objectForKey:@"match"] objectForKey:@"time"];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date = [dateFormat dateFromString:dateStr];
            NSString* tmp = [@([date timeIntervalSince1970]) stringValue];
            tmp = [tmp componentsSeparatedByString:@"."][0];
            self.matchTime = [tmp longLongValue];
            [self.tipsView setHidden:NO];
            [self setupTimer];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)loadChannel:(NSInteger)index{
    NSDictionary* dic = [_channels objectAtIndex:index];
    NSString* url = @"";
    NSString* content = [dic objectForKey:@"channelId"];
    url = [NSString stringWithFormat:AKQ_CHANNEL_URL,content];
    [[QiuMiHttpClient instance] GET:url parameters:nil cachePolicy:QiuMiHttpClientCachePolicyNoCache success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject integerForKey:@"code"] == 0 && [responseObject existForKey:@"playurl"]) {
            self.urlString = [PlayerViewController decryptUseDES:[responseObject objectForKey:@"playurl"]];
            [self _setupPlayer:self.urlString];
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
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    NSURL* url = [[NSURL alloc] initWithString:urlStr];
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    [option setOptionValue:@5 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
    [option setOptionValue:@(kPLLogInfo) forKey:PLPlayerOptionKeyLogLevel];
    self.player = [PLPlayer playerLiveWithURL:url option:option];
    self.player.delegate = self;
    self.player.playerView.contentMode = UIViewContentModeScaleAspectFit;
    [self.player.playerView setBackgroundColor:[UIColor blackColor]];
    
//    self.player.playerView.translatesAutoresizingMaskIntoConstraints = NO;
//    // 添加 left 约束
//    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.player.playerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.playView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
//    [self.playView addConstraint:leftConstraint];
//    // 添加 top 约束
//    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.player.playerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.playView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
//    [self.playView addConstraint:topConstraint];
//    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.player.playerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.playView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
//    [self.playView addConstraint:rightConstraint];
//    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.player.playerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.playView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
//    [self.playView addConstraint:bottomConstraint];
    
    [self.playView addSubview:self.player.playerView];
    [self.playView sendSubviewToBack:self.player.playerView];
    
    [self.playView setFrame:CGRectMake(0, 64, SCREENWIDTH, 210*(SCREENWIDTH/375))];
    self.player.playerView.frame = CGRectMake(0, 0, SCREENWIDTH, 210*(SCREENWIDTH/375));
    
    [self.player play];
    
//    [self performSelector:@selector(fail) withObject:nil afterDelay:10];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTap:)];
    [_playView addGestureRecognizer:tap];
    
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(controlVolumeAndLigint:)];
    [_playView addGestureRecognizer:pan];
}

- (void)clickTap:(UITapGestureRecognizer*)tap{
    if (_isFullScreen) {
        [_text resignFirstResponder];
        [[[_text superview]superview] setHidden:YES];
        [_toolView setHidden:!_toolView.isHidden];
    }
    else{
        [UIDevice switchNewOrientation:UIInterfaceOrientationLandscapeRight];
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
    [QiuMiPromptView showText:@"加载失败"];
}

- (void)player:(PLPlayer *)player stoppedWithError:(NSError *)error{
    NSLog(@"挂了");
}

- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state{
    if (state == PLPlayerStatusError) {
        NSLog(@"真挂了");
        //重新load一次频道
        if (_sport <= 3) {
            [self _loadData];
        }
        else{
            [self _loadAnchorData];
        }
    }
    else if(state == PLPlayerStatusPlaying){
        
    }
}

- (void)addNormalBarrage:(NSString*)text {
    OCBarrageTextDescriptor *textDescriptor = [[OCBarrageTextDescriptor alloc] init];
    textDescriptor.text = text;
    textDescriptor.textColor = [UIColor whiteColor];
    textDescriptor.positionPriority = OCBarragePositionLow;
    textDescriptor.textFont = [UIFont systemFontOfSize:30.0];
    textDescriptor.strokeColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    textDescriptor.strokeWidth = -1;
    textDescriptor.animationDuration = arc4random()%5 + 5;
    textDescriptor.barrageCellClass = [OCBarrageTextCell class];
    
    [self.barrageManager renderBarrageDescriptor:textDescriptor];
}

- (IBAction)clickToolReply:(id)sender{
    [[[_text superview]superview] setHidden:NO];
    [_text becomeFirstResponder];
}

- (IBAction)clickSmall:(id)sender{
    [UIDevice switchNewOrientation:UIInterfaceOrientationPortrait];
}

//md5
+ (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (int)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

- (IBAction)clickShowDM:(id)sender{
    [_barrageManager.renderView setHidden:!_barrageManager.renderView.isHidden];
    if (_barrageManager.renderView.isHidden) {
        [_openBtn setImage:[UIImage imageNamed:@"player_comment_close"] forState:UIControlStateNormal];
    }
    else{
        [_openBtn setImage:[UIImage imageNamed:@"player_comment_open"] forState:UIControlStateNormal];
    }
}

- (IBAction)clickPost:(id)sender{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time = [dat timeIntervalSince1970];
    //3秒内发一次
    if (time - _lastPostTime <=3) {
        [QiuMiPromptView showText:@"请不要在3秒内连续发消息"];
        return;
    }
    
    if ([[_text text] length] == 0) {
        return;
    }
    
    if ([[_text text] length] > 20) {
        [QiuMiPromptView showText:@"请发不多于20个字的弹幕"];
        return;
    }
    
    [self.text resignFirstResponder];
    if(_isFullScreen){
        [[[_text superview]superview] setHidden:YES];
    }
    
    NSString* tmp = [@(time) stringValue];
    tmp = [tmp componentsSeparatedByString:@"."][0];
    if ([tmp length] <= 2) {
        return;
    }
    NSString* first = [tmp substringWithRange:NSMakeRange([tmp length] - 1, 1)];
    NSString* second = [tmp substringWithRange:NSMakeRange([tmp length] - 2, 2)];
    
    NSString* verification =  [PlayerViewController md5:[NSString stringWithFormat:@"%@?%@_%@",_text.text,first,second]];
    
    NSDictionary* param = @{
                            @"nickname": [NSUserDefaults getObjectFromNSUserDefaultsWithKeyPC:@"user_name"],
                            @"message": _text.text,
                            @"time":tmp,
                            @"verification":verification
                            };
    [_bj emit:@"user_send_message" with:@[param]];
    [_text setText:@""];
    _lastPostTime = time;
    
//    QiuMiWeakSelf(self);
//    [[QiuMiHttpClient instance] POST:@"http://xijiazhibo.cc/bj2" parameters:@{@"msg":_text.text} success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        QiuMiStrongSelf(self);
//        [[self.text superview]setHidden:YES];
//        [self.text resignFirstResponder];
////        [self addNormalBarrage:_text.text];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//
//    }];
}

//旋转
- (void)setUIRoute{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_initScreenOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)p_initScreenOrientationChanged:(id)notification {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
//        [UIDevice switchNewOrientation:(UIInterfaceOrientation)orientation];
        self.playView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        self.player.playerView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        self.isFullScreen = YES;
    }
    else{
//        [UIDevice switchNewOrientation:UIInterfaceOrientationPortrait];
        [self.playView setFrame:CGRectMake(0, 64, SCREENWIDTH, 210*(SCREENWIDTH/375))];
        self.player.playerView.frame = CGRectMake(0, 0, SCREENWIDTH, 210*(SCREENWIDTH/375));
        self.isFullScreen = NO;
    }
    return;
//    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
////    [self fullScreen:orientation];
////    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
////        [self.playView setFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
////    }
////    else{
////
////    }
//    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:orientation] forKey:@"orientation"];
//    CGAffineTransform tranform = [self getRotateTransform:orientation];
//    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
//        [UIView animateWithDuration:0.3f animations:^{
//            CGFloat width = MAX(SCREENWIDTH, SCREENHEIGHT);
//            CGFloat height = MIN(SCREENWIDTH, SCREENHEIGHT);
//            CGRect frame = CGRectMake((height - width)/2.0,(width - height)/2.0, width, height);
//            self.playView.frame = frame;
//            _player.playerView.frame = _playView.bounds;
//            [self.playView setTransform:tranform];
//        }completion:^(BOOL finished) {
//            [_navView setHidden:YES];
//        }];
//        self.isFullScreen = YES;
//        [UIApplication sharedApplication].statusBarOrientation = (UIInterfaceOrientation)orientation;
//        [UIApplication sharedApplication].statusBarHidden = NO;
//    }
//    else{
//        self.isFullScreen = NO;
//        [UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationPortrait;
//        [UIApplication sharedApplication].statusBarHidden = NO;
//        
//        [UIView animateWithDuration:0.3f animations:^{
//            [self.playView setTransform:CGAffineTransformIdentity];
//            [self.playView setFrame:CGRectMake(0, 64, SCREENWIDTH, 210*(SCREENWIDTH/375))];
//            _player.playerView.frame = CGRectMake(0, 0, SCREENWIDTH, 210*(SCREENWIDTH/375));
//        }completion:^(BOOL finished) {
//        
//            [_navView setHidden:NO];
//        }];
//    }
}

- (void)setIsFullScreen:(BOOL)isFullScreen{
    [_text resignFirstResponder];
    _isFullScreen = isFullScreen;
    if (isFullScreen) {
        [_navView setHidden:YES];
        [self.barrageManager start];
        [_tableview setHidden:YES];
        [[[_text superview]superview] setHidden:YES];
        QiuMiViewReframe([[_text superview]superview], CGRectMake(0, 0, SCREENWIDTH, [[_text superview]superview].frame.size.height));
//        [self addNotification];
    }
    else{
        [_toolView setHidden:YES];
        [_navView setHidden:NO];
        [self.barrageManager stop];
        [_tableview setHidden:NO];
        [[[_text superview]superview] setHidden:NO];
//        [self removeNotification];
        float bottom = 0;
        
        if (@available(iOS 11.0, *)) {
            bottom = [[UIApplication sharedApplication] keyWindow].safeAreaInsets.bottom;
        } else {
            // Fallback on earlier versions
        }
        QiuMiViewReframe([[_text superview]superview], CGRectMake(0, SCREENHEIGHT - 44 - bottom, SCREENWIDTH, [[_text superview]superview].frame.size.height));
    }
}

- (CGAffineTransform)getRotateTransform:(UIDeviceOrientation)orientation {
    CGAffineTransform tranform = CGAffineTransformIdentity;
    if (orientation == UIDeviceOrientationLandscapeLeft) {
        tranform = CGAffineTransformMakeRotation(M_PI_2);
    } else if (orientation == UIDeviceOrientationLandscapeRight){
        tranform = CGAffineTransformMakeRotation(-M_PI_2);
    }
    return tranform;
}

#pragma table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_chats count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AKQDMTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AKQDMTableViewCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"AKQDMTableViewCell" owner:nil options:nil][0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    if ([_chats count] > indexPath.row) {
        [cell loadData:[_chats objectAtIndex:[_chats count] - 1 - indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

#pragma mark - alert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == !alertView.cancelButtonIndex) {
        UITextField* text = [alertView textFieldAtIndex:0];
        NSString* name = [NSString removeSpaceAndNewline:[text text]];
        if (name && [name length] > 0) {
            [NSUserDefaults setObjectToNSUserDefaultsPC:name withKey:@"user_name"];
        }
        else{
            
        }
    }
}

#pragma mark - text
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self clickPost:nil];
    return YES;
}

-(void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary *info = [notification userInfo];
    //获取键盘的size值
    CGRect _keyBoard = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float bottom = 0;
    float left = 0;
    float right = 0;
    
    if (@available(iOS 11.0, *)) {
        bottom = [[UIApplication sharedApplication] keyWindow].safeAreaInsets.bottom;
        left = [[UIApplication sharedApplication] keyWindow].safeAreaInsets.left;
        right = [[UIApplication sharedApplication] keyWindow].safeAreaInsets.right;
    } else {
        // Fallback on earlier versions
    }
    QiuMiViewReframe([[_text superview] superview], CGRectMake(0 + left, SCREENHEIGHT - [[_text superview] superview].frame.size.height - _keyBoard.size.height, SCREENWIDTH - left - right, [[_text superview] superview].frame.size.height));
}

-(void)keyboardDidChange:(NSNotification*)notification  {
    
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    float bottom = 0;
    
    if (@available(iOS 11.0, *)) {
        bottom = [[UIApplication sharedApplication] keyWindow].safeAreaInsets.bottom;
    } else {
        // Fallback on earlier versions
    }
    
    QiuMiViewReframe([[_text superview] superview], CGRectMake(0, SCREENHEIGHT - [[_text superview] superview].frame.size.height - bottom, SCREENWIDTH, [[_text superview] superview].frame.size.height));
}

#pragma mark - 倒计时
- (void)setupTimer {
    if (_timer) {
        [self.timer invalidate];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
}

- (void)updateTime {
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time = [dat timeIntervalSince1970];
    NSString* tmp = [@(time) stringValue];
    tmp = [tmp componentsSeparatedByString:@"."][0];
    
    long topCount = _matchTime - [tmp longLongValue];
    if (topCount >= 0) {
        NSString* time = @"";
        NSInteger hour = topCount/3600;
        NSInteger min = (topCount%3600)/60;
        NSInteger second = topCount%60;
        if (hour > 0) {
            time = [time stringByAppendingString:[NSString stringWithFormat:@"%d:",hour]];
        }
        if (min > 0) {
            if (min > 9) {
                time = [time stringByAppendingString:[NSString stringWithFormat:@"%d:",min]];
            }
            else{
                time = [time stringByAppendingString:[NSString stringWithFormat:@"0%d:",min]];
            }
        }
        if (second > 9) {
            time = [time stringByAppendingString:[NSString stringWithFormat:@"%d",second]];
        }
        else{
            time = [time stringByAppendingString:[NSString stringWithFormat:@"0%d",second]];
        }
        NSMutableAttributedString* text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"距离比赛还有%@",time]];
        [text addAttributes:@{
                              NSForegroundColorAttributeName:COLOR(237, 247, 76, 1)
                              } range:NSMakeRange(6, [text length] - 6)];
        [_tipsTime setAttributedText:text];
        [_tipsTime setHidden:NO];
    }
    else{
        [self.timer invalidate];
        [_tipsTime setHidden:YES];
    }
}

#pragma mark - 音量
- (void)controlVolumeAndLigint:(UIPanGestureRecognizer *)gesture {
    // 获取手势位置
    CGPoint locationPoint = [gesture locationInView:self.playView];
    // 获取手势速度
    CGPoint speed = [gesture velocityInView:self.playView];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            CGFloat x = fabs(speed.x);
            CGFloat y = fabs(speed.y);
            if (x < y) {
                self.isPaning = YES;
                // 开始滑动的时候,状态改为正在控制音量
                if (locationPoint.x > self.playView.bounds.size.width / 2) {
                    self.isVolume = YES;
                }else {
                    // 状态改为显示亮度调节
                    self.isVolume = NO;
                }
            }
        }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            if (self.isPaning) {
                [self verticalMoved:speed.y];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
//            [self hiddenHintView];
        }
            break;
        default:
            break;
    }
}

- (void)verticalMoved:(CGFloat)value {
    //该value为手指的滑动速度，一般最快速度值不会超过10000，保证在0-1之间，往下滑为正，往上滑为负 所以用 “-=”
    value = value / 5000;
    if (self.isVolume) {
        [self.volumeViewSlider setValue:(self.volumeViewSlider.value - value) animated:NO];
        
        if (self.volumeViewSlider.value > 1.0f) {
            [self.volumeViewSlider setValue:1 animated:NO];
            [QiuMiPromptView showText:@"音量:100%"];
        }
        else if (self.volumeViewSlider.value < 0.0f) {
            [self.volumeViewSlider setValue:0 animated:NO];
            [QiuMiPromptView showText:@"音量:0%"];
        }
        else{
            [QiuMiPromptView showText:[NSString stringWithFormat:@"音量:%.0f%%",self.volumeViewSlider.value*100]];
        }
        [self.volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [UIScreen mainScreen].brightness -= value;
        if ([UIScreen mainScreen].brightness > 1.0f) {
            [UIScreen mainScreen].brightness = 1.0f;
            [QiuMiPromptView showText:@"亮度:100%"];
        }
        else if ([UIScreen mainScreen].brightness < 0.0f) {
            [UIScreen mainScreen].brightness = 0.0f;
            [QiuMiPromptView showText:@"亮度:0%"];
        }
        else{
            [QiuMiPromptView showText:[NSString stringWithFormat:@"亮度:%.0f%%",[UIScreen mainScreen].brightness*100]];
        }
    }
}

- (MPVolumeView *)volumeView {
    if (_volumeView == nil) {
//        _volumeView = [[MPVolumeView alloc] init];
        _volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(-20, -20, 10, 10)];
        _volumeView.hidden = NO;
        [self.view addSubview:_volumeView];
        for (UIView  *subView in [self.volumeView subviews]) {
            if ([subView.class.description isEqualToString:@"MPVolumeSlider"]) {
                _volumeViewSlider = (UISlider*)subView;
                break;
            }
        }
    }
    return _volumeView;
}
@end
