//
//  QiuMiAlertView.m
//  Qiumi
//
//  Created by xieweijie on 16/1/4.
//  Copyright © 2016年 51viper.com. All rights reserved.
//

#import "QiuMiAlertView.h"

@interface QiuMiAlertView()<UIGestureRecognizerDelegate>

@end

@implementation QiuMiAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAlert)];
    tap.delegate = self;
    [_bgView addGestureRecognizer:tap];
}

- (void)showAlert{
    [self setAlpha:0];
    [self setFrame:[WINDOW frame]];
    [_bgView setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_bgView setFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    [self.bgImage setBackgroundColor:[UIColor colorWithWhite:0 alpha:.60]];
    [_alertView setCenter:CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2 - 25)];
    [self setBackgroundColor:[UIColor clearColor]];
    [WINDOW addSubview:self];
    __weak typeof(self)wself = self;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [UIView animateWithDuration:0.2 animations:^{
        [wself.alertView setCenter:CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2)];
        [wself setAlpha:1];
    }completion:^(BOOL finished) {
        
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    CGPoint touchPoint = [touch locationInView:self];
    return !CGRectContainsPoint([self alertView].frame, touchPoint);
}

- (IBAction)hideAlert{
    __weak typeof(self)wself = self;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [UIView animateWithDuration:0.2 animations:^{
        [wself setAlpha:0];
        [wself.alertView setCenter:CGPointMake(SCREENWIDTH/2, wself.alertView.center.y - 25)];
    }completion:^(BOOL finished) {
        if (wself.superview) {
            [wself removeFromSuperview];
        }
        if (_hideBlock) {
            self.hideBlock();
        }
    }];
}

#pragma mark - keyboard

-(void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary *info = [notification userInfo];
    //获取键盘的size值
    CGRect _keyBoard = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [_alertView setCenter:CGPointMake(SCREENWIDTH/2, SCREENHEIGHT - _keyBoard.size.height - _alertView.frame.size.height/2 - 10)];
}

-(void)keyboardDidChange:(NSNotification*)notification  {
    
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3f animations:^{
        [_alertView setCenter:CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2)];
    }];
}
@end
