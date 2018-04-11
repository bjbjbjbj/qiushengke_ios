//
//  SDWebImageDownloaderOperation+FixSDImage.m
//  Qiumi
//
//  Created by xieweijie on 16/8/23.
//  Copyright © 2016年 51viper.com. All rights reserved.
//

#import "SDWebImageDownloaderOperation+FixSDImage.h"
#import "SDWebImageDecoder.h"
#import "UIImage+MultiFormat.h"
@interface SDWebImageDownloaderOperation () <NSURLConnectionDataDelegate>
{
    BOOL responseFromCached;
}
@property (copy, nonatomic) SDWebImageDownloaderCompletedBlock completedBlock;
@property (strong, nonatomic) NSMutableData *imageData;
@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, atomic) NSThread *thread;
- (UIImage *)scaledImageForKey:(NSString *)key image:(UIImage *)image;
- (void)done;
@end;
@implementation SDWebImageDownloaderOperation (FixSDImage)
- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
    SDWebImageDownloaderCompletedBlock completionBlock = self.completedBlock;
    @synchronized(self) {
        CFRunLoopStop(CFRunLoopGetCurrent());
        self.thread = nil;
        self.connection = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:SDWebImageDownloadStopNotification object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:SDWebImageDownloadFinishNotification object:self];
        });
    }
    
    if (![[NSURLCache sharedURLCache] cachedResponseForRequest:self.request]) {
        responseFromCached = NO;
    }
    
    if (completionBlock) {
        if (self.options & SDWebImageDownloaderIgnoreCachedResponse && responseFromCached) {
            completionBlock(nil, nil, nil, YES);
        } else if (self.imageData) {
            UIImage *image = [UIImage sd_imageWithData:self.imageData];
            
            NSData * data = self.imageData;
            //根据格式生成图片
            if ([self typeForImageData:self.imageData] == 0) {
                data = UIImageJPEGRepresentation(image, 1);
            }else if ([self typeForImageData:self.imageData] == 1){
                data = UIImagePNGRepresentation(image);
            }
            
            self.imageData = [NSMutableData dataWithData:data];
            
            NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:self.request.URL];
            image = [self scaledImageForKey:key image:image];
            
            // Do not force decoding animated GIFs
            if (!image.images) {
                if (self.shouldDecompressImages) {
                    image = [UIImage decodedImageWithImage:image];
                }
            }
            if (CGSizeEqualToSize(image.size, CGSizeZero)) {
                completionBlock(nil, nil, [NSError errorWithDomain:SDWebImageErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : @"Downloaded image has 0 pixels"}], YES);
            }
            else {
                completionBlock(image, self.imageData, nil, YES);
            }
        } else {
            completionBlock(nil, nil, [NSError errorWithDomain:SDWebImageErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : @"Image data is nil"}], YES);
        }
    }
    self.completionBlock = nil;
    [self done];
}

/*
 
 判断图片的格式
 
 0:@"image/jpeg";
 
 
 
 1:@"image/png";
 
 
 
 2:@"image/gif";
 
 
 
 3:@"image/tiff";
 
 */

- (NSInteger)typeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return 0;
        case 0x89:
            return 1;
        case 0x47:
            return 2;
        case 0x49:
        case 0x4D:
            return 3;
    }
    //默认为jpg
    return 0;
}
@end
