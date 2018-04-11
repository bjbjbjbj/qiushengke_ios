//
//  QiuMiCreateKeyBoardDelegater.h
//  Qiumi
//
//  Created by Viper on 16/8/5.
//  Copyright © 2016年 51viper.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol QiuMiCreatekeyBoardDelegate
@required
- (UITextField*)textFieldForKeyBoard;
@end
@interface QiuMiCreateKeyBoardDelegater : NSObject<UITextFieldDelegate>
@property(nonatomic, weak)UIScrollView* scrollContent;
@property(nonatomic)float contentViewSize;
@property(nonatomic)float contentSize;
@property(nonatomic, weak)id<QiuMiCreatekeyBoardDelegate> delegate;
//1.contentSize:scrollview的contentsize
//2.contentViewSize:scroll里显示内容大小（一般情况contentViewSize>=contentSize）
- (instancetype)initWithScroll:(UIScrollView*)scroll withContentSize:(float)contentSize withContentViewSize:(float)contentViewSize;
@end
