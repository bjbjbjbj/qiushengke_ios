//
//  CommonKit.h
//  Qiumi
//
//  Created by xieweijie on 16/8/22.
//  Copyright © 2016年 51viper.com. All rights reserved.
//

#ifndef CommonKit_h
#define CommonKit_h
#import <UIKit/UIKit.h>
#import "NSDictionary+CommonKit.h"
#import "QiuMiLine.h"
#import "NSMutableDictionary+PCMutableDictionary.h"
#import "NSMutableArray+PCMutableArray.h"
#import "NSUserDefaults+PCUserDefaults.h"
#import "NSDate+PCDate.h"
#import "NSString+Qiumi.h"
#pragma mark - 文件夹路径
//沙盒document路径
#define DOCUMENT_DIRECTORY ([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0])
//沙盒document路径里面的pc_file_storage
#define FILE_STORAGE_DIRECTORY ([DOCUMENT_DIRECTORY stringByAppendingPathComponent:@"pc_file_storage"])

#pragma mark - 方便自己用的宏
#define IOS_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])

//iphonex
#define  IS_IPHONEX (SCREENWIDTH == 375.f && [UIScreen mainScreen].bounds.size.height == 812.f ? YES : NO)

//屏幕尺寸
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define STATUSHEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
//window
#define WINDOWWIDTH [[[UIApplication sharedApplication].windows objectAtIndex:0] frame].size.width
#define WINDOWHEIGHT [[[UIApplication sharedApplication].windows objectAtIndex:0] frame].size.height
#define WINDOW [[UIApplication sharedApplication].windows objectAtIndex:0]

//颜色
#define COLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//  view快速set size
#define QiuMiViewResize(view, newSize) (view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, ceil(newSize.width), ceil(newSize.height)))
//  view快速set frame
#define QiuMiViewReframe(view, newFrame) (view.frame = CGRectMake(newFrame.origin.x, newFrame.origin.y, ceil(newFrame.size.width), ceil(newFrame.size.height)))
//  view快速设定位置
#define QiuMiViewSetOrigin(view, point) { \
CGRect frame = view.frame; \
frame.origin.x = point.x; \
frame.origin.y = point.y; \
view.frame = frame; \
}
//view快速创建自己的hud
#define QiuMiLoading(view) { \
self.hud = [[QiuMiCommonPromptView alloc] init]; \
self.hud.contentView = view; \
[self.hud showloading]; \
}

//快速16进制颜色
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

//引用宏
#define QiuMiWeakSelf(type)  __weak typeof(type) weak##type = type;
#define QiuMiStrongSelf(type)  __strong typeof(type) type = weak##type;

//设置边框
#define QiuMiViewBorder(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

#endif /* CommonKit_h */
