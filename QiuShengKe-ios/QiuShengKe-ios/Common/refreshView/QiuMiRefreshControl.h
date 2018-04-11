//
//  QiuMiRefreshControl.h
//  Qiumi
//
//  Created by Song Xiaochen on 11/20/14.
//  Copyright (c) 2014 51viper.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#define QIUMI_REFRESH_COMMEBACK @"qiumi_qiumi_refresh_comeback"
@interface QiuMiRefreshControl : UIControl

@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;
/*
 是否不滑动回顶部 YES为不滑动 NO为滑动 默认为NO 
 */
@property (nonatomic, assign)   BOOL   noScrolling;

- (instancetype)initInScrollView:(UIScrollView *)scrollView;
//很特殊，其他界面都是卡片，顶部自带8，有的没有，这个需要特殊处理
- (instancetype)initInScrollView:(UIScrollView *)scrollView withNoSep:(BOOL)noSep;
//左右平移
- (instancetype)initInScrollView:(UIScrollView *)scrollView iconOffSetX:(int)x;

// Tells the control that a refresh operation was started programmatically
- (void)beginRefreshing;

// Tells the control the refresh operation has ended
- (void)endRefreshing;

@end
