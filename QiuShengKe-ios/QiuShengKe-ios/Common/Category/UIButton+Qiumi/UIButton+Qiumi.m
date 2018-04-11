//
//  UIButton+Qiumi.m
//  Qiumi
//
//  Created by xieweijie on 15/4/3.
//  Copyright (c) 2015年 51viper.com. All rights reserved.
//

#import "UIButton+Qiumi.h"

@implementation UIButton(Qiumi)
- (void)qiumi_setBackgroundImageWithURLString:(NSString*)urlString
{
    if ([urlString hasPrefix:@"//"]) {
        urlString = [NSString stringWithFormat:@"http:%@",urlString];
    }
    [self setBackgroundColor:QIUMI_COLOR_G5];
    [self sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal];
    UIImage* image = [UIImage imageNamed:@"icon_default_image_bg.png"];
    [self setImage:image forState:UIControlStateNormal];
    [self sd_setBackgroundImageWithURL:[NSURL URLWithString:urlString] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error == nil) {
            [self setImage:nil forState:UIControlStateNormal];
            [self setBackgroundColor:[UIColor clearColor]];
        }
//        else
//        {
//            [self setBackgroundImage:nil forState:UIControlStateNormal];
//        }
    }];
}

- (void)qiumi_setBackgroundImageWithURLString:(NSString*)urlString withHoldPlace:(NSString*)holdPlace
{
    [self sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal];
    UIImage* image = [UIImage imageNamed:holdPlace];
    [self setImage:image forState:UIControlStateNormal];
    [self sd_setBackgroundImageWithURL:[NSURL URLWithString:urlString] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error == nil) {
            [self setImage:nil forState:UIControlStateNormal];
        }
    }];
}

- (void)qiumi_setImageWithURLString:(NSString*)urlString withHoldPlace:(NSString*)holdPlace
{
    [self setBackgroundColor:QIUMI_COLOR_G5];
    [self setBackgroundImage:nil forState:UIControlStateNormal];
    UIImage* image = [UIImage imageNamed:holdPlace];
    [self setImage:image forState:UIControlStateNormal];
    if ([urlString length] == 0) {
        return;
    }
    dispatch_queue_t network_queue;
    network_queue = dispatch_queue_create("load image", nil);
    
    dispatch_async(network_queue, ^{
        NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:urlString]];
        NSData *lastPreviousCachedImage = [[SDImageCache sharedImageCache] diskImageDataBySearchingAllPathsForKey:key];
        UIImage * image = [UIImage imageWithData:lastPreviousCachedImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (lastPreviousCachedImage && image) {
                [self setImage:nil forState:UIControlStateNormal];
                [self setBackgroundColor:[UIColor clearColor]];
                [self setBackgroundImage:image forState:UIControlStateNormal];
            }
            else
            {
                [self sd_setBackgroundImageWithURL:[NSURL URLWithString:urlString] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (error == nil) {
                        [self setImage:nil forState:UIControlStateNormal];
                        [self setBackgroundColor:[UIColor clearColor]];
                    }
                }];
            }
        });
    });
}
@end
