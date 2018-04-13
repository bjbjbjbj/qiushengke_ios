//
//  FDARankTableViewCell.h
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/12.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDARankTableViewCell : UITableViewCell
@property(nonatomic, strong)IBOutlet UILabel* rank;
@property(nonatomic, strong)IBOutlet UILabel* team;
@property(nonatomic, strong)IBOutlet UILabel* count;
@property(nonatomic, strong)IBOutlet UILabel* result;
@property(nonatomic, strong)IBOutlet UILabel* goal;
@property(nonatomic, strong)IBOutlet UILabel* diff;
@property(nonatomic, strong)IBOutlet UILabel* score;
+ (NSInteger)heightOfTitle;
+ (NSInteger)heightOfCell;
- (void)loadData:(NSDictionary*)dic withTeam:(NSString*)team;
@end
