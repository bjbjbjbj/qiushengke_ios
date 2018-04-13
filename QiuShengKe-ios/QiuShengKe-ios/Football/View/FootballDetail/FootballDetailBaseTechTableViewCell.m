//
//  FootballDetailBaseTechTableViewCell.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/11.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "FootballDetailBaseTechTableViewCell.h"

@implementation FootballDetailBaseTechTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSUInteger)heightOfCell{
    return 54;
}

+ (NSUInteger)heightOfCell2{
    return 28;
}

- (void)loadMatchData:(NSDictionary *)dic{
    [_hicon qiumi_setImageWithURLString:[dic stringForKey:@"hicon"] withHoldPlace:QIUMI_DEFAULT_IMAGE];
    [_aicon qiumi_setImageWithURLString:[dic stringForKey:@"aicon"] withHoldPlace:QIUMI_DEFAULT_IMAGE];
}

- (void)loadData:(NSDictionary *)dic{
    [_home setText:[dic stringForKey:@"h" withDefault:@"0"]];
    [_away setText:[dic stringForKey:@"a" withDefault:@"0"]];
    QiuMiViewReframe(_homePer, CGRectMake([_homePer superview].frame.size.width - [_homePer superview].frame.size.width*[[dic objectForKey:@"h_p"] floatValue], 0, [_homePer superview].frame.size.width*[[dic objectForKey:@"h_p"] floatValue], _homePer.frame.size.height));
    QiuMiViewResize(_awayPer, CGSizeMake([_awayPer superview].frame.size.width*[[dic objectForKey:@"a_p"] floatValue], _awayPer.frame.size.height));
    [_name setText:[dic stringForKey:@"name"]];
}
@end
