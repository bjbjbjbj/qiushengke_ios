//
//  QiuMiCommonViewController.m
//  Qiumi
//
//  Created by xieweijie on 14-11-8.
//  Copyright (c) 2014年 51viper.com. All rights reserved.
//

#import "QiuMiCommonViewController.h"
#import "QiuMiActivityWebViewController.h"
#import "QiuMiNavigationController.h"
#import "QiuMiCommonWKWebViewController.h"

@interface QiuMiCommonViewController ()

@property (strong, nonatomic) UIView* noDataView;
@property (strong, nonatomic) UILabel* navTitle;

@end
static id<QiuMiNavigationDelegate> _navigationDelegate;
static UIWindow *_window;

@implementation QiuMiCommonViewController
- (id)initCommon
{
    self = [super initWithNibName:NSStringFromClass(self.class) bundle:nil];
    return self;
}

- (void)dealloc{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"this is %@",[self.class description]);
    self.needToHideNavigationBar = NO;
    self.notPagePath = NO;
    _hud = NULL;
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_notPagePath) {
        [MobClick beginLogPageView:[self.class description]];
        NSLog(@"page is %@",[self.class description]);
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //开启滑动手势
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:_needToHideNavigationBar animated:YES];
    [super viewWillDisappear:animated];
    //刷新通知
    [[NSNotificationCenter defaultCenter] postNotificationName:QIUMI_REFRESH_COMMEBACK object:nil];
    //退出时hiden提示框
    [QiuMiCommonPromptView hide];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    if (!_notPagePath) {
        [MobClick endLogPageView:[self.class description]];
        NSLog(@"page is %@",[self.class description]);
    }
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
//    //(左滑返回)代理置空，否则会闪退
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)] ) {
//        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:_needToHideNavigationBar animated:YES];
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAfterAPPBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [self reloadAfterAPPBecomeActive];
}

- (void)reloadAfterAPPBecomeActive
{
    //是否需要后台回来刷新
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) hidesBottomBarWhenPushed
{
    return !(self.navigationController.topViewController == self);
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)useDefaultBackWithTitle:(NSString *)title
{
    [self useDefaultBack];
    [self setTitle:title];
}

- (void)useDefaultBack
{
    UIButton* userCenterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [userCenterBtn setFrame:CGRectMake(0, 0, 44, 44)];
    [userCenterBtn setExclusiveTouch:YES];
    [userCenterBtn setImageEdgeInsets:UIEdgeInsetsMake(0, - 28, 0, 0)];
    [userCenterBtn setImage:[UIImage imageNamed:@"live_icon_back_white"] forState:UIControlStateNormal];
    [userCenterBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithCustomView:userCenterBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self _setupNavTitleView];
    if ([self.navigationItem.title length] > 0) {
        [self.navTitle setText:self.navigationItem.title];
    }
}

- (void)_setupNavTitleView
{
    if (nil == self.navigationItem.titleView) {
        //发光背景
        UIView* navBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 190, 44)];
        UILabel* navTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 190, 44)];
        [navTitle setFont:[UIFont fontWithName:LG_FONT size:18]];
        [navTitle setTextColor:QIUMI_COLOR_G7];
        [navTitle setTextAlignment:NSTextAlignmentCenter];
        [navBG addSubview:navTitle];
        self.navTitle = navTitle;
        [self.navigationItem setTitleView:navBG];
    }
}

- (void)setTitle:(NSString *)title
{
    [self _setupNavTitleView];
    [self.navTitle setText:title];
}

