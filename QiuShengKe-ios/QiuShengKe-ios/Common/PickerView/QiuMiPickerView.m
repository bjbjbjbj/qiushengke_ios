//
//  QiuMiPickerView.m
//  Qiumi
//
//  Created by xieweijie on 16/8/17.
//  Copyright © 2016年 51viper.com. All rights reserved.
//

#import "QiuMiPickerView.h"

@implementation QiuMiPickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)hideKeyBorad{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


- (void)showAlert{
    [self hideKeyBorad];
    [self.bgView setAlpha:1];
    [self setFrame:[WINDOW frame]];
    [self.alertView setTranslatesAutoresizingMaskIntoConstraints:YES];
    QiuMiViewReframe(self.alertView, CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, self.alertView.frame.size.height));
    [self.bgView setBackgroundColor:[UIColor clearColor]];
    [self setBackgroundColor:[UIColor clearColor]];
    [WINDOW addSubview:self];
    __weak typeof(self)wself = self;
    [UIView animateWithDuration:.25 animations:^{
        QiuMiViewSetOrigin(wself.alertView, CGPointMake(0, SCREENHEIGHT - wself.alertView.frame.size.height));
//        [wself.bgView setAlpha:1];
        wself.bgView.layer.backgroundColor = [UIColor colorWithWhite:0 alpha:.5].CGColor;
    }completion:^(BOOL finished) {
        
    }];
    
    //动画
//    UIView* a = [(UITabBarController*)[[QiuMiCommonViewController window] rootViewController] selectedViewController].view;
//    a.layer.shouldRasterize = YES;
//    a.layer.rasterizationScale = [[UIScreen mainScreen] scale];
//    a.layer.zPosition = -1;
//    [UIView animateWithDuration:.25 animations:^{
//        CATransform3D rotate = CATransform3DMakeRotation(M_PI/18, 1, 0, 0);
//        a.layer.transform = CATransform3DPerspect(rotate, CGPointMake(0, 0), 500,.95);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:.25 animations:^{
//            CATransform3D rotate = CATransform3DMakeRotation(0, 1, 0, 0);
//            a.layer.transform = CATransform3DPerspect(rotate, CGPointMake(0, 0), 500,.9);
//        }];
//    }];
}

- (IBAction)hideAlert{
    self.bgView.layer.backgroundColor = [UIColor colorWithWhite:0 alpha:.5].CGColor;
    [self.alertView setTranslatesAutoresizingMaskIntoConstraints:YES];
    QiuMiViewReframe(self.alertView, CGRectMake(0, SCREENHEIGHT - self.alertView.frame.size.height, SCREENWIDTH, self.alertView.frame.size.height));
    __weak typeof(self)wself = self;
    [UIView animateWithDuration:.5 animations:^{
        QiuMiViewSetOrigin(wself.alertView, CGPointMake(0, SCREENHEIGHT));
        wself.bgView.layer.backgroundColor = [UIColor clearColor].CGColor;
    }completion:^(BOOL finished) {
        if (wself.superview) {
            [wself removeFromSuperview];
        }
    }];
    
//    UIView* a = [(UITabBarController*)[[QiuMiCommonViewController window] rootViewController] selectedViewController].view;
//    [UIView animateWithDuration:.5 animations:^{
//        a.layer.transform = CATransform3DIdentity;
//    } completion:^(BOOL finished) {
//        a.layer.shouldRasterize = NO;
//    }];
    
    if (self.hideBlock) {
        self.hideBlock();
    }
}
@end
