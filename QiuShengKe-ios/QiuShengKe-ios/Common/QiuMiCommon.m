//
//  QiuMiCommon.m
//  Qiumi
//
//  Created by xieweijie on 15-1-7.
//  Copyright (c) 2015年 51viper.com. All rights reserved.
//

#import "QiuMiCommon.h"
#import "OLImage.h"

#import "NSString+Qiumi.h"
#import "Reachability.h"
#import "DownLoadOperation.h"

#define QIUMI_HISTORY_COUNT 10

@interface QiuMiCommon()
@property(nonatomic, strong)NSMutableDictionary* hadLoadControllers;
@property(nonatomic, strong)NSDate* inBackgroundTime;
@property(nonatomic, strong)NSDate* becomeActivieTime;
@property(nonatomic, strong)Reachability* reach;
@end

static NSString* _token;
static NSString* _domain;
@implementation QiuMiCommon
- (NSString *)kefu{
    if ([_kefu length] == 0) {
        return @"liaogoukefu";
    }
    return _kefu;
}

- (BOOL)useAli{
    if (_isInReview) {
        return NO;
    }
    return _useAli;
}

- (NSString *)helpUrl{
    if ([_helpUrl length] == 0) {
        return @"https://shop.liaogou168.com/feedback";
    }
    return _helpUrl;
}

+ (NSString *)appendUDIDandToken:(NSString *)string{
    NSString *url = string;
    if ([OpenUDID value]) {//增加UDID
        url = [NSString stringWithFormat:@"%@&udid=%@",url,[OpenUDID value]];
    }
    return url;
}

//判断两个日期是否是同一天
+(BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

+ (NSString *)transformDateTime:(NSTimeInterval)time
{
    NSString* formate1 = @"yyyy-MM-dd";
    NSString* formate2 = @"HH:mm";
    NSString* formate3 = @"MM-dd HH:mm";
    NSDate *now = [NSDate date];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSTimeInterval dateDif = [now timeIntervalSinceDate:date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:formate1];
    BOOL isToday = NO;
    BOOL isYesterday = NO;
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *yesterday;
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[formatter stringFromDate:today] substringToIndex:10];
    NSString * yesterdayString = [[formatter stringFromDate:yesterday] substringToIndex:10];
    NSString * dateString = [[formatter stringFromDate:date] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        isToday = YES;
    } else if ([dateString isEqualToString:yesterdayString])
    {
        isYesterday = YES;
    }
    
    /*
     0～1分钟：刚刚
     1分钟～1小时：X分钟前（X表示分钟数）
     1小时～当天结束：HH：MM（H表示小时，M表示分钟，发帖时间）
     1天～2天内：昨天HH：MM
     2天后：X月X日 HH：MM
     */
    if (dateDif < 60)
    {
        return !isToday ? @"昨天" : @"刚刚";
    }
    else if (dateDif < 3600) {
        NSInteger minute = dateDif / 60;
        return [NSString stringWithFormat:@"%@分钟前", @(minute)];
    }
    if(isToday)
    {
        [formatter setDateFormat:formate2];
        NSString *formatterStr = [formatter stringFromDate:date];
        return formatterStr;
    }
    else
    {
        if (isYesterday) {
            formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:formate2];
            NSString *formatterStr = [formatter stringFromDate:date];
            return [NSString stringWithFormat:@"昨天 %@",formatterStr];
        }
        else
        {
            formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:formate3];
            NSString *formatterStr = [formatter stringFromDate:date];
            return formatterStr;
        }
    }
}

#pragma mark - 单例
+ (QiuMiCommon*)instance
{
    static QiuMiCommon* _current;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _current = [[QiuMiCommon alloc] init];
        _current.hadLoadControllers = [[NSMutableDictionary alloc]init];
    });
    return _current;
}

- (BOOL)isAfterLastTime:(NSString*)controllerName withSecond:(NSInteger)second
{
    if (_becomeActivieTime == nil || _inBackgroundTime == nil) {
        return NO;
    }
    NSInteger seconds = [_becomeActivieTime timeIntervalSinceDate:_inBackgroundTime];
    if (seconds > second && [self.hadLoadControllers objectForKey:controllerName] == nil) {
        [self.hadLoadControllers setObject:@"1" forKey:controllerName];
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)updateLastBecomeActiveTime
{
    self.becomeActivieTime = [NSDate date];
}

- (void)updateLastInBackgroundTime
{
    self.inBackgroundTime = [NSDate date];
    [self.hadLoadControllers removeAllObjects];
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIFont*)systemLightFontWithSize:(float)fontSize
{
    if (IOS_VERSION >= 8.2) {
        return [UIFont systemFontOfSize:fontSize weight:UIFontWeightLight];
    }
    else{
        return [UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize];
    }
}

+ (BOOL)checkThePhotoInCacheWithPath:(NSString *)path{
    path = [path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([path rangeOfString:@"emoji_"].location != NSNotFound) {
        return [QiuMiCommon existEmoji:path];
    }else{
        NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:path]];
        NSData *lastPreviousCachedImage = [[SDImageCache sharedImageCache] diskImageDataBySearchingAllPathsForKey:key];
        if (lastPreviousCachedImage) {
            return YES;
        }else{
            return NO;
        }
    }
    return NO;
}

