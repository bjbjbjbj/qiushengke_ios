//
//  AppDelegate.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/9.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "AppDelegate.h"
#import <UMCommonLog/UMCommonLogHeaders.h>
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<QiuMiNavigationDelegate,UIAlertViewDelegate,JPUSHRegisterDelegate>
{
    NSDictionary* _userInfo;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [QiuMiCommonViewController startupWithNavigateDelegate:self window:self.window];
//    IQKeyboardManager.sharedManager.enable = YES;
    [self _loadData];
    //友盟启动（子线程）
//    [UMConfigure setLogEnabled:YES];
    [UMConfigure initWithAppkey:@"5b3b5c838f4a9d1105000250" channel:@"App Store"];
//    [UMCommonLogManager setUpUMCommonLogManager];
    
    //极光
    [self _setupJpush:launchOptions];
    [JPUSHService setBadge:0];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UINavigationController *)navigationController
{
    return (UINavigationController*)[(UITabBarController*)[self.window rootViewController] selectedViewController];
}

- (UIWindow *)window
{
    return _window;
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window
{
    if (self.allowRotation == YES) {
        //横屏
        return UIInterfaceOrientationMaskLandscape | UIInterfaceOrientationMaskPortrait;
    }else{
        //竖屏
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (void)_loadData{
    [[QiuMiHttpClient instance] GET:APP_CONFIG_URL cachePolicy:QiuMiHttpClientCachePolicyNoCache success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject integerForKey:@"code"] == 0) {
            NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithDictionary:[responseObject objectForKey:@"data"]];
            [dic writeToStore:@"config"];
            if ([dic objectForKey:@"ios_version"] && ![[NSUserDefaults getObjectFromNSUserDefaultsWithKeyPC:@"update"] isEqualToString:@"1"]) {
                NSString* ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                NSString* lastVer = [dic objectForKey:@"ios_version"];
                if ([ver compare:lastVer] == NSOrderedAscending) {
                    NSString* message = @"检测到新版本";
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新",@"暂不更新",nil];
                    [alert setTag:[@"update" hash]];
                    [alert show];
                }
            }
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        if ([alertView tag] == [@"update" hash]) {
            if (buttonIndex == 1) {
                NSDictionary* config = [[NSMutableDictionary alloc] initWithStore:@"config"];
                if ([[config objectForKey:@"update_url"] length]) {
                    [QiuMiCommonViewController navTo:[config objectForKey:@"update_url"]];
                }
            }
            else{
                [NSUserDefaults setObjectToNSUserDefaultsPC:@"1" withKey:@"update"];
            }
        }else{
            if ([_userInfo objectForKey:@"action"]) {
                [self navTo];
            }
        }
    }
}

- (void)_setupJpush:(NSDictionary*)launchOptions{
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:@"a926b9c28d398f7e7b456716"
                          channel:@"App Store"
                 apsForProduction:1
            advertisingIdentifier:nil];
}

#pragma mark - 推送
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        _userInfo = userInfo;
        id alertData = [[userInfo valueForKey:@"aps"] objectForKey:@"alert"];
        NSString* content = @"";
        if ([alertData isKindOfClass:[NSDictionary class]]) {
            content = [alertData objectForKey:@"title"]?:[alertData objectForKey:@"body"];
        }
        else{
            alertData = alertData;
        }
        if ([content isKindOfClass:[NSString class]]) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"推送通知" message:content delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"点击查看", nil];
            [alert show];
        }
        
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    if (_userInfo) {
        [self navTo];
    }
    else{
        UIApplicationState state = [application applicationState];
        if (state == UIApplicationStateActive) {
            //应用在前台，接收远程推送，会进入这个状态
            _userInfo = userInfo;
            id alertData = [[userInfo valueForKey:@"aps"] objectForKey:@"alert"];
            NSString* content = @"";
            if ([alertData isKindOfClass:[NSDictionary class]]) {
                content = [[alertData objectForKey:@"title"] length] > 0 ? [alertData objectForKey:@"title"] :[alertData objectForKey:@"body"];
            }
            else{
                alertData = alertData;
            }
            if ([content isKindOfClass:[NSString class]]) {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"推送通知" message:content delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"点击查看", nil];
                [alert show];
            }
        }
        else if (state == UIApplicationStateInactive) {
            //应用在后台，通过点击远程推送通知，进入这个状态
            _userInfo = userInfo;
            [self navTo];
        }
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    _userInfo = userInfo;
    if ([_userInfo objectForKey:@"action"]) {
        [self navTo];
    }
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)navTo{
    [QiuMiCommonViewController navTo:[_userInfo objectForKey:@"action"]];
    _userInfo = nil;
}
@end
