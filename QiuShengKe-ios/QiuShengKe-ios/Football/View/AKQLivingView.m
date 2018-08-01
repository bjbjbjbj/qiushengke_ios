//
//  AKQLivingView.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/8/1.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "AKQLivingView.h"
@interface AKQLivingView()
@property(nonatomic, strong)NSDictionary* data;
@end
@implementation AKQLivingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{
    [super awakeFromNib];
    QiuMiViewBorder(_text, 2, 1, [UIColor whiteColor]);
    QiuMiViewBorder(_icon, _icon.frame.size.height/2, 1, [UIColor whiteColor]);
    [self setBackgroundColor:[UIColor clearColor]];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tap];
}

- (void)tap{
    NSDictionary* data = _data;
    if ([[data objectForKey:@"url"] length] > 0) {
        [QiuMiCommonViewController navTo:[data objectForKey:@"url"]];
    }
    else{
        PlayerViewController* player = [QSKCommon getPlayerControllerWithMid:[data integerForKey:@"id"] sport:99];
        [player setNavTitle:[data objectForKey:@"title"]];
        [[QiuMiCommonViewController navigationController] pushViewController:player animated:YES];
    }
}

- (void)loadData:(NSDictionary *)data{
    self.data = data;
    if ([[data objectForKey:@"statusStr"] length] > 0) {
        [_text setText:[data objectForKey:@"statusStr"]];
        [_text setHidden:NO];
    }
    else{
        [_text setHidden:YES];
    }
    [_icon qiumi_setImageWithURLString:[[data objectForKey:@"anchor"] objectForKey:@"icon"] withHoldPlace:@"image_default_head"];
}
@end
