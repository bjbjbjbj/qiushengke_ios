//
//  FootDetailOddView.h
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/12.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FootDetailOddView : UIView<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)NSDictionary* match;
@property(nonatomic, strong)NSDictionary* tech;
@property(nonatomic, assign)NSInteger mid;
@property(nonatomic, assign)NSInteger sport;
- (void)loadData;
@end
