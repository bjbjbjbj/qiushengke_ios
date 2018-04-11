//
//  QiuMiPromptView.m
//  Qiumi
//
//  Created by Song Xiaochen on 12/6/14.
//  Copyright (c) 2014 51viper.com. All rights reserved.
//

#import "QiuMiPromptView.h"

static QiuMiPromptViewSetting *sharedSettings = nil;

@interface QiuMiPromptView()

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIImageView *iconView;
@property (nonatomic, retain) UIButton *button;

- (void)show:(float)time;
- (void)hide;
- (void)transformWithInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end

#pragma mark - QiuMiPromptView

@implementation QiuMiPromptView

@synthesize titleLabel = _titleLabel;
@synthesize button = _button;

@synthesize iconView = _iconView;

static QiuMiPromptView *promptView = nil;
static float DefaultDuration = 1.5;

+ (void)shutdown
{
    promptView = nil;
}

+ (QiuMiPromptView *)share
{
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        promptView  =   [[QiuMiPromptView alloc] init];
    });
    return promptView;
}

+ (void)showText:(NSString *)text time:(float)time
{
    CGPoint center = [QiuMiPromptView getPointByViewLocation:QiuMiPromptViewLocationCenter];
    [QiuMiPromptView showText:text time:time gravity:center];
}

+ (void)showText:(NSString *)text
{
    [QiuMiPromptView showText:text time:DefaultDuration];
}

+ (void)showText:(NSString *)text gravity:(QiuMiPromptViewLocation)location
{
    CGPoint point = [QiuMiPromptView getPointByViewLocation:location];
    
    [QiuMiPromptView showText:text time:DefaultDuration gravity:point];
}

+ (void)showText:(NSString *)text time:(float)time gravity:(CGPoint)point
{
    UIView *superView = [QiuMiPromptView getDefaultParentView];
    
    [QiuMiPromptView showText:text icon:nil gravity:point atView:superView time:time];
}

+ (void)showText:(NSString *)text atView:(UIView *)superView time:(float)time
{
    CGPoint point = [QiuMiPromptView getPointByViewLocation:QiuMiPromptViewLocationCenter];
    
    [QiuMiPromptView showText:text icon:nil gravity:point atView:superView time:time];
    
}

+ (void)showText:(NSString *)text atView:(UIView *)superView
{
    [QiuMiPromptView showText:text atView:superView time:DefaultDuration];
}

+ (void)showText:(NSString *)text
            type:(QiuMiPromptViewType)promptType
{
    
    QiuMiPromptViewLocation location = QiuMiPromptViewLocationCenter;
    
    [QiuMiPromptView showText:text type:promptType gravity:location];
}

+ (void)showText:(NSString *)text
            type:(QiuMiPromptViewType)promptType
         gravity:(QiuMiPromptViewLocation)location
{
    float duration = DefaultDuration;
    
    NSString *imageKey = [NSString stringWithFormat:@"%i",promptType];
    NSString *imageName = [[[QiuMiPromptViewSetting getSharedSettings] images] objectForKey:imageKey];
    
    CGPoint point = [QiuMiPromptView getPointByViewLocation:location];
    
    UIView *superView = [QiuMiPromptView getDefaultParentView];
    
    [QiuMiPromptView showText:text icon:imageName gravity:point atView:superView time:duration];
}

+ (void)showText:(NSString *)text
       imageName:(NSString *)imageName
{
    QiuMiPromptViewLocation location = QiuMiPromptViewLocationCenter;
    
    [QiuMiPromptView showText:text imageName:imageName gravity:location];
}

+ (void)showText:(NSString *)text
       imageName:(NSString *)imageName
            time:(float)time
{
    QiuMiPromptViewLocation location = QiuMiPromptViewLocationCenter;
    float duration = time;
    
    CGPoint point = [QiuMiPromptView getPointByViewLocation:location];
    
    UIView *superView = [QiuMiPromptView getDefaultParentView];
    
    [QiuMiPromptView showText:text icon:imageName gravity:point atView:superView time:duration];
}

+ (void)showText:(NSString *)text
       imageName:(NSString *)imageName
         gravity:(QiuMiPromptViewLocation)location
{
    float duration = DefaultDuration;
    
    CGPoint point = [QiuMiPromptView getPointByViewLocation:location];
    
    UIView *superView = [QiuMiPromptView getDefaultParentView];
    
    [QiuMiPromptView showText:text icon:imageName gravity:point atView:superView time:duration];
}

