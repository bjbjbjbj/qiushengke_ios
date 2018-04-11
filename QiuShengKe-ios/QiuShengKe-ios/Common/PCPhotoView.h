//
//  PCPhotoView.h
//  PCMClient3
//
//  Created by lh liao on 11-9-7.
//  Copyright 2011年 太平洋网络. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface PCPhotoView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, weak) UIViewController *controller;
@property (nonatomic) NSInteger index;
@property (nonatomic) BOOL isDoubleClick;

- (void)loadImage:(NSString *)url;
- (void)turnOffZoom;
- (void)zoomToLocation:(CGPoint)location;
@end
