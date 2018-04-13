//
//  FDAScheduleTableViewCell.h
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/12.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDAScheduleTableViewCell : UITableViewCell
@property(nonatomic, strong)IBOutlet UILabel* time;
@property(nonatomic, strong)IBOutlet UILabel* sep;
@property(nonatomic, strong)IBOutlet UILabel* hname;
@property(nonatomic, strong)IBOutlet UILabel* aname;
@property(nonatomic, strong)IBOutlet UILabel* league;

+ (NSInteger)heightOfTitle;
+ (NSInteger)heightOfCell;

- (void)loadData:(NSDictionary*)dic teamId:(NSInteger)tid;
@end
