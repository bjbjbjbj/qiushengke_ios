//
//  FDAResultTableViewCell.h
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/13.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDAResultTableViewCell : UITableViewCell
@property(nonatomic, strong)IBOutlet UILabel* count;
@property(nonatomic, strong)IBOutlet UILabel* result;
@property(nonatomic, strong)IBOutlet UILabel* winP;
@property(nonatomic, strong)IBOutlet UILabel* big;
@property(nonatomic, strong)IBOutlet UILabel* bigP;
@property(nonatomic, strong)IBOutlet UILabel* small;
@property(nonatomic, strong)IBOutlet UILabel* smallP;
+ (NSInteger)heightOfTitle;
+ (NSInteger)heightOfCell;
- (void)loadData:(NSDictionary*)dic;
@end
