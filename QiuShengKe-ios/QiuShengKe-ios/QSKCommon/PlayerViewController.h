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
@property(nonatomic, assign)NSInteger sport;
@property(nonatomic, strong)NSString* navTitle;
@end