- (void)useDefaultRightIcon:(NSString*)icon
{
    UIButton* refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [refreshBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -18)];
    [refreshBtn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(clickBarRight:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithCustomView:refreshBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)useDefaultRight:(NSString *)title
{
    UIButton* confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (IOS_VERSION >= 10) {
        [confirmBtn setFrame:CGRectMake(0, 0, 45, 40)];
    }
    else
    {
        [confirmBtn setFrame:CGRectMake(0, 0, 40, 40)];
    }
    [confirmBtn setTitleColor:QIUMI_COLOR_G7 forState:UIControlStateNormal];
    [confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    [confirmBtn setTitle:title forState:UIControlStateNormal];
    [confirmBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    [confirmBtn addTarget:self action:@selector(clickBarRight:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:confirmBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)clickBarRight:(UIButton*)btn
{
    
}

- (void)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)gotoUserCenter:(UIButton*)btn
{
    [self performSegueWithIdentifier:@"QiuMiUserCenterViewController" sender:btn];
}

- (void)hideNoDataView
{
    [_noDataView removeFromSuperview];
}

- (void)showGuide:(NSString*)imagekey withClass:(NSString *)controllerName
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    if ([[UIScreen mainScreen] bounds].size.height == 736)
    {
        NSMutableString *fourInchKey = [NSMutableString stringWithString:imagekey];
        [fourInchKey insertString:@"46p" atIndex:imagekey.length - 4];
        imagekey = fourInchKey;
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667)
    {
        NSMutableString *fourInchKey = [NSMutableString stringWithString:imagekey];
        [fourInchKey insertString:@"46" atIndex:imagekey.length - 4];
        imagekey = fourInchKey;
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) {
        NSMutableString *fourInchKey = [NSMutableString stringWithString:imagekey];
        [fourInchKey insertString:@"_4inch" atIndex:imagekey.length - 4];
        imagekey = fourInchKey;
    }
    
    if (nil == [userDefault objectForKey:controllerName]) {
        UIButton *guideView = [UIButton buttonWithType:UIButtonTypeCustom];
        guideView.frame    =   [[UIScreen mainScreen] bounds];
        [guideView addTarget:self action:@selector(removeGuideView:) forControlEvents:UIControlEventTouchUpInside];
        [guideView setImage:[UIImage imageNamed:imagekey] forState:UIControlStateNormal];
        guideView.tag = [NSStringFromClass(self.class) hash];
        [[[UIApplication sharedApplication] keyWindow] addSubview:guideView];
        
        
        [userDefault setObject:[NSNumber numberWithBool:YES] forKey:controllerName];
        [userDefault synchronize];
    }
}

- (void)removeGuideView:(UIButton *)guideView
{
    [UIView animateWithDuration:0.5 animations:^(){
        [guideView removeFromSuperview];
    }];
}

+ (void)startupWithNavigateDelegate:(id<QiuMiNavigationDelegate>)navigationDelegate window:(UIWindow *)window
{
    _navigationDelegate = navigationDelegate;
    _window = window;
}

+ (QiuMiCommonViewController*)controllerWithStoryBoardName:(NSString *)storyBoardName withControllerName:(NSString *)controllerName
{
    if (storyBoardName == nil && controllerName == nil) {
        NSLog(@"storyboard name or controller name can not nil");
        return nil;
    }
    @try {
        UIStoryboard* sb = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
        QiuMiCommonViewController* controllercontroller = [sb instantiateViewControllerWithIdentifier:controllerName];
        return controllercontroller;
    }
    @catch (NSException *exception) {
        NSLog(@"no find storyboard or controller");
        return nil;
    }
    return nil;
}

+ (void)pushControllerWithStoryBoardName:(NSString *)storyBoardName withControllerName:(NSString *)controllerName withMustLogin:(BOOL)mustLogin withAnimated:(BOOL)animated
{
//    if (mustLogin && ![QiuMiPassport isLogin]) {
//        [QiuMiCommonViewController pushLogin];
//    }
//    else
//    {
        QiuMiCommonViewController* controller = [QiuMiCommonViewController controllerWithStoryBoardName:storyBoardName withControllerName:controllerName];
        if (controller == nil) {
            return;
        }
        [[QiuMiCommonViewController navigationController]pushViewController:controller animated:animated];
//    }
}

+ (void)pushLogin
{
    if ([[QiuMiCommon instance] isInReview]) {
        QiuMiCommonViewController* controller = [QiuMiCommonViewController controllerWithStoryBoardName:@"Tmp" withControllerName:@"LGLoginViewController"];
        [[QiuMiCommonViewController navigationController] pushViewController:controller animated:YES];
        return;
    }
    QiuMiCommonViewController* controller = [QiuMiCommonViewController controllerWithStoryBoardName:@"My" withControllerName:@"LGLoginViewController"];
    [[QiuMiCommonViewController navigationController] pushViewController:controller animated:YES];
}

+ (UINavigationController *)navigationController
{
    return [_navigationDelegate navigationController];
}

+ (UIWindow *)window
{
    return [_navigationDelegate window];
}

+ (BOOL)checkNav:(NSString *)url{
    if (url == nil || [url length] == 0 || [url rangeOfString:@"m.liaogou168.com/appopen"].location != NSNotFound) {
        return NO;
    }
    
    if([url rangeOfString:@"#tool"].location != NSNotFound) {
        return YES;
    }
    
    /*
     #define LG_ARTICLE_URL(id) ([NSString stringWithFormat:@"%@/article/detail/%@",LG_URL_PREFIX,id])
     #define LG_PACKAGE_URL(id) ([NSString stringWithFormat:@"%@/package/detail/%@",LG_URL_PREFIX,id])
     #define LG_MERCHANT_URL(id) ([NSString stringWithFormat:@"%@/merchant/detail/%@",LG_URL_PREFIX,id])
     */
    //协议
    if ([url hasPrefix:@"liaogou://"]) {
       return YES;
    }
    if ([url hasPrefix:@"#browser"]) {
        return YES;
    }
    return NO;
}

+ (void)navTo:(NSString *)url
{
    if (url == nil || [url length] == 0 || [url rangeOfString:@"liaogou168.com/appopen"].location != NSNotFound) {
        return;
    }
    
    if ([url rangeOfString:@"#browser"].location != NSNotFound) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        return;
    }
    
    if(0){
        
    }
    else{
        UIViewController* top = [[QiuMiCommonWKWebViewController navigationController] topViewController];
        if ([top isKindOfClass:[QiuMiCommonWKWebViewController class]]) {
            return;
        }
        
        QiuMiCommonWKWebViewController* web = (QiuMiCommonWKWebViewController*)[QiuMiCommonViewController controllerWithStoryBoardName:@"Football" withControllerName:@"QiuMiCommonWKWebViewController"];
        [web setUrl:url];
        //            [web setShareUrl:shareUrl];
        [[QiuMiCommonViewController navigationController]pushViewController:web animated:YES];
    }
}

+ (NSString*)urlLastId:(NSString*)url{
    NSString* last = [url lastPathComponent];
    last = [last componentsSeparatedByString:@"?"][0];
    last = [last componentsSeparatedByString:@"#"][0];
    return last;
}

+ (UIView *)getNotNetWorkWithFrame:(CGRect)frame
{
    UIView* v = [[UIView alloc]initWithFrame:frame];
    [v setBackgroundColor:[UIColor whiteColor]];
    
    //icon
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setCenter:CGPointMake(frame.size.width/2, frame.size.height/2)];
    [btn setImage:[UIImage imageNamed:@"nowifi"]forState:UIControlStateNormal];
    [btn setTag:[@"refreshBtn" hash]];
    [v addSubview:btn];
    [v setTag:[@"qiumi_no_network_view" hash]];
    
    return v;
}

//屏幕返回手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count <= 1){
        return NO;
    }
    return YES;
}

