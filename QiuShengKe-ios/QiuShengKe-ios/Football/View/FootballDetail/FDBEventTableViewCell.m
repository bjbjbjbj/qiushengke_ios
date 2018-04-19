//
//  FDBEventTableViewCell.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/17.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "FDBEventTableViewCell.h"
@interface FDBEventTableViewCell()
@property(nonatomic, strong)IBOutlet UIView* point;
@end
@implementation FDBEventTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if (_time) {
        QiuMiViewBorder([_time superview], [_time superview].frame.size.height/2, 0, [UIColor clearColor]);
    }
    if(_point){
        QiuMiViewBorder(_point, _point.frame.size.height/2, 0, [UIColor clearColor]);
    }
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
    NSString* image = [FDBEventTableViewCell imageName:[dic integerForKey:@"kind"]];
    if ([dic integerForKey:@"kind"] == 11) {
        if ([dic integerForKey:@"is_home"] == 1) {
            [_icon1 setImage:[UIImage imageNamed:@"event_icon_up_n"]];
            [_icon2 setImage:[UIImage imageNamed:@"event_icon_down_n"]];
        }
        else{
            [_icon3 setImage:[UIImage imageNamed:@"event_icon_up_n"]];
            [_icon4 setImage:[UIImage imageNamed:@"event_icon_down_n"]];
        }
    }
    else{
        if ([dic integerForKey:@"is_home"] == 1) {
            [_icon1 setImage:[UIImage imageNamed:image]];
        }
        else{
            [_icon3 setImage:[UIImage imageNamed:image]];
        }
    }
}

+ (NSString*)imageName:(NSInteger)kind{
    switch (kind) {
        case 1:
            return @"event_icon_maingoal_n";
            break;
        case 7:
            return @"event_icon_maingoal_n";
            break;
        case 8:
            return @"event_icon_customergoal_n";
            break;
        case 2:
            return @"event_icon_red_n";
            break;
        case 9:
            return @"event_icon_red_n";
            break;
        case 3:
            return @"event_icon_yellow_n";
            break;
    }
    return @"";
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
