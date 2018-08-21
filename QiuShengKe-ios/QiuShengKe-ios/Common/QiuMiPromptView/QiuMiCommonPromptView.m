//
//  QiuMiCommonPromptView.m
//  Qiumi
//
//  Created by Viper on 16/5/9.
//  Copyright © 2016年 51viper.com. All rights reserved.
//

#import "QiuMiCommonPromptView.h"
#import "UIImage+GIF.h"

//gif没改背景颜色，先用以前，之后动画可能重做
#define QIUMI_COLOR_C1_TMP COLOR(45, 176, 231, 1)
#define QIUMI_COLOR_C4_TMP COLOR(233, 98, 98, 1)
#define QIUMI_COLOR_C3_TMP COLOR(152, 209, 0, 1)

@interface QiuMiCommonPromptView()
//主标题
@property (nonatomic, retain) UILabel *titleLabel;
//副标题
@property (nonatomic, retain) UILabel *subLabel;
//gif图
@property (nonatomic, retain) UIImageView *gif;
//是否完全出现
@property (nonatomic, assign) BOOL finishLoading;
//父视图
@property (nonatomic, weak) UIView * parentView;
@property (nonatomic, strong) UIView * shadowView;
//弹框样式
@property (nonatomic, assign) QiuMiCommonPromptType promptType;
//是否已经hide
@property (nonatomic, assign) BOOL isHiden;

@end

@implementation QiuMiCommonPromptView

static QiuMiCommonPromptView* promptView = nil;

- (void)dealloc{
    self.finishLoading = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

+ (QiuMiCommonPromptView *)instance{
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        promptView = [[QiuMiCommonPromptView alloc]init];
    });
    return promptView;
}

//初始化方法
- (instancetype)init{
    self = [super init];
    if (self) {
        _contentView = nil;
        
        [self setFrame:CGRectMake((SCREENWIDTH - 130) * 0.5, SCREENHEIGHT * 0.5 - 34 - 50, 130, 88)];
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIView * content = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        content.layer.cornerRadius = 2;
        content.layer.masksToBounds = YES;
        [content setBackgroundColor:[UIColor whiteColor]];
        [content setTag:[@"content" hash]];
        [self addSubview:content];
        
        UIImageView * gif = [[UIImageView alloc]initWithFrame:CGRectMake(48, 15, 34, 34)];
        [content addSubview:gif];
        self.gif = gif;
        
        UILabel* title = [[UILabel alloc]initWithFrame:CGRectMake(15, 59, 100, 18)];
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setFont:[UIFont systemFontOfSize:13.f]];
        [title setTextColor:QIUMI_COLOR_G1];
        [content addSubview:title];
        [title setNumberOfLines:0];
        self.titleLabel = title;
        
        UILabel * subLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 59 + 18 + 3, 100, 20)];
        [subLabel setTextAlignment:NSTextAlignmentCenter];
        [subLabel setNumberOfLines:2];
        [subLabel setTextColor:QIUMI_COLOR_G2];
        [subLabel setFont:[UIFont systemFontOfSize:11.f]];
        self.subLabel = subLabel;
        [subLabel setHidden:YES];
        [content addSubview:subLabel];
        
        UIView* shadow = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        [shadow setBackgroundColor:COLOR(0, 0, 0, .20)];
        [shadow setTag:[@"prompt_shadow" hash]];
        self.shadowView = shadow;
    }
    return self;
}

+ (void)showLoading{
    QiuMiCommonPromptView * prompt = [QiuMiCommonPromptView instance];
    [NSObject cancelPreviousPerformRequestsWithTarget:prompt selector:@selector(hide) object:nil];
    //类型分类
    promptView.promptType = QiuMiCommonPromptDefualt;
    [promptView startActivity];
    [promptView.gif setImage:[UIImage imageNamed:@"icon_loading_ring"]];    //弹框显示
    [prompt showIn:nil];
}

