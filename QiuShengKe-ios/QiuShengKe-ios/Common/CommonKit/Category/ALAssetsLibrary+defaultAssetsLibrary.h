//
//  ALAssetsLibrary+defaultAssetsLibrary.h
//  Qiumi
//
//  Created by Viper on 16/1/23.
//  Copyright © 2016年 51viper.com. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

@interface ALAssetsLibrary (defaultAssetsLibrary)
//单例使用(若果回调assest不使用单例会出现为unknown)
+ (ALAssetsLibrary *)defaultAssetsLibrary;

//保持图片
+ (void)saveImage:(UIImage*)image;

+ (void)saveImage:(UIImage*)image withSuccess:(void(^)(NSURL* assetURL))block;
@end