#pragma mark - NoDataView
- (void)addNoDataViewIn:(UIView *)view andText:(NSString *)text{
    CGRect frame = view.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    QiuMiNoDataView * noDataView = [QiuMiNoDataView createWithXib];
    [noDataView setFrame:frame];
    [noDataView.firstLable setText:text];
    [view addSubview:noDataView];
}

- (UIScreenEdgePanGestureRecognizer *)screenEdgePanGestureRecognizer
{
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
    if (self.navigationController.view.gestureRecognizers.count > 0) {
        for (UIGestureRecognizer *recognizer in self.navigationController.view.gestureRecognizers) {
            if ([recognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
                screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)recognizer;
                break;
            }
        }
    }
    
    return screenEdgePanGestureRecognizer;
}

- (QiuMiCommonPromptView *)hud{
    
    
    if (!_hud) {
        _hud = [[QiuMiCommonPromptView alloc] init];
        //防止获取hud时view没有加载的崩溃
        [self.view layoutIfNeeded];
        
        _hud.contentView = self.view;
    }
    return _hud;
}

CATransform3D CATransform3DMakePerspective(CGPoint center, float disZ, float scale2)
{
    CATransform3D transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0);
    CATransform3D transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
    CATransform3D scale = CATransform3DScale(CATransform3DIdentity, scale2, scale2, scale2);
    scale.m34 = -1.f/SCREENHEIGHT;//-1.0f/disZ;
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
}

CATransform3D CATransform3DPerspect(CATransform3D t, CGPoint center, float disZ, float scale)
{
    return CATransform3DConcat(t, CATransform3DMakePerspective(center, disZ, scale));
}
@end