+ (void)showText:(NSString *)text withSecText:(NSString *)secText withDic:(NSDictionary *)dic withPrompt:(QiuMiCommonPromptType)type{
    QiuMiCommonPromptView * prompt = [QiuMiCommonPromptView instance];
    //阻止上一次的消失动画
    [NSObject cancelPreviousPerformRequestsWithTarget:prompt selector:@selector(hide) object:nil];
    //类型分类
    promptView.promptType = type;
    switch (type) {
        case QiuMiCommonPromptDefualt:
        {
            [promptView startActivity];
            [promptView.gif setImage:[UIImage imageNamed:@"icon_loading_ring"]];
        }
            break;
        case QiuMiCommonPromptFail:
        {
            [promptView stopActivity];
            [promptView.gif setImage:[UIImage imageNamed:@"failed"]];
        }
            break;
        case QiuMiCommonPromptNetFail:
        {
            [promptView stopActivity];
            [promptView.gif setImage:[UIImage imageNamed:@"icon_loading_network"]];
        }
            break;
        case QiuMiCommonPromptSuccess:
        {
            [promptView stopActivity];
            [promptView.gif setImage:[UIImage imageNamed:@"icon_loading_draw"]];
        }
            break;
        default:
            [promptView stopActivity];
            break;
    }
    [promptView writeTheTitleLabelText:text withSubLabel:secText withDic:dic];
    //弹框显示
    [prompt showIn:nil];
}

- (void)showText:(NSString *)text withSecText:(NSString *)secText withDic:(NSDictionary *)dic withPrompt:(QiuMiCommonPromptType)type inContentView:(UIView *)view{
    [self showText:text withSecText:secText withDic:dic withPrompt:type inContentView:view with:0];
}

- (void)showText:(NSString *)text withSecText:(NSString *)secText withDic:(NSDictionary *)dic withPrompt:(QiuMiCommonPromptType)type inContentView:(UIView *)view with:(NSInteger)y{
    [self setTag:[QIUMI_COMMONPROMPT_TIP hash]];
    //类型分类
    self.promptType = type;
    switch (type) {
        case QiuMiCommonPromptDefualt:
        {
            [self startActivity];
            [self.gif setImage:[UIImage imageNamed:@"icon_loading_ring"]];
        }
            break;
        case QiuMiCommonPromptFail:
        {
            [self stopActivity];
            [self.gif setImage:[UIImage imageNamed:@"failed"]];
        }
            break;
        case QiuMiCommonPromptNetFail:
        {
            [self stopActivity];
            [self.gif setImage:[UIImage imageNamed:@"icon_loading_network"]];
        }
            break;
        case QiuMiCommonPromptSuccess:
        {
            [self stopActivity];
            [self.gif setImage:[UIImage imageNamed:@"icon_loading_draw"]];
        }
            break;
        default:
            [self stopActivity];
            break;
    }
    [self writeTheTitleLabelText:text withSubLabel:secText withDic:dic];
    //弹框显示
    [self showIn:view withY:y];
}

