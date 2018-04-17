//
//  FDBEventTableViewCell.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/17.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "FDBEventTableViewCell.h"

@implementation FDBEventTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadData:(NSDictionary *)dic{
    [_time setText:[NSString stringWithFormat:@"%ld'",(long)[dic integerForKey:@"happen_time"]]];
    if ([dic integerForKey:@"is_home"] == 1) {
        [[[_name3 superview] superview] setHidden:YES];
        if ([dic integerForKey:@"kind"] == 11) {
            [[_name2 superview] setHidden:NO];
            [_name1 setText:[dic objectForKey:@"player_name_j"]];
            [_name2 setText:[dic objectForKey:@"player_name_j2"]];
        }
        else{
            [[_name2 superview] setHidden:YES];
            [_name1 setText:[dic objectForKey:@"player_name_j"]];
        }
    }
    else{
        [[[_name1 superview] superview] setHidden:YES];
        if ([dic integerForKey:@"kind"] == 11) {
            [[_name4 superview] setHidden:NO];
            [_name3 setText:[dic objectForKey:@"player_name_j"]];
            [_name4 setText:[dic objectForKey:@"player_name_j2"]];
        }
        else{
            [[_name4 superview] setHidden:YES];
            [_name3 setText:[dic objectForKey:@"player_name_j"]];
        }
    }
}

+ (NSInteger)heightOfEnd{
    return 48;
}

+ (NSInteger)heightOfHead{
    return 68;
}

+ (NSInteger)heightOfEvent{
    return 50;
}
@end
