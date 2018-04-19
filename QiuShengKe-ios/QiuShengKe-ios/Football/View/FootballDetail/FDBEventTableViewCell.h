//
//  FDBEventTableViewCell.h
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/17.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDBEventTableViewCell : UITableViewCell
@property(nonatomic, strong)IBOutlet UILabel* time;
@property(nonatomic, strong)IBOutlet UILabel* name1;
@property(nonatomic, strong)IBOutlet UILabel* name2;
@property(nonatomic, strong)IBOutlet UILabel* name3;
@property(nonatomic, strong)IBOutlet UILabel* name4;

@property(nonatomic, strong)IBOutlet UIImageView* icon1;
@property(nonatomic, strong)IBOutlet UIImageView* icon2;
@property(nonatomic, strong)IBOutlet UIImageView* icon3;
@property(nonatomic, strong)IBOutlet UIImageView* icon4;
+(NSInteger)heightOfHead;
+(NSInteger)heightOfEvent;
+(NSInteger)heightOfEnd;

- (void)loadData:(NSDictionary*)dic;
@end