- (void)writeTheTitleLabelText:(NSString *)text withSubLabel:(NSString *)secText withDic:(NSDictionary *)dic{
    //如果有action直接显示action内容
    if ([dic objectForKey:@"action"]) {
        text = [[dic objectForKey:@"action"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    //主标题
    if (text && [text length] > 0) {
        [self.titleLabel setText:text];
    }
    //副标题
    NSMutableAttributedString * attString;
    if (secText && [secText length] > 0) {
        [self.subLabel setText:secText];
        [self.subLabel setHidden:NO];
        [self adjustmentWithLabel];
    }else{
        [self.subLabel setHidden:YES];
    }
}

- (void)adjustmentWithLabel{
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), self.subLabel.isHidden ? 88 : 106)];
    [[self viewWithTag:[@"content" hash]] setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
}

#pragma mark - 出现与消失
- (void)showIn:(UIView *)view{
    [self showIn:view withY:0];
}

- (void)showIn:(UIView *)view withY:(NSInteger)y
{
    UIView* parentView;
    if (view) {
        parentView = view;
    }else if(_contentView){
        parentView = _contentView;
    }else{
        parentView = [[[UIApplication sharedApplication] delegate] window];
    }
    self.parentView = parentView;
    
    [_shadowView removeFromSuperview];
    QiuMiViewResize(_shadowView, CGSizeMake(SCREENWIDTH, SCREENHEIGHT));
    //黑层
    _shadowView.alpha = 0;
    [_parentView addSubview:_shadowView];
    
    CGRect frame = self.frame;
    frame.origin.y = y > 0 ? y : (SCREENHEIGHT - CGRectGetHeight(self.frame)) * 0.5;
    [self setAlpha:0];
    frame.origin.x = (SCREENWIDTH - self.frame.size.width)/2;
    [self setFrame:frame];
    [parentView addSubview:self];
    switch (self.promptType) {
        case QiuMiCommonPromptDefualt:
        {
            [self.gif setImage:[UIImage imageNamed:@"icon_loading_ring"]];
        }
            break;
        case QiuMiCommonPromptFail:
        {
            [self stopActivity];
            [self.gif setImage:[UIImage imageNamed:@"fail.png"]];
        }
            break;
        case QiuMiCommonPromptNetFail:
        {
            [self stopActivity];
            [self.gif setImage:[UIImage imageNamed:@"icon_loading_network"]];
        }
            break;
        case QiuMiCommonPromptSuccess:
        {
            [self stopActivity];
            [self.gif setImage:[UIImage imageNamed:@"icon_loading_draw"]];
        }
            break;
        default:
            [self stopActivity];
            break;
    }
    [UIView animateWithDuration:0.25f animations:^{
        CGRect frame = self.frame;
        frame.origin.y = y > 0 ? y : (SCREENHEIGHT - CGRectGetHeight(self.frame)) * 0.5;
        _shadowView.alpha = 1;
        [self setAlpha:1];
        [self setFrame:frame];
    } completion:^(BOOL finished) {
        switch (self.promptType) {
            case QiuMiCommonPromptDefualt:
            {
                self.finishLoading = NO;
                [self.gif setImage:[UIImage imageNamed:@"icon_loading_ring"]];
                [self startActivity];
            }
                break;
            case QiuMiCommonPromptFail:
            {
                [self stopActivity];
                [self.gif setImage:[UIImage imageNamed:@"failed"]];
                [self performSelector:@selector(hide) withObject:nil afterDelay:0.72f];
            }
                break;
            case QiuMiCommonPromptNetFail:
            {
                [self stopActivity];
                [self.gif setImage:[UIImage imageNamed:@"icon_loading_network"]];
                [self performSelector:@selector(hide) withObject:nil afterDelay:1.26f];
            }
                break;
            case QiuMiCommonPromptSuccess:
            {
                [self stopActivity];
                [self.gif setImage:[UIImage imageNamed:@"icon_loading_draw"]];
                [self performSelector:@selector(hide) withObject:nil afterDelay:0.72f];
            }
                break;
            default:
                [self stopActivity];
                break;
        }
    }];
}

+ (void)hide:(NSString*)errorString{
    [promptView stopActivity];
    if (promptView && promptView.promptType != QiuMiCommonPromptNone) {
        [promptView hide:errorString];
    }
}

+ (void)hide{
    if (promptView && promptView.promptType != QiuMiCommonPromptNone) {
        [promptView hide];
    }
}

+ (void)hideNoAnimation{
    if (promptView && promptView.promptType != QiuMiCommonPromptNone) {
        [promptView hideNoAnimation];
    }
}

- (void)hide{
    [self hide:nil];
}

- (void)hideNoAnimation
{
    [self stopActivity];
    if (self.isHiden || self == nil || ![self superview]) {
        
        return;
    }
    self.isHiden = YES;
    
    switch (self.promptType) {
        case QiuMiCommonPromptDefualt:
        {
            self.finishLoading = YES;
            //            [self.gif setImage:[UIImage imageNamed:@"loading.png"]];
        }
            break;
        case QiuMiCommonPromptFail:
        {
            [self.gif setImage:[UIImage imageNamed:@"failed.png"]];
        }
            break;
        case QiuMiCommonPromptNetFail:
        {
            [self.gif setImage:[UIImage imageNamed:@"icon_loading_network"]];
        }
            break;
        case QiuMiCommonPromptSuccess:
        {
            [self.gif setImage:[UIImage imageNamed:@"icon_loading_draw"]];
        }
            break;
        default:
        {
            self.finishLoading = YES;
            //            [self.gif setImage:[UIImage imageNamed:@"loading.png"]];
        }
            break;
    }
    __weak typeof(self) wself = self;
    _shadowView.alpha = 0;
    CGRect frame = wself.frame;
    if (wself.parentView) {
        frame.origin.y = (CGRectGetHeight(wself.parentView.frame) - CGRectGetHeight(wself.frame)) * 0.5 - 50;
    }else{
        frame.origin.y = (SCREENHEIGHT - CGRectGetHeight(wself.frame)) * 0.5 - 50;
    }
    [wself setAlpha:0];
    [wself setFrame:frame];
    [_shadowView removeFromSuperview];
    if ([wself superview]) {
        [wself removeFromSuperview];
        wself.isHiden = NO;
        self.promptType = QiuMiCommonPromptNone;
    }
}

- (void)hide:(NSString*)errorString
{
    [self stopActivity];
    if (self.isHiden || self == nil || ![self superview]) {
        if ([errorString length] > 0) {
            [QiuMiPromptView showText:errorString];
        }
        return;
    }
    self.isHiden = YES;
    
    switch (self.promptType) {
        case QiuMiCommonPromptDefualt:
        {
            self.finishLoading = YES;
//            [self.gif setImage:[UIImage imageNamed:@"loading.png"]];
        }
            break;
        case QiuMiCommonPromptFail:
        {
            [self.gif setImage:[UIImage imageNamed:@"failed.png"]];
        }
            break;
        case QiuMiCommonPromptNetFail:
        {
            [self.gif setImage:[UIImage imageNamed:@"icon_loading_network"]];
        }
            break;
        case QiuMiCommonPromptSuccess:
        {
            [self.gif setImage:[UIImage imageNamed:@"icon_loading_draw"]];
        }
            break;
        default:
        {
            self.finishLoading = YES;
//            [self.gif setImage:[UIImage imageNamed:@"loading.png"]];
        }
            break;
    }
    __weak typeof(self) wself = self;
    _shadowView.alpha = 1;
    [UIView animateWithDuration:0.25f delay:[errorString length] > 0 ? 0.f : 1.5f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _shadowView.alpha = 0;
        CGRect frame = wself.frame;
        if (wself.parentView) {
            frame.origin.y = (CGRectGetHeight(wself.parentView.frame) - CGRectGetHeight(wself.frame)) * 0.5 - 50;
        }else{
            frame.origin.y = (SCREENHEIGHT - CGRectGetHeight(wself.frame)) * 0.5 - 50;
        }
        [wself setAlpha:0];
        [wself setFrame:frame];
    } completion:^(BOOL finished) {
        [_shadowView removeFromSuperview];
        if ([wself superview]) {
            [wself removeFromSuperview];
            wself.isHiden = NO;
            self.promptType = QiuMiCommonPromptNone;
        }
        if([errorString length] > 0){
            [QiuMiPromptView showText:errorString];
        }
    }];
}
#pragma mark - 成功与失败样式

