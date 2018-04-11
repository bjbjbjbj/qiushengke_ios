//
//  UIImage+Qiumi.h
//  Qiumi
//
//  Created by xieweijie on 15/4/3.
//  Copyright (c) 2015年 51viper.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIImage(Qiumi)
/*
 @brief 图片大小缩放
 */
+ (UIImage *)transformToSize:(CGSize)newSize withImage:(UIImage*)targetImg;

/*
 @brief 图片居中裁剪正方形
 */
+ (UIImage *)transformToSquare:(NSInteger)width withImage:(UIImage*)targetImg;

/*
 @brief 图片居中裁剪长方形
 */
+ (UIImage *)transformToRectangle:(CGSize)size withImage:(UIImage *)targetImg;
/*
 @brief 图片顶部切长方形
 */
+ (UIImage *)transformToTopRectangle:(CGSize)size withImage:(UIImage *)targetImg;

/*
 @brief 获取alasset里面的image
 */
+ (UIImage*)imageFromAlasset:(ALAsset *)alasset;

/*
 @brief 获取alasset里面的thumb image
 */
+ (UIImage*)thumbImageFromAlasset:(ALAsset *)alasset;

/*
 @brief 重绘获取到得图片
 */
+ (UIImage *)compressImageWith:(UIImage *)image imageWidth:(CGFloat)width imageHeight:(CGFloat)height;

/*
 * @brief 全屏幕截取
 */
+ (UIImage *)saveWindowScreenImage;

/*
 * @brief 屏幕截取
 */
+ (UIImage *)saveScreenImage:(UIView*)view;

/*
 * @brief 屏幕截取,可以定义大小
 */
+ (UIImage *)saveScreenImage:(UIView *)view withSize:(CGSize)size;

/*
 * @brief 横屏图片处理
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage;

/*
 * @brief 截取某一块屏幕图片
 */
+ (UIImage *)cutTheScreenImage:(CGRect)frame;

/*
 @brief 提取相片info
 */
+ (UIImage *)getImageFromPickerReturnInfo:(NSDictionary *)info;

/*
 @brief 获取图片（之前考虑的换肤功能）
 */
+ (UIImage*)qiumiImageWithName:(NSString*)name;
@end
