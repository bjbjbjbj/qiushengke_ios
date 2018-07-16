//
//  FootballMatchTableViewCell.h
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/10.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoTableViewCell : UITableViewCell
@property(nonatomic, strong)IBOutlet UILabel* hostName;
@property(nonatomic, strong)IBOutlet UILabel* titleName;
@property(nonatomic, strong)IBOutlet UILabel* awayName;
@property(nonatomic, strong)IBOutlet UILabel* league;
@property(nonatomic, strong)IBOutlet UILabel* vs;
@property(nonatomic, strong)IBOutlet UIImageView* live;
+ (NSInteger)heightOfCell;
- (void)loadData:(NSDictionary*)dic;
@end
