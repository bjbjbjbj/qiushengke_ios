//
//  FootballDetailBaseTechTableViewCell.h
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/11.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FootballDetailBaseTechTableViewCell : UITableViewCell
@property(nonatomic, strong)IBOutlet UIImageView* hicon;
@property(nonatomic, strong)IBOutlet UIImageView* aicon;
@property(nonatomic, strong)IBOutlet UILabel* name;
@property(nonatomic, strong)IBOutlet UILabel* home;
@property(nonatomic, strong)IBOutlet UILabel* away;
@property(nonatomic, strong)IBOutlet UIView* homePer;
@property(nonatomic, strong)IBOutlet UIView* awayPer;

+(NSUInteger)heightOfCell;
+(NSUInteger)heightOfCell2;
- (void)loadData:(NSDictionary*)dic;
- (void)loadMatchData:(NSDictionary*)dic;
@end
