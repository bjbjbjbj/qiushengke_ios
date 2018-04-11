//
//  ALAssetsLibrary+defaultAssetsLibrary.m
//  Qiumi
//
//  Created by Viper on 16/1/23.
//  Copyright © 2016年 51viper.com. All rights reserved.
//

#import "ALAssetsLibrary+defaultAssetsLibrary.h"

@implementation ALAssetsLibrary (defaultAssetsLibrary)

+ (ALAssetsLibrary *)defaultAssetsLibrary{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred,
                  ^{
                      library = [[ALAssetsLibrary alloc] init];
                  });
    return library;
}

+ (void)saveImage:(UIImage *)image
{
    [ALAssetsLibrary saveImage:image withSuccess:nil];
}

+ (void)saveImage:(UIImage*)image withSuccess:(void (^)(NSURL *assetURL))block
{
    NSString* appName = @"料狗";//[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
    ALAssetsLibrary *assetsLibrary = [ALAssetsLibrary defaultAssetsLibrary];
    NSMutableArray *groups=[[NSMutableArray alloc]init];
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop)
    {
        if (group)
        {
            [groups addObject:group];
        }
        
        else
        {
            BOOL haveHDRGroup = NO;
            
            for (ALAssetsGroup *gp in groups)
            {
                NSString *name =[gp valueForProperty:ALAssetsGroupPropertyName];
                
                if ([name isEqualToString:appName])
                {
                    haveHDRGroup = YES;
                }
            }
            
            if (!haveHDRGroup)
            {
                [assetsLibrary addAssetsGroupAlbumWithName:appName
                                               resultBlock:^(ALAssetsGroup *group)
                 {
                     [groups addObject:group];
                     
                 }
                                              failureBlock:nil];
                haveHDRGroup = YES;
            }
        }
        
    };
    //创建相簿
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:listGroupBlock failureBlock:^(NSError *error) {
        //失败
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"创建相册失败"
                                                       message:@"请打开 设置-隐私-照片 来进行设置"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil, nil];
        [alert show];
    }];
    
    [ALAssetsLibrary saveToAlbumWithMetadata:nil imageData:UIImagePNGRepresentation(image) customAlbumName:appName completionBlock:^(NSURL* assetURL)
     {
         [QiuMiPromptView showText:@"图片已保存到手机相册"];
         if (block) {
             block(assetURL);
         }
     }
                                failureBlock:^(NSURL* assetURL, NSError *error)
     {
         //处理添加失败的方法显示alert让它回到主线程执行，不然那个框框死活不肯弹出来
         dispatch_async(dispatch_get_main_queue(), ^{
             if (error == nil) {
                 [QiuMiPromptView showText:@"图片已保存到手机相册"];
                 if (block) {
                     block(assetURL);
                 }
             }
             else if(-3310 == [error code])
             {
                 [QiuMiPromptView showText:@"无法保存，请进入iPhone的“设置-隐私-相片”选项中，允许访问你的相册"];
             }
             else
             {
                 [QiuMiPromptView showText:@"图片保存失败"];
             }
         });
     }];
}

+ (void)saveToAlbumWithMetadata:(NSDictionary *)metadata
                      imageData:(NSData *)imageData
                customAlbumName:(NSString *)customAlbumName
                completionBlock:(void (^)(NSURL *assetURL))completionBlock
                   failureBlock:(void (^)(NSURL *assetURL, NSError *error))failureBlock
{
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    __weak ALAssetsLibrary *weakSelf = assetsLibrary;
    void (^AddAsset)(ALAssetsLibrary *, NSURL *) = ^(ALAssetsLibrary *assetsLibrary, NSURL *assetURL) {
        [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                
                if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:customAlbumName]) {
                    [group addAsset:asset];
                    if (completionBlock) {
                        completionBlock(assetURL);
                    }
                }
            } failureBlock:^(NSError *error) {
                if (failureBlock) {
                    failureBlock(assetURL,error);
                }
            }];
        } failureBlock:^(NSError *error) {
            if (failureBlock) {
                failureBlock(assetURL,error);
            }
        }];
    };
    [assetsLibrary writeImageDataToSavedPhotosAlbum:imageData metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
        if (customAlbumName) {
            [assetsLibrary addAssetsGroupAlbumWithName:customAlbumName resultBlock:^(ALAssetsGroup *group) {
                if (group) {
                    [weakSelf assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        [group addAsset:asset];
                        if (completionBlock) {
                            completionBlock(assetURL);
                        }
                    } failureBlock:^(NSError *error) {
                        if (failureBlock) {
                            failureBlock(assetURL,error);
                        }
                    }];
                } else {
                    AddAsset(weakSelf, assetURL);
                }
            } failureBlock:^(NSError *error) {
                AddAsset(weakSelf, assetURL);
            }];
        } else {
            if (completionBlock) {
                completionBlock(assetURL);
            }
        }
    }];
}

@end
