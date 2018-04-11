//
//  NSString+Qiumi.m
//  Qiumi
//
//  Created by Song Xiaochen on 11/30/14.
//  Copyright (c) 2014 51viper.com. All rights reserved.
//

#import "NSString+Qiumi.h"

@implementation NSString (Qiumi)
+ (CGSize)obtainLabelWithByString:(NSString *)str
                             font:(UIFont *)font
                constrainedToSize:(CGSize)size {
    
    if (str == nil || font == nil) {
        return CGSizeMake(10, 10);
    }
    
    CGSize brandNameLabelSize;
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *attributesDictionary = @{NSFontAttributeName:font,
                                           NSParagraphStyleAttributeName:paragraphStyle};
    brandNameLabelSize = [str boundingRectWithSize:size
                                           options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                        attributes:attributesDictionary
                                           context:nil].size;
    
    if (IOS_VERSION >= 7.0 && IOS_VERSION <= 8.0) {
        brandNameLabelSize.width += 2;
    }
    if (IOS_VERSION >= 10) {
        brandNameLabelSize.width += 2;
    }
    
    return brandNameLabelSize;
}

- (NSString *)dateDescription {
    return [self dateDescriptionWith:@"yyyy-MM-dd" withDataFormat:@"yyyy-MM-dd" withString:@"%@  %@"];
}

- (NSString *)dateDescriptionWith:(NSString *)explainFormat withDataFormat:(NSString *)dateFormat withString:(NSString *)stringFormat
{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:explainFormat];
    NSDate *matchDate = [formater dateFromString:self];
    if (!matchDate) { //数据不符合格式
        return self;
    }
    //两段string拼凑成最终结果
    NSString *dateDescr = self;
    NSString *appendStr;
    //昨天、今天、明天的判断
    NSDate *today = [NSDate date];
    NSString *curTime = [formater stringFromDate:today];
    today = [formater dateFromString:curTime];
    NSInteger compareResult = [self compareToday:today withOtherDate:matchDate];
    if (compareResult == 0) {
        appendStr = @"今天";
    } else if (compareResult == -1) {
        appendStr = @"昨天";
    } else if (compareResult == 1) {
        appendStr = @"明天";
    } else {//判断星期几
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
        NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *comps = [calendar components:unitFlags fromDate:matchDate];
        NSInteger week = [comps weekday];
        switch (week) {
            case 1:
                appendStr = @"星期天";
                break;
            case 2:
                appendStr = @"星期一";
                break;
            case 3:
                appendStr = @"星期二";
                break;
            case 4:
                appendStr = @"星期三";
                break;
            case 5:
                appendStr = @"星期四";
                break;
            case 6:
                appendStr = @"星期五";
                break;
            case 7:
                appendStr = @"星期六";
                break;
            default:
                break;
        }
    }
    
    [formater setDateFormat:dateFormat];
    dateDescr = [formater stringFromDate:matchDate];
    
    dateDescr = [NSString stringWithFormat:stringFormat,dateDescr,appendStr];
    return dateDescr;
}

/**
 *  日期判断 今天、昨天、以前
 *
 *  @param today    今日
 *  @param otherDay 需要比较的日期
 *
 *  @return 昨天（-1），今日（0），明天（1），其他（1024）
 */
- (NSInteger)compareToday:(NSDate *)today withOtherDate:(NSDate *)otherDay{
    NSInteger ci;
    NSComparisonResult result = [today compare:otherDay];
    switch (result)
    {
        //today比otherDay大
        case NSOrderedDescending: {
            NSTimeInterval dayTime = 24*60*60;
            // 将today往前减少一天的时间，判断是否和昨天的时间是否相等，如果相等则表示otherDay为昨天
            NSDate * newDate = [today dateByAddingTimeInterval:-dayTime];
            result = [otherDay compare:newDate];
            if (result == NSOrderedSame) {
                // 表示日期为昨天
                ci = -1;
            } else {
                // 表示日期为昨天以前的时间
                ci = 1204;
            }
        }
            break;
        //today比otherDay小
        case NSOrderedAscending: {
            NSTimeInterval dayTime = 24*60*60;
            // 将today往后增加一天的时间，判断是否和昨天的时间是否相等，如果相等则表示otherDay为明天
            NSDate * newDate = [today dateByAddingTimeInterval:dayTime];
            result = [otherDay compare:newDate];
            if (result == NSOrderedSame) {
                // 表示日期为明天
                ci = 1;
            } else {
                // 表示日期为昨天以前的时间
                ci = 1204;
            }
        }
            break;
        default:
            //默认是今天
            ci = 0;
            break;
    }
    return ci;
}

