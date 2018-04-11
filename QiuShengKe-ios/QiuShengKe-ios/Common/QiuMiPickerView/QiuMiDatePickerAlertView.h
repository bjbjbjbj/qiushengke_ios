//
//  QiuMiDatePickerAlertView.h
//  Qiumi
//
//  Created by Viper on 16/1/11.
//  Copyright © 2016年 51viper.com. All rights reserved.
//

#import "QiuMiPickerView.h"

//选中
typedef void(^DateTime)(NSDate * time);

@interface QiuMiDatePickerAlertView : QiuMiPickerView
//0 ymd-hm 1 ymd 2 hm
+ (instancetype)createWithXib:(NSInteger)type;

@property (nonatomic , strong) IBOutlet UIDatePicker * datePicker;

@property (nonatomic , strong) DateTime dateTime;

- (void)selectTimeWithDate:(NSDate *)date;

@end
