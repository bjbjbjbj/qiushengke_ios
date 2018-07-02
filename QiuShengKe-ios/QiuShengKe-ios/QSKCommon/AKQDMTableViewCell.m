//
//  AKQDMTableViewCell.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/6/29.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "AKQDMTableViewCell.h"
@interface AKQDMTableViewCell()
@property(nonatomic, strong)IBOutlet UILabel* dmText;
@end
@implementation AKQDMTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadData:(NSDictionary *)dic{
    [_dmText setText:[dic objectForKey:@"text"]];
}
@end
