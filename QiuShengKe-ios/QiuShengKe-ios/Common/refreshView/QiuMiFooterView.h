//
//  QiuMiFooterView.h
//  Qiumi
//
//  Created by Song Xiaochen on 14-11-17.
//  Copyright (c) 2014年 太平洋网络. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    QiuMiFooterViewStatusReady,
    QiuMiFooterViewStatusLoading,
    QiuMiFooterViewStatusEnd,
    QiuMiFooterViewStatusHide,
    QiuMiFooterViewStatusNULL
}QiuMiFooterViewStatus;

@interface QiuMiFooterView : UIView
@property(nonatomic, assign)QiuMiFooterViewStatus status;
- (void)setStatus:(QiuMiFooterViewStatus)status;

- (void)nolineWithHeight:(float)heightForCell tableView:(UITableView *)tableView numbersOfCell:(NSInteger)numbersOfCell;

- (void)hiddenWithHeight:(float)heightForCell tableView:(UITableView *)tableView numbersOfCell:(NSInteger)numbersOfCell;

@end
