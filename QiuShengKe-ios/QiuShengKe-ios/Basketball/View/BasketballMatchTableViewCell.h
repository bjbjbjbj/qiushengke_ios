//
//  BasketballMatchTableViewCell.h
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/18.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasketballMatchTableViewCell : UITableViewCell
@property(nonatomic, strong)IBOutlet UILabel* hostName;
@property(nonatomic, strong)IBOutlet UILabel* awayName;
@property(nonatomic, strong)IBOutlet UILabel* hscore1;
@property(nonatomic, strong)IBOutlet UILabel* ascore1;
@property(nonatomic, strong)IBOutlet UILabel* hscore2;
@property(nonatomic, strong)IBOutlet UILabel* ascore2;
@property(nonatomic, strong)IBOutlet UILabel* hscore3;
@property(nonatomic, strong)IBOutlet UILabel* ascore3;
@property(nonatomic, strong)IBOutlet UILabel* hscore4;
@property(nonatomic, strong)IBOutlet UILabel* ascore4;
@property(nonatomic, strong)IBOutlet UILabel* hscoreOT;
@property(nonatomic, strong)IBOutlet UILabel* ascoreOT;
@property(nonatomic, strong)IBOutlet UILabel* hscore;
@property(nonatomic, strong)IBOutlet UILabel* ascore;
@property(nonatomic, strong)IBOutlet UILabel* asia;
@property(nonatomic, strong)IBOutlet UILabel* goal;
@property(nonatomic, strong)IBOutlet UILabel* ou;
@property(nonatomic, strong)IBOutlet UILabel* league;
@property(nonatomic, strong)IBOutlet UILabel* time;
@property(nonatomic, strong)IBOutlet UIImageView* hicon;
@property(nonatomic, strong)IBOutlet UIImageView* aicon;
@property(nonatomic, strong)IBOutlet UIButton* liveBtn;
//赛事下面那个
@property(nonatomic, strong)IBOutlet UIButton* livingBtn;
- (void)loadData:(NSDictionary*)dic;
+ (NSInteger)heightOfCell;
@end
