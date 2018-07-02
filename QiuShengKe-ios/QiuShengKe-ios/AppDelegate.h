//
//  AppDelegate.h
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/9.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDevice+TFDevice.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
/**
 * 是否允许转向
 */
@property(nonatomic,assign)BOOL allowRotation;

@property (strong, nonatomic) UIWindow *window;


@end

