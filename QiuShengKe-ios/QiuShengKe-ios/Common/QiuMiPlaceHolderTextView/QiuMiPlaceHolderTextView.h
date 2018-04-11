//
//  QiuMiPlaceHolderTextView.h
//  Qiumi
//
//  Created by Song Xiaochen on 1/19/15.
//  Copyright (c) 2015 51viper.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QiuMiPlaceHolderTextView : UITextView
{
    NSString *placeholder;
    UIColor *placeholderColor;
    
@private
    UILabel *placeHolderLabel;
}

/**
 占位符视图
 */
@property (nonatomic, retain) UILabel *placeHolderLabel;

/**
 占位符文本
 */
@property (nonatomic, retain) NSString *placeholder;

/**
 占位符文本颜色
 */
@property (nonatomic, retain) UIColor *placeholderColor;

/**
 文本改变的通知
 @param notification 通知对象
 */
-(void)textChanged:(NSNotification*)notification;

@end
