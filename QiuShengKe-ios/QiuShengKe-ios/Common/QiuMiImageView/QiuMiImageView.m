//
//  QiuMiImageView.m
//  Qiumi
//
//  Created by xieweijie on 15/4/20.
//  Copyright (c) 2015年 51viper.com. All rights reserved.
//

#import "QiuMiImageView.h"
#import "UIImage+GIF.h"
#import "SDWebImageManager.h"
#import "OLImage.h"
#import "NSData+ImageContentType.h"
#import "UIImage+WebP.h"
#import "NSString+Qiumi.h"

@interface QiuMiImageView()
{
    BOOL _finshed;
}
@property(nonatomic, strong)NSString* placeHoldPath;
@property(nonatomic, strong)NSString* imagePath;
@property (nonatomic) CAShapeLayer *progressLayer;
@property (nonatomic) CAShapeLayer *backgroundLayer;
@end
@implementation QiuMiImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (instancetype)viewFromXib {
    QiuMiImageView* image = [[NSBundle mainBundle] loadNibNamed:@"QiuMiImageView"
                                                          owner:self
                                                        options:nil][0];
    [image.progress setClipsToBounds:YES];
    image.progress.layer.cornerRadius = 21;
    UIView* bg = [[image.progress superview] viewWithTag:99];
    [bg setClipsToBounds:YES];
    bg.layer.cornerRadius = 26;
    bg.layer.borderWidth = 2;
    bg.layer.borderColor = [UIColor colorWithWhite:1 alpha:.6].CGColor;
    [image setBackgroundColor:COLOR(238, 238, 238, 1)];
    return image;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    QiuMiViewResize(_imageView, CGSizeMake(frame.size.width, frame.size.height));
    QiuMiViewResize([_progress superview], CGSizeMake(frame.size.width, frame.size.height));
    [_progress setCenter:CGPointMake(frame.size.width/2, frame.size.height/2)];
    [[[_progress superview] viewWithTag:99] setCenter:_progress.center];
    [self setLineWidth:21];
}

- (void)loadImageWithString:(NSString*)path withPlaceHoldString:(NSString*)placeHoldString withFinishClick:(QiuMiImageClickFinish)clickFinish
{
    [_imageView setImage:nil];
    path = [path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    placeHoldString = [placeHoldString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.placeHoldPath = [placeHoldString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.imagePath = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    __weak typeof(self) wself = self;
    
    [self setBackgroundColor:COLOR(238, 238, 238, 1)];
    self.clickFinshBlock = clickFinish;
    _finshed = NO;
    [_isGif setHidden:NO];
    [_button setImage:[UIImage imageNamed:QIUMI_DEFAULT_IMAGE] forState:UIControlStateNormal];
    
    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:_imagePath]];
    NSData *lastPreviousCachedImage = [[SDImageCache sharedImageCache] diskImageDataBySearchingAllPathsForKey:key];
    if (lastPreviousCachedImage == nil) {
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:_placeHoldPath] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (finished && error == nil) {
                [wself.imageView setImage:image];
                [wself.button setImage:nil forState:UIControlStateNormal];
            }
        }];
        [_isGif setHidden:[path rangeOfString:@".gif"].location == NSNotFound];
        
        //wifi下直接加载大图
        if ([[QiuMiCommon instance] isWifi]) {
            [self clickPhoto:_button];
        }
        
    }
    else
    {
        [_isGif setHidden:YES];
        [_button setImage:nil forState:UIControlStateNormal];
        
        [_imageView setImage:[@"image/webp" isEqualToString:[NSData sd_contentTypeForImageData:lastPreviousCachedImage]]?[UIImage sd_imageWithWebPData:lastPreviousCachedImage]:[OLImage imageWithData:lastPreviousCachedImage]];
    }
    if (_isGif.isHidden) {
        _finshed = YES;
    }
}

