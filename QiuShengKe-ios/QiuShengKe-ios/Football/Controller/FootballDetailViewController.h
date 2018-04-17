//
//  FootballDetailViewController.h
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/11.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "QiuMiCommonViewController.h"

@interface FootballDetailViewController : QiuMiCommonViewController
@property(nonatomic, assign)NSInteger mid;
@property(nonatomic, assign)BOOL hasLive;
@property(nonatomic, assign)IBOutlet UIButton* liveBtn;
@end
