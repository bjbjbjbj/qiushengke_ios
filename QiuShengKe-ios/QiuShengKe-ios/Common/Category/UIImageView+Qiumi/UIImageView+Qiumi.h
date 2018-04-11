//
//  UIImageView+Qiumi.h
//  Qiumi
//
//  Created by xieweijie on 15/4/3.
//  Copyright (c) 2015年 51viper.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^QiuMiImageCompletionBlock)(UIImage *image, NSError *error);

@interface UIImageView (Qiumi)
//加载态度图片用
- (void)qiumi_setImageWithURLString:(NSString*)urlString;
- (void)qiumi_setImageWithURLString:(NSString*)urlString withHoldPlace:(NSString*)holdPlace;
- (void)qiumi_setImageWithURLString:(NSString*)urlString withHoldPlace:(NSString*)holdPlace completed:(QiuMiImageCompletionBlock)completedBlock;
@end
