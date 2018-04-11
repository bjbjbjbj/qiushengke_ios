//
//  UIButton+Qiumi.h
//  Qiumi
//
//  Created by xieweijie on 15/4/3.
//  Copyright (c) 2015年 51viper.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIButton(Qiumi)
- (void)qiumi_setBackgroundImageWithURLString:(NSString*)urlString;
- (void)qiumi_setBackgroundImageWithURLString:(NSString*)urlString withHoldPlace:(NSString*)holdPlace;
- (void)qiumi_setImageWithURLString:(NSString*)urlString withHoldPlace:(NSString*)holdPlace;
@end
