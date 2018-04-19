//
//  BDBScoreTableViewCell.h
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/18.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDBScoreTableViewCell : UITableViewCell
- (void)loadTitle:(NSDictionary*)dic;
- (void)loadData:(NSDictionary*)dic isHost:(BOOL)isHost;
+ (NSInteger)heightOfCell;
+ (NSInteger)heightOfTitle;
@end
