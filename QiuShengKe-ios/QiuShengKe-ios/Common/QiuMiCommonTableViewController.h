//
//  QiuMiCommonTableViewController.h
//  Qiumi
//
//  Created by xieweijie on 16/3/28.
//  Copyright © 2016年 51viper.com. All rights reserved.
//

#import "QiuMiCommonViewController.h"
#import "QiuMiCommonPromptView.h"
@interface QiuMiCommonTableViewController : QiuMiCommonViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property(nonatomic, strong)IBOutlet QiuMiCommonTableView* tableview;
@property(nonatomic , assign)BOOL isGroup;
//自定义nav，需要下移44
@property(nonatomic , assign)BOOL hasDIYNav;
- (void)loadDataWithFresh:(BOOL)isRefresh;
- (void)updateFrame:(CGRect)frame;
@end
