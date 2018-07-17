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
    NSString* nickname = [dic objectForKey:@"nickname"];
    if ([dic integerForKey:@"type"] == 99) {
        NSString* message = [dic objectForKey:@"message"];
        NSMutableAttributedString* text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",nickname,message]];
        [text addAttributes:@{
                              NSForegroundColorAttributeName:COLOR(158, 158, 158, 1)
                              } range:NSMakeRange(0, [nickname length] + 1)];
        [text addAttributes:@{
                              NSForegroundColorAttributeName:COLOR(68, 63, 63, 1)
                              } range:NSMakeRange([nickname length] + 1,[message length])];
        [_dmText setAttributedText:text];
    }
    else{
        NSString* message = [dic objectForKey:@"message"];
        NSMutableAttributedString* text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@",nickname,message]];
        [text addAttributes:@{
                              NSForegroundColorAttributeName:COLOR(158, 158, 158, 1)
                              } range:NSMakeRange(0, [nickname length] + 1)];
        [text addAttributes:@{
                              NSForegroundColorAttributeName:COLOR(68, 63, 63, 1)
                              } range:NSMakeRange([nickname length] + 1,[message length])];
        [_dmText setAttributedText:text];
    }
}
@end
