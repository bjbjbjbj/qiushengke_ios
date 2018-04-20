//
//  FootballMatchListViewController.h
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/10.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "QiuMiCommonViewController.h"

@interface FootballMatchListViewController : QiuMiCommonViewController
@property(nonatomic, strong)IBOutlet UITableView* tableView;
@property(nonatomic, strong)IBOutlet UICollectionView* collectionView;
@property(nonatomic, strong)IBOutlet UILabel* tips;
@property(nonatomic, strong)NSString* timeStr;
@property(nonatomic, assign)NSInteger type;
- (void)loadData;
@end
