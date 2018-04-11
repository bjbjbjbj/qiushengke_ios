//
//  QiuMiCommonTableHeadView.h
//  Qiumi
//
//  Created by Viper on 16/3/22.
//  Copyright © 2016年 51viper.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#define LG_COMMON_TABLE_SECTION_HEIGHT 58
@interface QiuMiCommonTableHeadView : UIView
@property(nonatomic, strong)UIView* line;
- (instancetype)initWithFrame:(CGRect)frame withIcon:(NSString *)iconString withTitle:(NSString *)titleString;

- (instancetype)initWithFrame:(CGRect)frame withIcon:(NSString *)iconString withTitle:(NSString *)titleString beginY:(CGFloat)y;
@end