+ (void)hideWithText:(NSString *)text withSecText:(NSString *)secText withType:(QiuMiCommonPromptType)type{
    [promptView hideWithText:text withSecText:secText withDic:nil withType:type];
}

+ (void)hideWithText:(NSString *)text withSecText:(NSString *)secText withDic:(NSDictionary *)dic withType:(QiuMiCommonPromptType)type{
    [promptView hideWithText:text withSecText:secText withDic:dic withType:type];
}

- (void)hideWithText:(NSString *)text withSecText:(NSString *)secText withType:(QiuMiCommonPromptType)type{
    [self hideWithText:text withSecText:secText withDic:nil withType:type];
}

- (void)hideWithText:(NSString *)text withSecText:(NSString *)secText withDic:(NSDictionary *)dic withType:(QiuMiCommonPromptType)type{
    [self stopActivity];
    if (_isHiden || self == nil) {
        return;
    }
    NSDictionary * param = [QiuMiCommonPromptView hideParamWithText:text withSecText:secText withDic:dic withType:type];
    [self performSelector:@selector(hideWithDetail:) withObject:param afterDelay:self.finishLoading? 1.2f : 0.5f];
}

+ (NSDictionary *)hideParamWithText:(NSString *)text withSecText:(NSString *)secText withDic:(NSDictionary *)dic withType:(QiuMiCommonPromptType)type{
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    switch (type) {
        case QiuMiCommonPromptDefualt:
        {
            [param setValue:text?text:secText forKey:@"text"];
            [param setValue:@(3) forKey:@"type"];
            [promptView hide];
        }
            break;
        case QiuMiCommonPromptFail:
        {
            [param setValue:@(2) forKey:@"type"];
            [param setValue:text forKey:@"text"];
            [param setValue:secText forKey:@"secText"];
            [param setValue:dic forKey:@"dic"];
        }
            break;
        case QiuMiCommonPromptNetFail:
        {
            [param setValue:@(3) forKey:@"type"];
            [param setValue:text forKey:@"text"];
            [param setValue:secText forKey:@"secText"];
            [param setValue:dic forKey:@"dic"];
        }
            break;
        case QiuMiCommonPromptSuccess:
        {
            [param setValue:@(4) forKey:@"type"];
            [param setValue:text forKey:@"text"];
            [param setValue:secText forKey:@"secText"];
            [param setValue:dic forKey:@"dic"];
        }
            break;
        default:
            break;
    }
    return param;
}

