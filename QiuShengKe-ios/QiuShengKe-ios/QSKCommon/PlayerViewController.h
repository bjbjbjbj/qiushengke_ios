//
//  PlayerViewController.h
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/16.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "QiuMiCommonViewController.h"

@interface PlayerViewController : QiuMiCommonViewController
@property(nonatomic, strong)NSString* urlString;
@property(nonatomic, assign)NSInteger mid;
@property(nonatomic, assign)NSInteger sport;//1足球 2篮球 3其他 99主播
@property(nonatomic, strong)NSString* navTitle;
@end