- (IBAction)clickPhoto:(id)sender
{
    __weak typeof(self) wself = self;
    if (!_finshed) {
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:_imagePath] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            if (receivedSize >= 0 && expectedSize > 0) {
                float a = (1.00*receivedSize/expectedSize);
                if (a > 0) {
                    [[wself.progress superview]setHidden:NO];
                    [wself updateProgress:a];
                }
                else
                {
                    [[wself.progress superview]setHidden:NO];
                }
            }
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [wself finishLoadImage:image error:error cache:cacheType finished:finished imageUrl:imageURL];
        }];
    }
    else
    {
        if (_clickFinshBlock && [_imagePath rangeOfString:@"emoji_"].location == NSNotFound) {
            self.clickFinshBlock();
        }
    }
}

- (void)finishLoadImage:(UIImage *)image error:(NSError *)error cache:(SDImageCacheType) cacheType finished:(BOOL) finished imageUrl:(NSURL *)imageURL
{
    if (error == nil) {
        _finshed = YES;
        [[self.progress superview]setHidden:YES];
        [_isGif setHidden:YES];
        [self.button setImage:nil forState:UIControlStateNormal];
        [_imageView setImage:image];
    }
    else
    {
        [[self.progress superview]setHidden:YES];
        
        NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:self.imagePath]];
        NSData *lastPreviousCachedImage = [[SDImageCache sharedImageCache] diskImageDataBySearchingAllPathsForKey:key];
        if (lastPreviousCachedImage == nil) {
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:_placeHoldPath] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if (finished) {
                    [_imageView setImage:image];
                }
            }];
        }
        else
        {
            [_isGif setHidden:YES];
            [_button setImage:nil forState:UIControlStateNormal];
            
            [_imageView setImage:[@"image/webp" isEqualToString:[NSData sd_contentTypeForImageData:lastPreviousCachedImage]]?[UIImage sd_imageWithWebPData:lastPreviousCachedImage]:[OLImage imageWithData:lastPreviousCachedImage]];
        }
    }
}

- (void)setLineWidth:(CGFloat)lineWidth{
    [self.backgroundLayer removeFromSuperlayer];
    [self.progressLayer removeFromSuperlayer];
    
    self.backgroundLayer = [self createRingLayerWithCenter:CGPointMake(_progress.frame.size.width/2, _progress.frame.size.height/2) radius:CGRectGetWidth(self.progress.frame) / 2 - lineWidth / 2 lineWidth:lineWidth color:[UIColor clearColor]];
    self.backgroundLayer.strokeEnd = 1;
    [self.progress.layer addSublayer:_backgroundLayer];
    self.progressLayer = [self createRingLayerWithCenter:CGPointMake(_progress.frame.size.width/2, _progress.frame.size.height/2) radius:CGRectGetWidth(self.progress.frame) / 2 - lineWidth / 2 lineWidth:lineWidth color:[UIColor colorWithWhite:1 alpha:.6]];
    _progressLayer.strokeEnd = 0;
    [self.progress.layer addSublayer:_progressLayer];
}

- (CAShapeLayer *)createRingLayerWithCenter:(CGPoint)center radius:(CGFloat)radius lineWidth:(CGFloat)lineWidth color:(UIColor *)color {
    UIBezierPath *smoothedPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:- M_PI_2 endAngle:(M_PI + M_PI_2) clockwise:YES];
    CAShapeLayer *slice = [CAShapeLayer layer];
    slice.contentsScale = [[UIScreen mainScreen] scale];
    slice.frame = CGRectMake(center.x - radius, center.y - radius, radius * 2, radius * 2);
    slice.fillColor = [UIColor clearColor].CGColor;
    slice.strokeColor = color.CGColor;
    slice.lineWidth = lineWidth;
    slice.lineCap = kCALineJoinBevel;
    slice.lineJoin = kCALineJoinBevel;
    slice.path = smoothedPath.CGPath;
    return slice;
}

- (void)updateProgress:(float)progress{
    if (progress == 0) {
        self.progressLayer.hidden = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.progressLayer.strokeEnd = 0;
        });
    }else {
        self.progressLayer.hidden = NO;
        self.progressLayer.strokeEnd = progress;
    }
}

@end
