//
//  QiuMiCommonTableView.h
//  QiuMiCommonTableView
//
//  Created by Viper on 15/6/25.
//  Copyright (c) 2015年 Viper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QiuMiRefreshControl.h"
#import "QiuMiFooterView.h"
#import "QiuMiCommonTableHeadView.h"

typedef enum {
    QiuMiCommentFooterViewStatusReady,
    QiuMiCommentFooterViewStatusLoading,
    QiuMiCommentFooterViewStatusEnd,
    QiuMiCommentFooterViewStatusHide,
    QiuMiCommentFooterViewStatusNULL
}QiuMiCommentFooterViewStatus;

@class QiuMiCommonTableView;
@protocol QiuMiCommonTableViewDelegate<NSObject, UITableViewDelegate>
//加载更多
- (void)commonLoadMoreData:(QiuMiCommonTableView*)tableview;
//刷新数据
- (void)commonReloadData:(QiuMiCommonTableView*)tableview;
@end

@interface QiuMiCommonTableView : UITableView
@property (strong , nonatomic) QiuMiRefreshControl * refresh;
@property (strong , nonatomic) QiuMiFooterView * footerView;
@property(nonatomic, weak)id<QiuMiCommonTableViewDelegate> commonTableViewDelegate;
//新增方法,没有刷新头
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withHasRefresh:(BOOL)hasRefresh;
//设置footerview style
- (void)setFooterViewState:(QiuMiCommentFooterViewStatus)state;
//翻页
- (void)loadData:(UIScrollView *)scrollView;
@end
