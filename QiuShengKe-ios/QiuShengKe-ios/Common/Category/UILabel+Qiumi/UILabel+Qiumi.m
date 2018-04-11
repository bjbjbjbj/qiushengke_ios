//
//  UIImage+UIImage_Qiumi.m
//  Qiumi
//
//  Created by xieweijie on 15/4/3.
//  Copyright (c) 2015年 51viper.com. All rights reserved.
//

#import "UILabel+Qiumi.h"

@implementation UILabel (Qiumi)
- (void)setInteger:(NSInteger)number{
    [self setText:[NSString stringWithFormat:@"%@",[[NSNumber numberWithInteger:number] stringValue]]];
}
@end
