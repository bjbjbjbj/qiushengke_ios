//
//  QiuMiTabBarViewController.m
//  Qiumi
//
//  Created by xieweijie on 14-11-25.
//  Copyright (c) 2014年 51viper.com. All rights reserved.
//

#import "QiuMiTabBarViewController.h"

@interface QiuMiTabBarViewController ()
@property(nonatomic,strong)UIView* point;
@property(nonatomic,strong)UIView* point2;
//@property(nonatomic,strong)UIView* point3;

@end

@implementation QiuMiTabBarViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self setDelegate:self];
    
    //    [self.tabBar setTranslucent:YES];
    //    [self.tabBarController.tabBar setClipsToBounds:YES];
    [[UITabBar appearance]  setBackgroundImage:[QiuMiCommon imageWithColor:[UIColor whiteColor]]];
    [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"line"]];
    
    //初始化controller
    NSMutableArray* controllers = [[NSMutableArray alloc]init];
    
    UIStoryboard* recommend = [ UIStoryboard storyboardWithName:@"Football" bundle:nil];
    UIStoryboard* matchList = [ UIStoryboard storyboardWithName:@"Global" bundle:nil];
    [controllers addObject:[recommend instantiateInitialViewController]];
    [controllers addObject:[matchList instantiateInitialViewController]];
    
    [self setViewControllers:controllers];
    
    //初始化item
    NSArray* title = @[@"足球",@"世界杯"];
    NSArray* images = @[
                        @[
                            @"commond_icon_soccer_n",
                            @"commond_icon_soccer_s",
                            ],
                        @[
                            @"commond_icon_live_n",
                            @"commond_icon_live_s",
                            ],
                        ];
    
    //初始化item
    for (int i = 0 ; i < [title count] ; i++) {
        NSArray* tmp = [images objectAtIndex:i];
        UIImage *musicImage = [UIImage qiumiImageWithName:[tmp objectAtIndex:0]];
        UIImage *musicImageSel = [UIImage qiumiImageWithName:[tmp objectAtIndex:1]];
        musicImage = [musicImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        musicImageSel = [musicImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIViewController* ct = [self.viewControllers objectAtIndex:i];
        UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:[title objectAtIndex:i] image:musicImage selectedImage:musicImageSel];
        [ct setTabBarItem:item];
        [ct.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, 0)];
    }
    [UITabBarItem.appearance setTitleTextAttributes:@{
                                                      NSFontAttributeName : [UIFont systemFontOfSize:11],
                                                      NSForegroundColorAttributeName : QIUMI_COLOR_G2 } forState:UIControlStateNormal];
    [UITabBarItem.appearance setTitleTextAttributes:@{
                                                      NSFontAttributeName : [UIFont systemFontOfSize:11],
                                                      NSForegroundColorAttributeName : QIUMI_COLOR_C1 }     forState:UIControlStateSelected];
    
    [MobClick logPageView:@"启动图" seconds:1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)reloadPoint
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    [MobClick event:@"enter_recommend" label:@"tab"];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    //    if ([[(UINavigationController*)self.selectedViewController topViewController] isKindOfClass:[QiuMiPhotosViewController class]]) {
    //        return UIInterfaceOrientationMaskAll;
    //    }
    //    if ([[(UINavigationController*)self.selectedViewController topViewController] isKindOfClass:[QiuMiCommonWebViewController class]]) {
    //        return UIInterfaceOrientationMaskAll;
    //    }
    //    NSArray * winArr = [self.view.window subviews];
    //    for (int i = 0; i < [winArr count]; i++) {
    //        if ([[winArr objectAtIndex:i] isKindOfClass:[QiuMiPhotoPopView class]]) {
    //            [[NSNotificationCenter defaultCenter] postNotificationName:QIUMI_CHANGEIMAGEVIEW_SUCCESS object:nil];
    //            return UIInterfaceOrientationMaskAll;
    //        }
    //    }
    return UIInterfaceOrientationMaskPortrait;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    [[self.tabBarController.tabBar viewWithTag:[@"tabShadow" hash]] removeFromSuperview];
    
    return YES;
}

#pragma mark - 红点
- (void)showUnreadWithIndex:(int)index
{
    if (![self.tabBarController.tabBar viewWithTag:[[NSString stringWithFormat:@"unread_%d",index] hash]]) {
        UIView* point = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 4, 4)];
        point.layer.cornerRadius = 2;
        [point setClipsToBounds:YES];
        [point setBackgroundColor:[UIColor redColor]];
        [point setTag:[[NSString stringWithFormat:@"unread_%d",index] hash]];
        
        int itemWidth = SCREENWIDTH/[self.viewControllers count];
        [point setFrame:CGRectMake(itemWidth/2 + itemWidth*index + 5, 10, 4, 4)];
        
        [self.tabBar addSubview:point];
    }
}

- (void)hideUnreadWithIndex:(int)index
{
    if (![self.tabBarController.tabBar viewWithTag:[[NSString stringWithFormat:@"unread_%d",index] hash]])
    {
        [[self.tabBarController.tabBar viewWithTag:[[NSString stringWithFormat:@"unread_%d",index] hash]] removeFromSuperview];
    }
}
@end
