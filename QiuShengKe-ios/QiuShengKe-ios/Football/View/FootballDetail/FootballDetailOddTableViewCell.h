//
//  FootballDetailOddTableViewCell.h
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/12.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FootballDetailOddTableViewCell : UITableViewCell
@property(nonatomic, strong)IBOutlet UILabel* comName;
@property(nonatomic, strong)IBOutlet UILabel* up1;
@property(nonatomic, strong)IBOutlet UILabel* middle1;
@property(nonatomic, strong)IBOutlet UILabel* down1;
@property(nonatomic, strong)IBOutlet UILabel* up2;
@property(nonatomic, strong)IBOutlet UILabel* middle2;
@property(nonatomic, strong)IBOutlet UILabel* down2;
+ (NSInteger)heightOfCell;
+ (NSInteger)heightOfCell2;
- (void)loadData:(NSDictionary*)dic;
- (void)loadDataTitle:(NSInteger)type;
@end
