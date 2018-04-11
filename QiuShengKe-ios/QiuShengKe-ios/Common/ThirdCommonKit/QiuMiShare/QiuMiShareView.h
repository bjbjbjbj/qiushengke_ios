//
//  QiuMiShareView.h
//  Qiumi
//
//  Created by xieweijie on 15/8/24.
//  Copyright (c) 2015年 51viper.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QiuMiPickerView.h"
typedef void (^QiuMiShareSuccess)(BOOL success);
@interface QiuMiShareView : QiuMiPickerView
+ (instancetype)instants;
- (void)showWithDictory:(QiuMiShareData*)dic withSuccess:(QiuMiShareSuccess)success;
- (void)showWithDictory:(QiuMiShareData*)dic withSuccess:(QiuMiShareSuccess)success withAnimate:(BOOL)withAnimate;
@end
