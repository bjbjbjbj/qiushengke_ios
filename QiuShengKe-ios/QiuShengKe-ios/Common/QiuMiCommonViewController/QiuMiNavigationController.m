//
//  UINavigationController+QiuMi.m
//  Qiumi
//
//  Created by Song Xiaochen on 12/20/14.
//  Copyright (c) 2014 51viper.com. All rights reserved.
//

#import "QiuMiNavigationController.h"
@interface QiuMiNavigationController()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>
@end
@implementation QiuMiNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:QIUMI_COLOR_G7];
    [self.navigationBar setBarTintColor:QIUMI_COLOR_C1];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: QIUMI_COLOR_G1}];
//    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init]
//                                      forBarPosition:UIBarPositionAny
//                                          barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[QiuMiCommon imageWithColor:QIUMI_COLOR_C1]];
    
    __weak QiuMiNavigationController *weakSelf = self;
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        
        self.delegate = weakSelf;
    }
}

- (void)pushFromBottom:(UIViewController *)viewController
{
    CATransition* transition = [CATransition animation];
    transition.duration = [CATransaction animationDuration];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [self.view.layer addAnimation:transition
                           forKey:kCATransition];
    [self pushViewController:viewController animated:NO];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (void)popFromTop
{
    [self popFromTopWithBlock:nil];
}

- (void)popFromTopWithBlock:(void (^)(void))block
{
    __block typeof(block) wblock = block;
    CATransition* transition = [CATransition animation];
    transition.duration = [CATransaction animationDuration];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [self.view.layer addAnimation:transition
                           forKey:kCATransition];
    [self popViewControllerAnimated:NO];
    if (wblock) {
        wblock();
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated == YES )
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [super pushViewController:viewController animated:animated];
    
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated == YES )
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    return  [super popToRootViewControllerAnimated:animated];
    
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] )
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    return [super popToViewController:viewController animated:animated];
    
}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}


-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    
    if ( gestureRecognizer == self.interactivePopGestureRecognizer )
    {
        if ( self.viewControllers.count < 2 || self.visibleViewController == [self.viewControllers objectAtIndex:0] )
        {
            return NO;
        }
    }
    
    return YES;
}
@end
