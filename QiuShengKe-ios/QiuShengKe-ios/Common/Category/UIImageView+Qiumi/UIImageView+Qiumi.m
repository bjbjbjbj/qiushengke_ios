//
//  UIImage+UIImage_Qiumi.m
//  Qiumi
//
//  Created by xieweijie on 15/4/3.
//  Copyright (c) 2015年 51viper.com. All rights reserved.
//

#import "UIImageView+Qiumi.h"

@implementation UIImageView (Qiumi)
- (void)qiumi_setImageWithURLString:(NSString*)urlString
{
    //下面这个是原来的，其实关键是UIViewContentModeScaleAspectFit 和image frame 的兼容，留一下底，2.0.0之后如果没什么事就可以删掉了
//    UIImage* image = [UIImage imageNamed:@"icon_default_image_bg.png"];
//    if (![self viewWithTag:[@"image_placeHold" hash]]) {
//        __block UIImageView* placeHold = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MIN(image.size.width, self.frame.size.width), MIN(image.size.height, self.frame.size.height))];
//        [placeHold setBackgroundColor:[UIColor clearColor]];
//        [placeHold setTag:[@"image_placeHold" hash]];
//        [placeHold setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
//        [placeHold setImage:image];
//        [self addSubview:placeHold];
//    }
//    
//    __weak typeof(self)wself = self;
//    [self sd_setImageWithURL:[NSURL URLWithString:urlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        if (error == nil && [self viewWithTag:[@"image_placeHold" hash]]) {
//            [wself setBackgroundColor:[UIColor clearColor]];
//            [[wself viewWithTag:[@"image_placeHold" hash]] removeFromSuperview];
//        }
//    }];
    
    [self qiumi_setImageWithURLString:urlString withHoldPlace:@"icon_default_image_bg.png"];
}

- (void)qiumi_setImageWithURLString:(NSString*)urlString withHoldPlace:(NSString*)holdPlace
{
    [self qiumi_setImageWithURLString:urlString withHoldPlace:holdPlace completed:nil];
}

- (void)qiumi_setImageWithURLString:(NSString *)urlString withHoldPlace:(NSString *)holdPlace completed:(QiuMiImageCompletionBlock)completedBlock
{
    UIImage* image = [UIImage imageNamed:holdPlace];
    if ([self viewWithTag:[@"image_placeHold" hash]]) {
        [[self viewWithTag:[@"image_placeHold" hash]] removeFromSuperview];
    }
    //有可能是默认图比显示的图大，这里要做min，取小的
    __block UIImageView* placeHold = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MIN(image.size.width, self.frame.size.width), MIN(image.size.height, self.frame.size.height))];
    [placeHold setTag:[@"image_placeHold" hash]];
    [placeHold setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
//        [placeHold setFrame:CGRectMake((CGRectGetWidth(self.frame) - CGRectGetWidth(placeHold.frame)) * 0.5, (CGRectGetHeight(self.frame) - CGRectGetHeight(placeHold.frame)) * 0.5, CGRectGetWidth(placeHold.frame), CGRectGetHeight(placeHold.frame))];
    [placeHold setImage:image];
    [placeHold setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:placeHold];
    [self sd_setImageWithURL:[NSURL URLWithString:urlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error == nil && [self viewWithTag:[@"image_placeHold" hash]]) {
            [[self viewWithTag:[@"image_placeHold" hash]] removeFromSuperview];
            if (completedBlock) {
                completedBlock(image, error);
            }
        }
    }];
}
@end
