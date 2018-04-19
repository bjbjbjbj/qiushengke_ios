//
//  BasketballMatchListViewController.h
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/18.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "QiuMiCommonViewController.h"

@interface BasketballMatchListViewController : QiuMiCommonViewController
@property(nonatomic, strong)NSString* timeStr;
- (void)loadData;
@end