//计算年龄
+ (NSString *)calculationAge:(NSString *)date{
    NSString * year = [[date componentsSeparatedByString:@"-"] objectAtIndex:0];
    NSDate * nowdate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *customDateFormatter = [[NSDateFormatter alloc] init];
    [customDateFormatter setDateFormat:@"yyyy"];
    NSString * nowYear = [customDateFormatter stringFromDate:nowdate];
    NSNumber * age = [NSNumber numberWithInteger:([nowYear integerValue] - [year integerValue])];
    return [age stringValue];
}
//根据衣服类型返回衣服名字
+ (NSString *)whitchClothes:(NSString *)clothes{
    if ([clothes compare:@"GK"] == NSOrderedSame) {
        return @"icon_imformation_clothes_blue.png";
    }else if ([clothes compare:@"FW"] == NSOrderedSame){
        return @"icon_imformation_clothes_red.png";
    }else if ([clothes compare:@"DF"] == NSOrderedSame){
        return @"icon_imformation_clothes_green.png";
    }else if ([clothes compare:@"MD"] == NSOrderedSame){
        return @"icon_imformation_clothes_yellow.png";
    }else{
        return @"icon_imformation_clothes_grey.png";
    }
}
//根据衣服类型返回type
+ (NSInteger)whitchClothesType:(NSString *)clothes{
    if ([clothes compare:@"FW"] == NSOrderedSame) {
        return 0;
    }else if ([clothes compare:@"MD"] == NSOrderedSame){
        return 1;
    }else if ([clothes compare:@"DF"] == NSOrderedSame){
        return 2;
    }else if ([clothes compare:@"GK"] == NSOrderedSame){
        return 3;
    }else{
        return 4;
    }
}

#pragma mark - photo process
- (BOOL)isWifi
{
    if (nil == _reach) {
        self.reach = [Reachability reachabilityForInternetConnection];
    }
    return [_reach isReachableViaWiFi];
}

+ (void)targetImage:(UIImage *)targetImage withFilterName:(QiuMiFilterEffect)filterName FinishCallbackBlock:(void (^)(UIImage *))block{
    if (filterName == QiumiCIPhotoEffectNone) {
        if (block) {
            block(targetImage);
        }
        return;
    }
    NSString * imageFilterName = [self getFilterNameByEnum:filterName];
    //将UIImage转换成CIImage
    CIImage *ciImage = [[CIImage alloc] initWithImage:targetImage];
    //创建滤镜
    CIFilter *filter = [CIFilter filterWithName:imageFilterName keysAndValues:kCIInputImageKey, ciImage, nil];
    //已有的值不改变，其他的设为默认值
    [filter setDefaults];
    //获取绘制上下文
    CIContext *context = [CIContext contextWithOptions:nil];
    //渲染并输出CIImage
    CIImage *outputImage = [filter outputImage];
    //创建CGImage句柄
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    //获取图片
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    //释放CGImage句柄
    CGImageRelease(cgImage);
    if (block) {
        block(image);
    }
}

+ (NSString*)getFilterNameByEnum:(QiuMiFilterEffect) filterName
{
    NSString * imageFilterName = @"";
    switch (filterName) {
        case QiuMiCIPhotoEffectInstant:
            imageFilterName = @"CIPhotoEffectInstant";  //怀旧
            break;
        case QiuMiCIPhotoEffectNoir:
            imageFilterName = @"CIPhotoEffectNoir";     //黑白
            break;
        case QiuMiCIPhotoEffectTonal:
            imageFilterName = @"CIPhotoEffectTonal";    //色调
            break;
        case QiuMiCIPhotoEffectTransfer:
            imageFilterName = @"CIPhotoEffectTransfer"; //岁月
            break;
        case QiuMiCIPhotoEffectMono:
            imageFilterName = @"CIPhotoEffectMono";     //单色
            break;
        case QiuMiCIPhotoEffectFade:
            imageFilterName = @"CIPhotoEffectFade";     //褪色
            break;
        case QiuMiCIPhotoEffectProcess:
            imageFilterName = @"CIPhotoEffectProcess";  //冲印
            break;
        case QiuMiCIPhotoEffectChrome:
            imageFilterName = @"CIPhotoEffectChrome";   //珞黄
        default:
            break;
    }
    return imageFilterName;
}

+ (NSMutableAttributedString *)attributedWithColor:(UIColor *)color withFont:(UIFont *)font withRange:(NSRange)range withString:(NSString *)string{
    NSMutableAttributedString * text = [[NSMutableAttributedString alloc]initWithString:string];
    [text addAttribute:NSForegroundColorAttributeName value:color range:range];
    [text addAttribute:NSFontAttributeName value:font range:range];
    return text;
}
@end
