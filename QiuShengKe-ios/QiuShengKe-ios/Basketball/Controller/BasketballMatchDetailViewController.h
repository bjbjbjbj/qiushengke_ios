//
//  BasketballMatchDetailViewController.h
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/18.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "QiuMiCommonViewController.h"

@interface BasketballMatchDetailViewController : QiuMiCommonViewController
@property(nonatomic, assign)NSInteger mid;
@property(nonatomic, assign)BOOL hasLive;
@property(nonatomic, assign)BOOL afterInReview;
@property(nonatomic, assign)IBOutlet UIButton* liveBtn;
@end
