//
//  BDBScoreTableViewCell.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/18.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "BDBScoreTableViewCell.h"
@interface BDBScoreTableViewCell()
@property(nonatomic, strong)IBOutlet UILabel* score1;
@property(nonatomic, strong)IBOutlet UILabel* score2;
@property(nonatomic, strong)IBOutlet UILabel* score3;
@property(nonatomic, strong)IBOutlet UILabel* score4;
@property(nonatomic, strong)IBOutlet UILabel* scoreOT;
@property(nonatomic, strong)IBOutlet UILabel* score;
@property(nonatomic, strong)IBOutlet UIImageView* teamIcon;
@end
@implementation BDBScoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadTitle:(NSDictionary *)dic{
    if ([dic existForKey:@"h_ot"] || [dic existForKey:@"a_ot"]) {
        [_scoreOT setHidden:NO];
    }
    else{
        [_scoreOT setHidden:YES];
    }
    if ([dic integerForKey:@"system"] == 1) {
        [_score1 setText:@"上半场"];
        [_score3 setText:@"下半场"];
        [_score2 setHidden:YES];
        [_score4 setHidden:YES];
    }
    else{
        [_score2 setHidden:NO];
        [_score4 setHidden:NO];
    }
}

- (void)loadData:(NSDictionary *)dic isHost:(BOOL)isHost{
    if ([dic existForKey:@"h_ot"] || [dic existForKey:@"a_ot"]) {
        [_scoreOT setHidden:NO];
        NSInteger total = 0;
        if (isHost && [[dic objectForKey:@"h_ot"] isKindOfClass:[NSArray class]]) {
            for (NSNumber* tmp in [dic objectForKey:@"h_ot"]) {
                total += [tmp integerValue];
            }
        }
        else if([[dic objectForKey:@"a_ot"] isKindOfClass:[NSArray class]]){
            for (NSNumber* tmp in [dic objectForKey:@"a_ot"]) {
                total += [tmp integerValue];
            }
        }
        [_scoreOT setText:[NSString stringWithFormat:@"%ld",total]];
    }
    else{
        [_scoreOT setHidden:YES];
    }
    
    if ([dic integerForKey:@"system"] == 1) {
        [_score2 setHidden:YES];
        [_score4 setHidden:YES];
    }
    else{
        [_score2 setHidden:NO];
        [_score4 setHidden:NO];
    }
    
    if (isHost) {
        [_score1 setText:[dic stringForKey:@"hscore_1st" withDefault:@"/"]];
        [_score2 setText:[dic stringForKey:@"hscore_2nd" withDefault:@"/"]];
        [_score3 setText:[dic stringForKey:@"hscore_3rd" withDefault:@"/"]];
        [_score4 setText:[dic stringForKey:@"hscore_4th" withDefault:@"/"]];
        [_score setText:[dic stringForKey:@"hscore" withDefault:@"/"]];
        [_teamIcon qiumi_setImageWithURLString:[dic stringForKey:@"hicon"] withHoldPlace:QIUMI_DEFAULT_IMAGE];
    }
    else{
        [_score1 setText:[dic stringForKey:@"ascore_1st" withDefault:@"/"]];
        [_score2 setText:[dic stringForKey:@"ascore_2nd" withDefault:@"/"]];
        [_score3 setText:[dic stringForKey:@"ascore_3rd" withDefault:@"/"]];
        [_score4 setText:[dic stringForKey:@"ascore_4th" withDefault:@"/"]];
        [_score setText:[dic stringForKey:@"ascore" withDefault:@"/"]];
        [_teamIcon qiumi_setImageWithURLString:[dic stringForKey:@"aicon"] withHoldPlace:QIUMI_DEFAULT_IMAGE];
    }
}

+ (NSInteger)heightOfCell{
    return 50;
}

+ (NSInteger)heightOfTitle{
    return 22;
}
@end