+ (void)showText:(NSString *)text
            icon:(NSString *)imageName
         gravity:(CGPoint)point
          atView:(UIView *)superView
            time:(float)time
{
    
    QiuMiPromptView *promptView      =   [QiuMiPromptView share];
    
    QiuMiPromptViewSetting *setting = [QiuMiPromptViewSetting getSharedSettings];
    
    //阻止上一次的消失动画
    [NSObject cancelPreviousPerformRequestsWithTarget:promptView selector:@selector(hide) object:nil];
    
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    //以rootViewController方向来画出视图
    [promptView transformWithInterfaceOrientation:statusBarOrientation];
    
    if (nil != [promptView superview]) {
        [promptView removeFromSuperview];
    }
    
    [superView addSubview:promptView];
    [superView bringSubviewToFront:promptView];
    
    promptView.titleLabel.text = text;
    
    UIImage *iconImage = [UIImage imageNamed:imageName];
    promptView.iconView.image = iconImage;
    
    if (iconImage != nil) {
        
        //大小
        CGSize originalSize = [setting originalSize];
        originalSize = CGSizeMake(100, 75);
        promptView.bounds = CGRectMake(0, 0, originalSize.width, originalSize.height);
        
        //圆角半径
        promptView.layer.cornerRadius = [setting originalCornerRadius];
        promptView.layer.cornerRadius = 3;
        
        float width = UIInterfaceOrientationIsLandscape(statusBarOrientation) ? promptView.frame.size.height : promptView.frame.size.width;
        
        //图标
        promptView.iconView.frame = CGRectMake(( width - iconImage.size.width ) * 0.5 , 10, iconImage.size.width, iconImage.size.height);
        
        //标题
        CGFloat padding = 15;
        CGFloat titleWidth = width - padding * 2;
        CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: promptView.titleLabel.font}];
        
        promptView.titleLabel.numberOfLines = 1;
        
        if (size.width  > titleWidth) {
            promptView.titleLabel.adjustsFontSizeToFitWidth = YES;
        }
        else {
            promptView.titleLabel.adjustsFontSizeToFitWidth = NO;
        }
        
        promptView.titleLabel.frame = CGRectMake( padding, CGRectGetMaxY(promptView.iconView.frame), titleWidth, 36);
        
    }
    else {
        //根据文字来定视图大小
        CGSize size = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? [promptView.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: promptView.titleLabel.font}]: [text boundingRectWithSize:CGSizeMake(SCREENWIDTH - 40, 60) options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: promptView.titleLabel.font} context:nil].size;
        
        float screenWidth = UIInterfaceOrientationIsLandscape(statusBarOrientation) ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width;
        CGRect tFrame = CGRectMake(0, 0, MIN(screenWidth * 0.75, size.width), size.height);
        
        CGRect frame = CGRectInset(tFrame, -size.height*2/3,  -10);
        
        promptView.frame = frame;
        
        promptView.layer.cornerRadius = 2;
        
        [promptView.titleLabel setFrame:promptView.bounds];
        
        [promptView.button setFrame:promptView.bounds];
    }
    
    promptView.center = point;
    
    //显示
    [promptView show:time];
}

#pragma mark - private
+(CGPoint)getPointByViewLocation:(QiuMiPromptViewLocation )location
{
    id delegate = [[UIApplication sharedApplication] delegate];
    CGPoint point = CGPointMake([delegate window ].frame.size.width/2,
                                [delegate window ].frame.size.height/2);
    
    UIInterfaceOrientation orientation = (UIInterfaceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    switch (orientation) {
        case UIDeviceOrientationPortrait:
        {
            if (location == QiuMiPromptViewLocationTop) {
                point.y = point.y / 2.0;
            }
            else if (location == QiuMiPromptViewLocationBottom) {
                point.y = point.y / 2.0 * 3;
            }
            else if (location == QiuMiPromptViewLocationLeft) {
                point.x = point.x / 2.0;
            }
            else if (location == QiuMiPromptViewLocationRight) {
                point.x = point.x / 2.0 * 3;
            }
            break;
        }
        case UIDeviceOrientationPortraitUpsideDown:
        {
            if (location == QiuMiPromptViewLocationTop) {
                point.y = point.y / 2.0 * 3;
            }
            else if (location == QiuMiPromptViewLocationBottom) {
                point.y = point.y / 2.0;
            }
            else if (location == QiuMiPromptViewLocationLeft) {
                point.x = point.x / 2.0 * 3;
            }
            else if (location == QiuMiPromptViewLocationRight) {
                point.x = point.x / 2.0;
            }
            break;
        }
        case UIDeviceOrientationLandscapeLeft:
        {
            if (location == QiuMiPromptViewLocationTop) {
                point.x = point.x / 2.0 * 3;
            }
            else if (location == QiuMiPromptViewLocationBottom) {
                point.x = point.x / 2.0;
            }
            else if (location == QiuMiPromptViewLocationLeft) {
                point.y = point.y / 2.0;
            }
            else if (location == QiuMiPromptViewLocationRight) {
                point.y = point.y / 2.0 * 3;
            }
            
            break;
        }
        case UIDeviceOrientationLandscapeRight:
        {
            if (location == QiuMiPromptViewLocationTop) {
                point.x = point.x / 2.0 ;
            }
            else if (location == QiuMiPromptViewLocationBottom) {
                point.x = point.x / 2.0 * 3;
            }
            else if (location == QiuMiPromptViewLocationLeft) {
                point.y = point.y / 2.0 * 3;
            }
            else if (location == QiuMiPromptViewLocationRight) {
                point.y = point.y / 2.0;
            }
            
            break;
        }
        default:
            break;
    }
    
    return point;
}

+ (UIView *)getDefaultParentView
{
    id delegate = [[UIApplication sharedApplication] delegate];
    return [delegate window];
}

#pragma mark - init and dealloc
- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.titleLabel = nil;
    self.iconView = nil;
    
}

