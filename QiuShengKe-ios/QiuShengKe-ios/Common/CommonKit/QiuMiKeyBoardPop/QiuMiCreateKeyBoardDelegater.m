//
//  QiuMiCreateKeyBoardDelegater.m
//  Qiumi
//
//  Created by Viper on 16/8/5.
//  Copyright © 2016年 51viper.com. All rights reserved.
//

#import "QiuMiCreateKeyBoardDelegater.h"
@interface QiuMiCreateKeyBoardDelegater()
@end
@implementation QiuMiCreateKeyBoardDelegater
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    self.delegate = nil;
}

- (instancetype)initWithScroll:(UIScrollView*)scroll withContentSize:(float)contentSize withContentViewSize:(float)contentViewSize
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
        
        self.contentViewSize = contentViewSize;
        self.scrollContent = scroll;
        self.contentSize = contentSize;
    }
    return self;
}

-(void)keyboardWillShow:(NSNotification*)notification
{
    UITextField* nowTextField;
    if (_delegate && [(id)_delegate respondsToSelector:@selector(textFieldForKeyBoard)]) {
        nowTextField = [_delegate textFieldForKeyBoard];
    }
    NSDictionary *info = [notification userInfo];
        //获取键盘的size值
    CGRect _keyBoard = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (nowTextField) {
        CGRect textFrame = [nowTextField convertRect:nowTextField.frame toView:_scrollContent];
        float contentOffsetY;
        CGRect textWinFrame = [nowTextField convertRect:nowTextField.frame toView:[[[UIApplication sharedApplication] windows] objectAtIndex:0]];
        if (CGRectGetMaxY(textWinFrame) + 30 < _keyBoard.origin.y) {
            contentOffsetY = _scrollContent.contentOffset.y;
        }
        else{
            contentOffsetY = textFrame.origin.y + STATUSHEIGHT - (_scrollContent.frame.size.height - _keyBoard.size.height - nowTextField.frame.size.height);
        }
        float y = ((_contentSize >= _contentViewSize + _keyBoard.size.height)?_contentSize:(_contentSize + _contentViewSize - _contentSize + _keyBoard.size.height));
        [_scrollContent setContentSize:CGSizeMake(SCREENWIDTH, (_contentSize <= _contentViewSize?(_contentViewSize + _keyBoard.size.height):y))];
        [_scrollContent setContentOffset:CGPointMake(0, contentOffsetY) animated:NO];
    }else{
        [_scrollContent setContentSize:CGSizeMake(SCREENWIDTH, _contentSize + _keyBoard.size.height)];
        [_scrollContent setContentOffset:CGPointMake(0, _scrollContent.contentSize.height - CGRectGetHeight(_scrollContent.frame)) animated:NO];
    }
}

-(void)keyboardDidChange:(NSNotification*)notification  {
    
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3f animations:^{
        [_scrollContent setContentSize:CGSizeMake(SCREENWIDTH, _contentSize)];
        [_scrollContent setContentOffset:CGPointMake(0, 0) animated:YES];
    }];
}


@end
