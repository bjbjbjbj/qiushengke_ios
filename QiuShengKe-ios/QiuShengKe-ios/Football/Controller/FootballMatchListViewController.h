//
//  FootballMatchListViewController.h
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/10.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "QiuMiCommonViewController.h"

@interface FootballMatchListViewController : QiuMiCommonViewController
@property(nonatomic, strong)NSString* timeStr;
- (void)loadData;
@end
