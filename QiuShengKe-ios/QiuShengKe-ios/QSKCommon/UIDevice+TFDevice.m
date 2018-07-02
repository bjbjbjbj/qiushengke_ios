//
//  UIDevice+TFDevice.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/6/29.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "UIDevice+TFDevice.h"

@implementation UIDevice (TFDevice)

+ (void)switchNewOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
    
    [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
    
    NSNumber *orientationTarget = [NSNumber numberWithInt:interfaceOrientation];
    
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    
}
@end
