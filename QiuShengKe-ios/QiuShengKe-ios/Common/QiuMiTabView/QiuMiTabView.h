//
//  QiuMiTabView.h
//  Qiumi
//
//  Created by Song Xiaochen on 2/9/15.
//  Copyright (c) 2015 51viper.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TabViewDelegate <NSObject>

-(void)outerScrollViewEnabelSetNo;

-(void)outerScrollViewEnabelSetYes;

@end

/* 栏目切换时，选中回调实用类,做相应界面切换操作* */
typedef void (^QiumiSelectedBlock)(NSInteger selectIdx);

@interface QiuMiTabView : UIView

@property (nonatomic, readonly) NSUInteger currentIndex;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *selectedSepColor;
@property (nonatomic, strong) UIColor *sepColor;
@property (nonatomic, strong) NSArray *columnTitles;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIFont *selectedFont;
@property (nonatomic, strong) UIColor *lineColor;
//是否跟随滑动
@property (nonatomic, assign) BOOL hasFollowScroll;
//回调block
@property (nonatomic, copy) QiumiSelectedBlock  doSelectBlock;
//是否滚到中间
@property (nonatomic, assign) BOOL mustScrollToCenter;
//箭头是否在上
@property (nonatomic, assign) BOOL isUpperWithArrow;
@property (nonatomic, assign) id <TabViewDelegate> delegate;
//下面两个参数canScroll ＝ no无效
//按钮文字间距（单边）
@property (nonatomic, assign) int buttonInterval;
//选中白线与文字长度差（单边）
@property (nonatomic, assign) int arrowWidth;
/*  简介：栏目按钮切换操作
 *  参数：
 ifCallBack:-- 用来判断是否需要通知回调,
 -- YES：
 -- NO ：使用场景：scroll滚动到了指定的page后，不用回调 */
- (void)selectAtIndex:(NSUInteger)index ifcallback:(BOOL)ifcallBack withAnima:(BOOL)isAnima;
/*
 滑动跟随
 以contentScroll为主
 */
- (void)contentScrollPositionX:(CGFloat)x withContentWidth:(CGFloat)contentWidth;
/*
 canScroll，默认no，如果为yes，则内容不居中，按长度现实
 */
- (instancetype)initWithFrame:(CGRect)frame withCanScroll:(BOOL)canScroll;
/*
 isUpper,默认no，如果为yes，箭头在上
 */
- (instancetype)initWithFrame:(CGRect)frame withCanScroll:(BOOL)canScroll withIsUpper:(BOOL)isUpper;
/*
 triangleType: 0 为蓝色 1 为白色
 默认为蓝色
*/
- (void)changeTheTrangleColorWithType:(NSInteger)type;

- (void)reloadData;

//是否能滑动
- (void)updateCanScroll:(BOOL)canScroll;
@end
