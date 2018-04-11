//
//  QiuMiNavigationController.h
//  Qiumi
//
//  Created by Song Xiaochen on 12/20/14.
//  Copyright (c) 2014 51viper.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QiuMiNavigationController : UINavigationController <UIGestureRecognizerDelegate>
- (void)pushFromBottom:(UIViewController*)viewController;
- (void)popFromTop;
- (void)popFromTopWithBlock:(void(^)(void))block;
@end
