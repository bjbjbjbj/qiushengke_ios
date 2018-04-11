//
//  QiuMiTabBarViewController.h
//  Qiumi
//
//  Created by xieweijie on 14-11-25.
//  Copyright (c) 2014年 51viper.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QiuMiTabBarViewController : UITabBarController<UITabBarControllerDelegate>
- (void)showUnreadWithIndex:(int)index;
- (void)hideUnreadWithIndex:(int)index;
@end
