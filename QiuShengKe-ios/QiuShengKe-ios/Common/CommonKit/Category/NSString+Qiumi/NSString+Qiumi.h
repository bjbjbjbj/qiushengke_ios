//
//  NSString+Qiumi.h
//  Qiumi
//
//  Created by Song Xiaochen on 11/30/14.
//  Copyright (c) 2014 51viper.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#define QIUMI_NAMEMOTIFY_USER_REX @"([\\u4e00-\\u9fa5\\w\\-]+)"

@interface NSString (Qiumi)
/*
 * @brief 计算string高度
 */
+ (CGSize)obtainLabelWithByString:(NSString *)str
                             font:(UIFont *)font
                constrainedToSize:(CGSize)size;

/**
 *  根据日期转化详细说明 x年x月x日  今日
 *  好特别的地方用
 *
 *  @return 详细说明
 */
- (NSString *)dateDescription;

/**
 *  根据日期转化详细说明(上面的升级版)
 * 
 *
 *  @return 详细说明
 */
- (NSString *)dateDescriptionWith:(NSString*)explainFormat withDataFormat:(NSString*)dateFormat withString:(NSString*)stringFormat;

/*
 * @brief 返回url对应文件名
 */
- (NSString *)fileNameOfUrl;

/*
 * @brief 是否邮编
 */
+ (BOOL)isPostalNumber:(NSString *)postalNum;

/*
 * @brief 是否身份证
 */
+ (BOOL)isIdentityCard:(NSString *)identityCard;

/*
 @brief 获取首字母
 */
+ (NSString *)firstCharactor:(NSString *)aString;
/*
 @brief 数字转换单位
 */
+ (NSString *)changeTheNumberUnit:(NSInteger)number;
/*
 @brief 格式化小数
 */
+ (NSString *)decimalwithFormat:(NSString *)format  floatV:(float)floatV;

/*
 @brief 检查名字
 */
+ (BOOL)checkTheName:(NSString *)name;

/*
 @brief 是否QQ号
 */
+ (BOOL)isQQNumber:(NSString *)postalNum;

/*
 @brief 是否手机号
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

/*
 @brief 是否email
 */
+ (BOOL)isEmail:(NSString *)email;

/*
 @brief 解编码
 */
- (NSString *)decodeURIComponent;

/*
 @brief 快速返回字符串
 */
+ (NSString *)stringFormat:(NSString*)format text:(NSString*)texts,...;
@end
