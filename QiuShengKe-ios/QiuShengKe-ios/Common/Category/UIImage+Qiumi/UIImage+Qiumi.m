//
//  UIImage+UIImage_Qiumi.m
//  Qiumi
//
//  Created by xieweijie on 15/4/3.
//  Copyright (c) 2015年 51viper.com. All rights reserved.
//

#import "UIImage+Qiumi.h"
@implementation UIImage (Qiumi)
+ (UIImage*)qiumiImageWithName:(NSString*)name
{
    NSString* tmpName = name;
    if (2.0 == [[UIScreen mainScreen] scale]) {
        tmpName = [name stringByAppendingString:@"@2x.png"];
    }
    else if(3.0 == [[UIScreen mainScreen] scale])
    {
        tmpName = [name stringByAppendingString:@"@3x.png"];
    }
    
    return [UIImage imageNamed:tmpName];
}

+ (UIImage *)transformToSize:(CGSize)newSize withImage:(UIImage*)targetImg{
    UIGraphicsBeginImageContextWithOptions(newSize, YES, 1.0);
    [targetImg drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (UIImage *)transformToSquare:(NSInteger)width withImage:(UIImage *)targetImg
{
    CGAffineTransform scaleTransform;
    CGPoint origin;
    UIImage* image = targetImg;
    if (image.size.width > image.size.height) {
        CGFloat scaleRatio = width / image.size.height;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        origin = CGPointMake(-(image.size.width - image.size.height) / 2.0f, 0);
    } else {
        CGFloat scaleRatio = width / image.size.width;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        origin = CGPointMake(0, -(image.size.height - image.size.width) / 2.0f);
    }
    CGSize size = CGSizeMake(width, width);
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    //将image原始图片(400x200)pixels缩放为(800x400)pixels
    CGContextConcatCTM(context, scaleTransform);
    //origin也会从原始(-100, 0)缩放到(-200, 0)
    [image drawAtPoint:origin];
    //获取缩放后剪切的image图片
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)transformToRectangle:(CGSize)size withImage:(UIImage *)targetImg{
    CGAffineTransform scaleTransform;
    CGPoint origin;
    UIImage * image = targetImg;
    CGFloat scaleRatio;
    //判断最小比例
    if (image.size.width / size.width < image.size.height / size.height) {
        scaleRatio = size.width / image.size.width;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
    } else {
        scaleRatio = size.height / image.size.height;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
    }
    //根据缩放后大小确定中心位置
    CGFloat height = image.size.height * scaleRatio;
    CGFloat width = image.size.width * scaleRatio;
    if (height > size.height) {
        origin = CGPointMake(0, - (height - size.height) / 2.0f/scaleRatio);
    }else{
        origin = CGPointMake(0,(height - size.height) / 2.0f/scaleRatio);
    }
    if (width > size.width) {
        origin = CGPointMake( - (width - size.width )/ 2.0f/scaleRatio, origin.y);
    }else{
        origin = CGPointMake((width - size.width )/ 2.0f/scaleRatio, origin.y);
    }
    //设置图片框
    CGSize sizes = CGSizeMake(size.width, size.height);
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sizes, YES, 0);
    } else {
        UIGraphicsBeginImageContext(sizes);
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] set];
    UIRectFill(CGRectMake(0.0, 0.0, sizes.width, sizes.height));
    //将image原始图片(400x200)pixels缩放为(800x400)pixels
    CGContextConcatCTM(context, scaleTransform);
    //origin也会从原始(-100, 0)缩放到(-200, 0)
    [image drawAtPoint:origin];
    //获取缩放后剪切的image图片
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)transformToTopRectangle:(CGSize)size withImage:(UIImage *)targetImg{
    CGAffineTransform scaleTransform;
    CGPoint origin = CGPointMake(0, 0);
    UIImage * image = targetImg;
    CGFloat scaleRatio;
    //判断最小比例
    if (image.size.width / size.width < image.size.height / size.height) {
        scaleRatio = size.width / image.size.width;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
    } else {
        scaleRatio = size.height / image.size.height;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
    }
    //设置图片框
    CGSize sizes = CGSizeMake(size.width, size.height);
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sizes, YES, 0);
    } else {
        UIGraphicsBeginImageContext(sizes);
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    //将image原始图片(400x200)pixels缩放为(800x400)pixels
    CGContextConcatCTM(context, scaleTransform);
    //origin也会从原始(-100, 0)缩放到(-200, 0)
    [image drawAtPoint:origin];
    //获取缩放后剪切的image图片
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)cutTheScreenImage:(CGRect)frame{
    UIImage * image = [UIImage saveWindowScreenImage];
    //设置图片框
    CGSize sizes = CGSizeMake(frame.size.width, frame.size.height);
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sizes, YES, 0);
    } else {
        UIGraphicsBeginImageContext(sizes);
    }
    CGPoint origin;
    origin = CGPointMake(0 , - frame.origin.y);
    [image drawAtPoint:origin];
    //获取缩放后剪切的image图片
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageFromAlasset:(ALAsset*)alasset
{
    ALAssetRepresentation *assetRep = [alasset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullScreenImage];
    UIImage *img = [UIImage imageWithCGImage:imgRef
                                       scale:1
                                 orientation:UIImageOrientationUp];
    return img;
}

+ (UIImage *)thumbImageFromAlasset:(ALAsset*)alasset
{
    return [UIImage imageWithCGImage:alasset.thumbnail];
}
//重绘图片
+(UIImage *)compressImageWith:(UIImage *)image imageWidth:(CGFloat)width imageHeight:(CGFloat)height
{
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    
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

//屏幕截屏
+ (UIImage *)saveWindowScreenImage{
    return [UIImage saveScreenImage:[[UIApplication sharedApplication] keyWindow]];
}

+ (UIImage *)saveScreenImage:(UIView *)view
{
    return [UIImage saveScreenImage:view withSize:view.frame.size];
}

+ (UIImage *)saveScreenImage:(UIView *)view withSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* tmp = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tmp;
}

+ (UIImage *)fixOrientation:(UIImage *)aImage
{
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (UIImage *)getImageFromPickerReturnInfo:(NSDictionary *)info {
    UIImage * editedImg = [info valueForKey:UIImagePickerControllerEditedImage];
    UIImage * tmp = nil;
    
    if (editedImg) {
        tmp = editedImg;
    } else {
        tmp = [info valueForKey:UIImagePickerControllerOriginalImage];
    }
    
    UIImage * imgToSave = [self transformToDefaultSize:tmp];
    return imgToSave;
}
+ (UIImage *)transformToDefaultSize:(UIImage *)targetImg
{
    CGFloat MAX_WIDTH = 700.f;
    return [self transformToDefaultSize:targetImg withSize:CGSizeMake(MAX_WIDTH, MAX_WIDTH * targetImg.size.height / targetImg.size.width)];
}

+ (UIImage *)transformToDefaultSize:(UIImage *)targetImg withSize:(CGSize)size
{
    UIImage *imgToSave = nil;
    if (targetImg.size.width > size.width) {
        imgToSave = [self transformToSize:size withImage:targetImg];
    } else {
        imgToSave = targetImg;
    }
    return imgToSave;
}
@end