- (id)init
{
    self = [super init];
    if (self)
    {
        // Initialization code
        self.layer.cornerRadius     =   4;
        self.backgroundColor        =   [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        
        self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(1, 1);
        
        UILabel *label  =   [[UILabel alloc] initWithFrame:self.bounds];
        self.titleLabel      =   label;
        
        [self addSubview:_titleLabel];
        _titleLabel.textAlignment    =   NSTextAlignmentCenter;
        _titleLabel.textColor        =   [UIColor whiteColor];
        _titleLabel.backgroundColor  =   [UIColor clearColor];
        _titleLabel.lineBreakMode    =   NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines    =   1;
        
        CGFloat fontSize = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 25 : 13;
        _titleLabel.font = [UIFont systemFontOfSize:fontSize];
        
        self.alpha = 0;
        
        UIImageView *iconView = [[UIImageView alloc] init];
        [self addSubview:iconView];
        self.iconView = iconView;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchDown];
        self.button = button;
        [self addSubview:_button];
        
    }
    return self;
}


- (void)show:(float)time
{
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha          =   1;
    } completion:^(BOOL finished) {
        //添加监视旋转的通知
        //暂时没有这个需要，到时看看神马情况，微信回来会调用
//        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//        [center removeObserver:self];
//        [center addObserver:self
//                   selector:@selector(doRotate:)
//                       name:UIDeviceOrientationDidChangeNotification
//                     object:nil];
        
        //隐藏
        [self performSelector:@selector(hide) withObject:nil afterDelay:time];
    }];
    
    
}

- (void)hide
{
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }];
}

- (BOOL)isKeyboardVisible
{
    UIWindow *window    =   [UIApplication sharedApplication].keyWindow;
    return window.keyWindow;
}

- (void)transformWithInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    rotationAndPerspectiveTransform.m34 = 1.0 / -500;
    
    //iOS8下横屏的不一样
    if (IOS_VERSION < 8) {
        switch (interfaceOrientation)
        {
            case UIInterfaceOrientationPortrait:
                rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 0, 0.0f, 0.0f, 1.0f);
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, M_PI, 0.0f, 0.0f, 1.0f);
                break;
            case UIInterfaceOrientationLandscapeLeft:
                rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, M_PI*1.5, 0.0f, 0.0f, 1.0f);
                break;
            case UIInterfaceOrientationLandscapeRight:
                rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, M_PI/2, 0.0f, 0.0f, 1.0f);
                break;
            default:
                rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, M_PI/2, 0.0f, 0.0f, 1.0f);
                break;
        }
    }
    
    self.layer.transform = rotationAndPerspectiveTransform;
}

- (void)doRotate:(NSNotification *)notification
{
    //iOS8下横屏的不一样，转屏后不能回到原来的位置
    if (IOS_VERSION < 8) {
        CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
        
        [UIView animateWithDuration:duration
                         animations:^{
                             [self transformWithInterfaceOrientation:statusBarOrientation];
                         }];
    } else
    {
        //转屏后,
        self.alpha = 0;
        [self removeFromSuperview];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

@end

#pragma mark - QiuMiPromptViewSetting

@implementation QiuMiPromptViewSetting

@synthesize images = _images;
@synthesize originalSize = _originalSize;
@synthesize originalCornerRadius = _originalCornerRadius;

- (void)dealloc
{
}

- (void) setImage:(NSString *)imageName forType:(QiuMiPromptViewType) type
{
    if (!_images) {
        _images = [[NSMutableDictionary alloc] initWithCapacity:4];
    }
    
    if (imageName)
    {
        NSString *key = [NSString stringWithFormat:@"%i", type];
        [_images setValue:imageName forKey:key];
    }
}

- (id) copyWithZone:(NSZone *)zone{
    
    QiuMiPromptViewSetting *copy = [QiuMiPromptViewSetting new];
    
    copy.originalCornerRadius = self.originalCornerRadius;
    copy.originalSize = self.originalSize;
    
    NSArray *keys = [self.images allKeys];
    
    for (NSString *key in keys){
        [copy setImage:[_images valueForKey:key] forType:[key intValue]];
    }
    
    return copy;
}

#pragma mark - static 

+ (QiuMiPromptViewSetting *) getSharedSettings{
    
    if (!sharedSettings) {
        
        sharedSettings = [QiuMiPromptViewSetting new];
        
    }
    
    return sharedSettings;
    
}

@end
