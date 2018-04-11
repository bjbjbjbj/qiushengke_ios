//
//  QiuMiRefreshControl.m
//  Qiumi
//
//  Created by Song Xiaochen on 11/20/14.
//  Copyright (c) 2014 51viper.com. All rights reserved.
//

#import "QiuMiRefreshControl.h"
#import "UIImage+GIF.h"

#define kTotalViewHeight    400

@interface QiuMiLoadingView : UIImageView
/**
 *  创建旋转UIImageView
 *
 *  @param frame 显示位置
 *  @param image 显示旋转的图片
 *
 *  @return ImageView
 */
-(id) initWithFrame:(CGRect)frame withImage:(UIImage *)image;
/**
 *  开始旋转
 */
-(void)startActivity;
/**
 *  停止旋转
 */
-(void)stopActivity;
@end

@implementation QiuMiLoadingView

- (id)initWithFrame:(CGRect)frame withImage:(UIImage *)image {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.image = image;
    }
    return self;
}

-(void)startActivity {
//    [self stopActivity];
//    CABasicAnimation* rotationAnimation;
//    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    rotationAnimation.fromValue = [NSNumber numberWithFloat: 0];
//    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
//    rotationAnimation.duration = .7;
//
//    rotationAnimation.repeatCount = MAXFLOAT;
//    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

-(void)stopActivity {
//    [self.layer removeAnimationForKey:@"rotationAnimation"];
}
@end

@interface QiuMiRefreshControl ()
{
    CGFloat _lastOffset;
    BOOL _isLoading;
    NSInteger _loadingTime;
    NSInteger kOpenedViewHeight;
}

@property (nonatomic, strong)QiuMiLoadingView* loadView;
@property (nonatomic, strong)UILabel* statusLabel;
@property (nonatomic, readwrite) BOOL refreshing;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSTimer * time;

@end

@implementation QiuMiRefreshControl

- (void)dealloc
{
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    self.scrollView = nil;
    [self.layer removeAllAnimations];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if (self.time) {
        [_time invalidate];
        self.time = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initInScrollView:(UIScrollView *)scrollView {
    self = [self initInScrollView:scrollView iconOffSetX:0];
    [self addNotification];
    return self;
}

- (instancetype)initInScrollView:(UIScrollView *)scrollView withNoSep:(BOOL)noSep
{
    self = [self initInScrollView:scrollView iconOffSetX:0 withNoSep:noSep];
    [self addNotification];
    return self;
}

- (instancetype)initInScrollView:(UIScrollView *)scrollView iconOffSetX:(int)x
{
    self = [self initInScrollView:scrollView iconOffSetX:x withNoSep:NO];
    [self addNotification];
    return self;
}

- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(againActivity) name:QIUMI_REFRESH_COMMEBACK object:nil];
}

- (void)againActivity{
    if (_refreshing) {
        [self.loadView startActivity];
    }
}

- (instancetype)initInScrollView:(UIScrollView *)scrollView iconOffSetX:(int)x withNoSep:(BOOL)noSep
{
    noSep = YES;
    kOpenedViewHeight = 56;
    if (noSep) {
        kOpenedViewHeight = 56 + 8;
    }
    self = [super initWithFrame:CGRectMake(0, -(kTotalViewHeight + scrollView.contentInset.top + (noSep?8:0)), scrollView.frame.size.width, kTotalViewHeight + (noSep?8:0))];
    
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [scrollView addSubview:self];
        [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        self.scrollView = scrollView;
        
        self.refreshing = NO;
        _lastOffset = 0.0f;
        
        UIImage *image = [UIImage imageNamed:@"icon_refresh"];
        self.loadView = [[QiuMiLoadingView alloc] initWithFrame:CGRectMake(((SCREENWIDTH - image.size.width)/2) + x, (kTotalViewHeight - kOpenedViewHeight) + 8 + (noSep?8:0), image.size.width,image.size.height) withImage:image];
        [self addSubview:_loadView];
        
        self.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_loadView.frame) + 5, SCREENWIDTH, 13)];
        [_statusLabel setText:@"下拉刷新..."];
        [_statusLabel setTextAlignment:NSTextAlignmentCenter];
        [_statusLabel setTextColor:QIUMI_COLOR_G2];
        [_statusLabel setFont:[UIFont systemFontOfSize:11]];
        [self addSubview:_statusLabel];
        
        [self setBackgroundColor:QIUMI_COLOR_G5];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview) {
        [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
        self.scrollView = nil;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGFloat tmp = _lastOffset;
    // refreshing, do nothing
    if (_refreshing) return;
    CGFloat offset = _lastOffset;
    _lastOffset = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue].y;
//    UIImageView * updateIcon = (OLImageView *)[_iconView viewWithTag:[@"updateIcon" hash]];
    if (offset <= -kOpenedViewHeight && !_isLoading && self.refreshing == NO) {
        _isLoading = YES;
        if (!self.scrollView.dragging) {
            [_statusLabel setText:@"加载中..."];
            self.refreshing = YES;
            [self.loadView startActivity];
            [UIView animateWithDuration:0.3f animations:^{
                [self.scrollView setContentInset:UIEdgeInsetsMake(kOpenedViewHeight, 0, 0, 0)];
            }];
            
            double delayInSeconds = 1.f;
            __weak QiuMiRefreshControl *wself = self;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // code to be executed on the main queue after delay
                [wself sendActionsForControlEvents:UIControlEventValueChanged];
            });
        }
    } else {
        [_loadView stopActivity];
        if (offset <= -kOpenedViewHeight) {
            [_statusLabel setText:@"释放立即刷新..."];
        }
        else
        {
            [_statusLabel setText:@"下拉刷新..."];
        }
        _isLoading = NO;
        //随手势转动
        if (tmp - _lastOffset > 10) {
            tmp = tmp - 10;
        }
        else if (tmp - _lastOffset < -10)
        {
            tmp = tmp + 10;
        }
//        CGFloat detail = -fabsl(tmp/( - kOpenedViewHeight + 5));
//        CGAffineTransform transform =CGAffineTransformMakeRotation(2*M_PI*detail);
//        [_loadView setTransform:transform];
    }
}

- (void)beginRefreshing
{
    if (!_refreshing) {
        self.refreshing = YES;
        _isLoading = YES;
        [_statusLabel setText:@"加载中..."];
        [UIView animateWithDuration:0.2f animations:^{
            [self.scrollView setContentInset:UIEdgeInsetsMake(kOpenedViewHeight, 0, 0, 0)];
        }];
    }
}

- (void)endRefreshing
{
    if (_refreshing) {
        if (_time) {
            [_time invalidate];
            self.time = nil;
            _loadingTime = 0;
        }
        __weak typeof(self) wself = self;
        [self.statusLabel setText:@"加载完成"];
        [UIView animateWithDuration:.3
                         animations:^{
                             [UIView animateWithDuration:0.2f animations:^{
                                 [wself.scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
                                 _lastOffset = 0;
                             }];
                         } completion:^(BOOL finished) {
                             if (!_noScrolling) {
                                [wself.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                             }
                             wself.refreshing = NO;
                             _isLoading = NO;
                         }];
    }
}

- (void)loadingTime:(id)time{
    _loadingTime --;
    if (_loadingTime <= 0 && _time) {
        [_time invalidate];
        self.time = nil;
        [self endRefreshing];
    }
}

@end
