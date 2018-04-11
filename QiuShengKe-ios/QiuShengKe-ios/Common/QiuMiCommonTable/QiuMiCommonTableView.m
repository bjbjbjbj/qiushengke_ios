//
//  QiuMiCommonTableView.m
//  QiuMiCommonTableView
//
//  Created by Viper on 15/6/25.
//  Copyright (c) 2015年 Viper. All rights reserved.
//

#import "QiuMiCommonTableView.h"
#import "QiuMiRefreshControl.h"

@interface QiuMiCommonTableView()<UITableViewDelegate>

@end

@implementation QiuMiCommonTableView

- (void)dealloc{
    [self.refresh removeFromSuperview];
    self.refresh = nil;
    self.delegate = nil;
    self.commonTableViewDelegate = nil;
}

- (void)awakeFromNib
{
#pragma mark - xib时走此处方法
    [super awakeFromNib];
    [self setupUI:YES];
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setupUI:YES];
    }
    return self;
}

- (void)setupUI:(BOOL)hasRefresh
{
    if (hasRefresh) {
        self.refresh = [[QiuMiRefreshControl alloc]initInScrollView:self];
        [self.refresh addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    }
    self.footerView = [[QiuMiFooterView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    [self setTableFooterView:self.footerView];
    [self setFooterViewState:QiuMiCommentFooterViewStatusHide];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withHasRefresh:(BOOL)hasRefresh{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setupUI:hasRefresh];
    }
    return self;
}

- (void)loadData:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y + scrollView.bounds.size.height + 80 > scrollView.contentSize.height) {
        if (_commonTableViewDelegate && [_commonTableViewDelegate respondsToSelector:@selector(commonLoadMoreData:)]) {
            [_commonTableViewDelegate performSelector:@selector(commonLoadMoreData:) withObject:self];
        }
    }
}

- (void)refreshData{
    if (_commonTableViewDelegate && [_commonTableViewDelegate respondsToSelector:@selector(commonReloadData:)]) {
        [_commonTableViewDelegate performSelector:@selector(commonReloadData:) withObject:self];
    }
}
#pragma mark - 改变footerView状态
- (void)setFooterViewState:(QiuMiCommentFooterViewStatus)state{
    switch (state) {
        case QiuMiCommentFooterViewStatusEnd:
        {
            int footHeight = _footerView.frame.size.height;
            [self.footerView setStatus:QiuMiFooterViewStatusEnd];
            if (footHeight != _footerView.frame.size.height) {
                self.tableFooterView = _footerView;
                [self reloadData];
            }
        }
            break;
        case QiuMiCommentFooterViewStatusHide:
        {
            int footHeight = _footerView.frame.size.height;
            [self.footerView setStatus:QiuMiFooterViewStatusHide];
            if (footHeight != _footerView.frame.size.height) {
                self.tableFooterView = _footerView;
                [self reloadData];
            }
        }
            break;
        case QiuMiCommentFooterViewStatusLoading:
        {
            int footHeight = _footerView.frame.size.height;
            [self.footerView setStatus:QiuMiFooterViewStatusLoading];
            if (footHeight != _footerView.frame.size.height) {
                self.tableFooterView = _footerView;
                [self reloadData];
            }
        }
            break;
        case QiuMiCommentFooterViewStatusNULL:
        {
            int footHeight = _footerView.frame.size.height;
            [self.footerView setStatus:QiuMiFooterViewStatusNULL];
            if (footHeight != _footerView.frame.size.height) {
                self.tableFooterView = _footerView;
                [self reloadData];
            }
        }
            break;
        case QiuMiCommentFooterViewStatusReady:
        {
            int footHeight = _footerView.frame.size.height;
            [self.footerView setStatus:QiuMiFooterViewStatusReady];
            if (footHeight != _footerView.frame.size.height) {
                self.tableFooterView = _footerView;
                [self reloadData];
            }
        }
            break;
        default:
            break;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
