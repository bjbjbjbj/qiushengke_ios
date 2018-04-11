//
//  PCPhotoView.m
//  PCMClient3
//
//  Created by lh liao on 11-9-7.
//  Copyright 2011年 太平洋网络. All rights reserved.
//

#import "PCPhotoView.h"
@interface PCPhotoView()
@property(nonatomic, strong)UIActivityIndicatorView* activity;
@end
@implementation PCPhotoView

- (void)dealloc {
    //afterDelay：
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.imageView = nil;
    self.controller = nil;
    [self.activity stopAnimating];
    [self.activity removeFromSuperview];
    self.activity = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDelegate:self];
        [self setMaximumZoomScale:2.0];
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        [self setBounces:NO];
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];

        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)loadImage:(NSString *) url{
    if (_activity) {
        [_activity removeFromSuperview];
    }
    else
    {
        self.activity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    [_activity startAnimating];
    
    [self addSubview:_activity];
    
    if ([url rangeOfString:@"?"].location != NSNotFound) {
        url = [url substringToIndex:[url rangeOfString:@"?"].location];
    }
    UIDevice *device = [UIDevice currentDevice];
    switch (device.orientation) {
        case UIDeviceOrientationPortrait:
        {
            [_imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"default_320x480.png"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [_activity removeFromSuperview];
            }];
        }
            break;
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
        {
            [_imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"default_480x320.png"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [_activity removeFromSuperview];
            }];
        }
            break;
        default:
        {
            [_imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"default_480x320.png"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [_activity removeFromSuperview];
            }];
        }
            break;
    }
}


- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center 
{
    
    CGRect zoomRect;
    
    zoomRect.size.height = [self frame].size.height / scale;
    zoomRect.size.width  = [self frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

- (BOOL)isZoomed
{
    return !([self zoomScale] == [self minimumZoomScale]);
}


- (void)zoomToLocation:(CGPoint)location
{
    float newScale;
    CGRect zoomRect;
    if ([self isZoomed]) {
        zoomRect = [self bounds];
    } else {
        newScale = [self maximumZoomScale];
        zoomRect = [self zoomRectForScale:newScale withCenter:location];
    }
    [self zoomToRect:zoomRect animated:YES];
}

- (void)turnOffZoom
{
    if ([self isZoomed]) {
        [self zoomToLocation:CGPointZero];
    }
}

//- (void) onOneClick{
//    if (!_isDoubleClick) {
//        if (_controller && [_controller respondsToSelector:@selector(onOneClick:)]) {
//            [_controller performSelector:@selector(onOneClick:) withObject:self];
//        }
//    }
//    _isDoubleClick = NO;
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    
//    if ([touch view] == self) {
//        if ([touch tapCount] == 1) {
//            [self performSelector:@selector(onOneClick) withObject:nil afterDelay:0.3];
//        }else if ([touch tapCount] == 2) {
//            _isDoubleClick = YES;
//            [self zoomToLocation:[touch locationInView:self]];
//        }
//    }
//    
//    [super touchesEnded:touches withEvent:event];
//}

- (void)layoutSubviews 
{
    [super layoutSubviews];
    
    if ([self isZoomed] == NO && CGRectEqualToRect([self bounds], [_imageView frame]) == NO) {
        [_imageView setFrame:[self bounds]];
        [[_imageView viewWithTag:[@"activityIndicator" hash]] setCenter:_imageView.center];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIView *viewToZoom = _imageView;
    return viewToZoom;
}

@end
