//
//  QiuMiCommonViewController.h
//  Qiumi
//
//  Created by xieweijie on 14-11-8.
//  Copyright (c) 2014年 51viper.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QiuMiCommonPromptView.h"
@protocol QiuMiNavigationDelegate
- (UINavigationController *)navigationController;
- (UIWindow *)window;
@end
@interface QiuMiCommonViewController : UIViewController
@property (nonatomic) BOOL needToHideNavigationBar;
//不需要统计页面
@property (nonatomic) BOOL notPagePath;
@property (nonatomic, strong)QiuMiCommonPromptView *hud;

+ (void)startupWithNavigateDelegate:(id <QiuMiNavigationDelegate>)navigationDelegate window:(UIWindow *)window;
+ (QiuMiCommonViewController*)controllerWithStoryBoardName:(NSString*)storyBoardName withControllerName:(NSString*)controllerName;
+ (void)pushControllerWithStoryBoardName:(NSString *)storyBoardName withControllerName:(NSString *)controllerName withMustLogin:(BOOL)mustLogin withAnimated:(BOOL)animated;
+ (void)pushLogin;
+ (UINavigationController*)navigationController;
+ (UIWindow*)window;

+ (void)navTo:(NSString*)url;
+ (BOOL)checkNav:(NSString*)url;


- (id)initCommon;
- (void)goBack:(id)sender;
- (void)useDefaultBack;
- (void)useDefaultBackWithTitle:(NSString*)title;
- (void)useDefaultRight:(NSString*)title;
- (void)useDefaultRightIcon:(NSString*)icon;
- (void)hideNoDataView;
- (void)showGuide:(NSString*)imagekey withClass:(NSString*)controllerName;
- (void)addNoDataViewIn:(UIView *)view andText:(NSString *)text __attribute__ ((deprecated));
- (void)clickBarRight:(UIButton*)btn;
/*
 * @brief 屏幕外滑动手势
 */
- (UIScreenEdgePanGestureRecognizer *)screenEdgePanGestureRecognizer;
+ (UIView*)getNotNetWorkWithFrame:(CGRect)frame;
//动画
CATransform3D CATransform3DMakePerspective(CGPoint center, float disZ, float scale2);
CATransform3D CATransform3DPerspect(CATransform3D t, CGPoint center, float disZ, float scale);
@end
