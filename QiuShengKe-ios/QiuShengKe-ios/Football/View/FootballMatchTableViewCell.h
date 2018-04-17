//
//  FootballMatchTableViewCell.h
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/10.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FootballMatchTableViewCell : UITableViewCell
@property(nonatomic, strong)IBOutlet UILabel* hostName;
@property(nonatomic, strong)IBOutlet UILabel* awayName;
@property(nonatomic, strong)IBOutlet UILabel* hscore;
@property(nonatomic, strong)IBOutlet UILabel* ascore;
@property(nonatomic, strong)IBOutlet UILabel* hhscore;
@property(nonatomic, strong)IBOutlet UILabel* ahscore;
@property(nonatomic, strong)IBOutlet UILabel* hred;
@property(nonatomic, strong)IBOutlet UILabel* ared;
@property(nonatomic, strong)IBOutlet UILabel* hyellow;
@property(nonatomic, strong)IBOutlet UILabel* ayellow;
@property(nonatomic, strong)IBOutlet UILabel* asia;
@property(nonatomic, strong)IBOutlet UILabel* goal;
@property(nonatomic, strong)IBOutlet UILabel* ou;
@property(nonatomic, strong)IBOutlet UILabel* league;
@property(nonatomic, strong)IBOutlet UILabel* time;
@property(nonatomic, strong)IBOutlet UIImageView* hicon;
@property(nonatomic, strong)IBOutlet UIImageView* aicon;
@property(nonatomic, strong)IBOutlet UIButton* liveBtn;
+ (NSInteger)heightOfCell;
- (void)loadData:(NSDictionary*)dic;
@end