- (NSString *)fileNameOfUrl
{
    NSString* url = [[self componentsSeparatedByString:@"?"] objectAtIndex:0];
    NSString* file = [url lastPathComponent];
    return file;
}

+ (BOOL)isPostalNumber:(NSString *)postalNum
{
    NSRegularExpression *exp = [NSRegularExpression regularExpressionWithPattern:@"^[0-9]\\d{5}$"
                                                                         options:NSRegularExpressionDotMatchesLineSeparators
                                                                           error:nil];
    
    NSArray *textArr = [exp matchesInString:postalNum options:0 range:NSMakeRange(0, [postalNum length])];
    
    if([textArr count] > 0)
    {
        return YES;
    } else
    {
        return NO;
    }
    return NO;
}

//获取首字母
+ (NSString *)firstCharactor:(NSString *)aString
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}

//转换单位
+(NSString *)changeTheNumberUnit:(NSInteger)number{
    NSString *str;
    if (number < 1000) {
        str = [NSString stringWithFormat:@"%@",@(number)];
    }else if(number > 1000 && number < 9500){
        CGFloat focus = number/1000.0;
        str = [NSString stringWithFormat:@"%.1lfK",focus];
    }else{
        CGFloat focus = number/10000.0;
        str = [NSString stringWithFormat:@"%.1lfW",focus];
    }
    return str;
}

//格式化小数（转化百分比）
+ (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:format];
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}

+ (BOOL)isQQNumber:(NSString *)postalNum
{
    NSRegularExpression *exp = [NSRegularExpression regularExpressionWithPattern:@"^[1-9][0-9]{4,9}$"
                                                                         options:NSRegularExpressionDotMatchesLineSeparators
                                                                           error:nil];
    
    NSArray *textArr = [exp matchesInString:postalNum options:0 range:NSMakeRange(0, [postalNum length])];
    
    if([textArr count] > 0)
    {
        return YES;
    } else
    {
        return NO;
    }
    return NO;
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString *Regex = @"^[1][3-8]\\d{9}$|^([6|9])\\d{7}$|^[0][9]\\d{8}$|^[6]([8|6])\\d{5}$";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",Regex];
    return [mobileTest evaluateWithObject:mobileNum];
}

+ (BOOL)isIdentityCard:(NSString *)identityCard{
    BOOL flag;
    if (identityCard.length <= 0)
    {
        flag = NO;
        return flag;
    }
    
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    flag = [identityCardPredicate evaluateWithObject:identityCard];
    
    return flag;
    
    //暂时屏蔽下面的逻辑
    /*
     //如果通过该验证，说明身份证格式正确，但准确性还需计算
     if(flag)
     {
     if(identityCard.length==18)
     {
     //将前17位加权因子保存在数组里
     NSArray * idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
     
     //这是除以11后，可能产生的11位余数、验证码，也保存成数组
     NSArray * idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
     
     //用来保存前17位各自乖以加权因子后的总和
     
     NSInteger idCardWiSum = 0;
     for(int i = 0;i < 17;i++)
     {
     NSInteger subStrIndex = [[identityCard substringWithRange:NSMakeRange(i, 1)] integerValue];
     NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
     
     idCardWiSum+= subStrIndex * idCardWiIndex;
     
     }
     
     //计算出校验码所在数组的位置
     NSInteger idCardMod=idCardWiSum%11;
     
     //得到最后一位身份证号码
     NSString * idCardLast= [identityCard substringWithRange:NSMakeRange(17, 1)];
     
     //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
     if(idCardMod==2)
     {
     if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"])
     {
     return flag;
     }else
     {
     flag =  NO;
     return flag;
     }
     }else
     {
     //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
     if([idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]])
     {
     return flag;
     }
     else
     {
     flag =  NO;
     return flag;
     }
     }
     }
     else
     {
     flag =  NO;
     return flag;
     }
     }
     else
     {
     return flag;
     }
     */
}

+ (BOOL)isEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)checkTheName:(NSString *)name{
    NSString *regex = QIUMI_NAMEMOTIFY_USER_REX;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:name];
    return isValid;
}

- (NSString *)decodeURIComponent
{
    NSString *result =
    CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                                              kCFAllocatorDefault,
                                                                              (CFStringRef)self,
                                                                              CFSTR(""),
                                                                              kCFStringEncodingUTF8));
    return result;
}

+ (NSString *)stringFormat:(NSString *)format text:(NSString *)texts, ...{
    return [NSString stringWithFormat:format,texts];
}
@end
