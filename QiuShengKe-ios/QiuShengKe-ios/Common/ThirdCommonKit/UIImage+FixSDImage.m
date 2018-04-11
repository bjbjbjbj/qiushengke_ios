//
//  UIImage+FixSDImage.m
//  Qiumi
//
//  Created by xieweijie on 16/8/23.
//  Copyright © 2016年 51viper.com. All rights reserved.
//

#import "UIImage+FixSDImage.h"
#import "UIImage+GIF.h"
#import "NSData+ImageContentType.h"
#import <ImageIO/ImageIO.h>
#import <objc/runtime.h>

#ifdef SD_WEBP
#import "UIImage+WebP.h"
#endif

@interface UIImage()
+(UIImageOrientation)sd_imageOrientationFromImageData:(NSData *)imageData;
@end

@implementation UIImage (FixSDImage)
+ (void)load
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    method_exchangeImplementations(class_getClassMethod(self, @selector(sd_imageWithData:)), class_getClassMethod(self, @selector(fix_sd_imageWithData:)));
#pragma clang diagnostic pop
}

+ (UIImage *)fix_sd_imageWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    
    UIImage *image;
    NSString *imageContentType = [NSData sd_contentTypeForImageData:data];
    if ([imageContentType isEqualToString:@"image/gif"]) {
        image = [UIImage sd_animatedGIFWithData:data];
    }
#ifdef SD_WEBP
    else if ([imageContentType isEqualToString:@"image/webp"])
    {
        image = [UIImage sd_imageWithWebPData:data];
    }
#endif
    else {
        image = [[UIImage alloc] initWithData:data];
        if (data.length/1024 > 1024) {
            
            image = [self compressImageWith:image];
            
        }
        UIImageOrientation orientation = [self sd_imageOrientationFromImageData:data];
        if (orientation != UIImageOrientationUp) {
            image = [UIImage imageWithCGImage:image.CGImage
                                        scale:image.scale
                                  orientation:orientation];
        }
    }
    
    
    return image;
}

+(UIImage *)compressImageWith:(UIImage *)image
{
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    float width = 640;
    float height = image.size.height/(image.size.width/width);
    float widthScale = imageWidth /width;
    float heightScale = imageHeight /height;
    // 创建一个bitmap的context
    
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    if (widthScale > heightScale) {
        [image drawInRect:CGRectMake(0, 0, imageWidth /heightScale , height)];
    }
    else {
        [image drawInRect:CGRectMake(0, 0, width , imageHeight /widthScale)];
    }
    
    // 从当前context中创建一个改变大小后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    return newImage;
}
@end