- (void)hideWithDetail:(NSDictionary *)detail{
    [self stopActivity];
    __weak typeof(self)wself = self;
    //错误了要用黑色的框提示，这里需求改了，如果代码蛋疼。。。就重构一次吧
    __block NSString* errorString = @"";
    [UIView animateWithDuration:0.25f animations:^{
        [[wself viewWithTag:[@"content" hash]] setAlpha:0];
    }completion:^(BOOL finished) {
        NSString * gif;
        __block CGFloat time;
        switch ([detail integerForKey:@"type"]) {
            case 1:
            {
                self.promptType = QiuMiCommonPromptDefualt;
                gif = @"icon_loading_ring";
                time = 0.72f;
                [wself.gif setImage:nil];
            }
                break;
            case 2:
            {
                wself.promptType = QiuMiCommonPromptFail;
                gif = @"failed";
                errorString = [detail objectForKey:@"secText"];
                time = 0.f;
                [wself.gif setImage:nil];
            }
                break;
            case 3:
            {
                wself.promptType = QiuMiCommonPromptNetFail;
                gif = @"icon_loading_network";
                time = 0.72f;
                [wself.gif setImage:nil];
            }
                break;
            case 4:
            {
                wself.promptType = QiuMiCommonPromptSuccess;
                gif = @"icon_loading_draw";
                time = 0.72f;
                [wself.gif setImage:nil];
            }
                break;
            default:
                break;
        }
        if ([errorString length] == 0) {
            [UIView animateWithDuration:0.25f animations:^{
                [[wself viewWithTag:[@"content" hash]] setAlpha:1];
                [wself writeTheTitleLabelText:[detail stringForKey:@"text" withDefault:@""] withSubLabel:[detail stringForKey:@"secText" withDefault:@""] withDic:[detail objectForKey:@"dic"]];
            }completion:^(BOOL finished) {
                [wself.gif setImage:[UIImage imageNamed:gif]];
                [wself performSelector:@selector(hide:) withObject:errorString afterDelay:time];
            }];
        }else{
            [self hide:errorString];
        }
    }];
}

- (void)showloadingWithY:(NSInteger)y{
//    [self setFrame:CGRectMake((SCREENWIDTH - 130) * 0.5, y, 130, 88)];
    [self showText:@"加载中" withSecText:@"" withDic:nil withPrompt:QiuMiCommonPromptDefualt inContentView:_contentView with:y];
}

- (void)showloading
{
    [self showText:@"加载中" withSecText:@"" withDic:nil withPrompt:QiuMiCommonPromptDefualt inContentView:_contentView];
}

- (void)showNetWorkFail:(NSString *)text{
    [self showText:QIUMI_NO_NETWORK withSecText:text withDic:nil withPrompt:QiuMiCommonPromptNetFail inContentView:_contentView];
}

- (void)showloadingWithText:(NSString*)text{
    [self showText:text withSecText:nil withDic:nil withPrompt:QiuMiCommonPromptDefualt inContentView:_contentView];
}

-(void)hideloading
{
    [self hide];
}

-(void)hideloadingWithText:(NSString*)text{
    [self hideWithText:text withSecText:nil withType:QiuMiCommonPromptDefualt];
}

-(void)hideloadingWhenFailWithText:(NSString*)text{
    [self hideWithText:nil withSecText:text withType:QiuMiCommonPromptFail];
}

-(void)hideloadingWhenNoNet{
    [self hideWithText:QIUMI_NO_NETWORK withSecText:nil withType:QiuMiCommonPromptNetFail];
}

-(void)hideloadingWhenNoNetWithText:(NSString*)text{
    [self hideWithText:QIUMI_NO_NETWORK withSecText:text withType:QiuMiCommonPromptNetFail];
}

#pragma mark - 动画
-(void)startActivity {
    [self stopActivity];
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat: 0];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = .7;
    
    rotationAnimation.repeatCount = MAXFLOAT;
    [self.gif.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

-(void)stopActivity {
    [self.gif.layer removeAnimationForKey:@"rotationAnimation"];
}
@end
