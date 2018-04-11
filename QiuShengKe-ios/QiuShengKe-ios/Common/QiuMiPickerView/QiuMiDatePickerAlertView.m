//
//  QiuMiDatePickerAlertView.m
//  Qiumi
//
//  Created by Viper on 16/1/11.
//  Copyright © 2016年 51viper.com. All rights reserved.
//

#import "QiuMiDatePickerAlertView.h"
@interface QiuMiDatePickerAlertView()
@property (nonatomic , assign) NSInteger type;
@end
@implementation QiuMiDatePickerAlertView

+ (instancetype)createWithXib:(NSInteger)type{
    QiuMiDatePickerAlertView* picker = [[NSBundle mainBundle] loadNibNamed:@"QiuMiDatePickerAlertView" owner:self options:nil][0];
    picker.type = type;
    switch (type) {
        case 0:
            picker.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
            break;
        case 1:
            picker.datePicker.datePickerMode = UIDatePickerModeDate;
            break;
        case 2:
            picker.datePicker.datePickerMode = UIDatePickerModeTime;
            break;
        default:
            picker.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
            break;
    }
    return picker;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    self.datePicker.hidden = NO;
    self.datePicker.date = [NSDate date];
    //响应日期选择事件，自定义dateChanged方法
    [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)selectTimeWithDate:(NSDate *)date{
    if (date) {
        [self.datePicker setDate:date];
    }
}

-(void)dateChanged:(id)sender{
    UIDatePicker *control = (UIDatePicker*)sender;
    NSDate* _date = control.date;
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    switch (_type) {
        case 0:
            [formate setDateFormat:@"yyyy-MM-dd HH:mm"];
            break;
        case 1:
            [formate setDateFormat:@"yyyy年MM月dd日"];
            break;
        case 2:
            [formate setDateFormat:@"HH:mm"];
            break;
        default:
            [formate setDateFormat:@"yyyy-MM-dd HH:mm"];
            break;
    }
    if (self.dateTime) {
        self.dateTime(_date);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
