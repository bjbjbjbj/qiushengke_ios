//
//  FDAHistoryTableViewCell.h
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/13.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDAHistoryTableViewCell : UITableViewCell
@property(nonatomic, strong)IBOutlet UILabel* time;
@property(nonatomic, strong)IBOutlet UILabel* league;
@property(nonatomic, strong)IBOutlet UILabel* hname;
@property(nonatomic, strong)IBOutlet UILabel* aname;
@property(nonatomic, strong)IBOutlet UILabel* score;
@property(nonatomic, strong)IBOutlet UILabel* goal;
@property(nonatomic, strong)IBOutlet UILabel* result;
@property(nonatomic, strong)IBOutlet UILabel* handicap;
+ (NSInteger)heightOfTitle;
+ (NSInteger)heightOfCell;

- (void)loadData:(NSDictionary*)dic teamId:(NSInteger)tid;
@end
