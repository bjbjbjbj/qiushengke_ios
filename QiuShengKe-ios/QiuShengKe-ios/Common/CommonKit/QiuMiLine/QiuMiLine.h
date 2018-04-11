//
//  QiuMiLine.h
//  Qiumi
//
//  Created by xieweijie on 15/8/31.
//  Copyright (c) 2015年 51viper.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, QiuMiLineType) {
    //水平
    QiuMiLineHorizontal = 100,
    //垂直
    QiuMiLineVertical = 101,
};
@interface QiuMiLine : UIView
/*
 * @brief 根据位置创建1像素线，默认分割线颜色
 */
- (id)initWithPosition:(CGPoint)point withType:(QiuMiLineType)type withLength:(int)length;
/*
 * @brief 根据位置创建1像素线
 */
- (id)initWithPosition:(CGPoint)point withType:(QiuMiLineType)type withLength:(int)length withColor:(UIColor*)color;
@end
