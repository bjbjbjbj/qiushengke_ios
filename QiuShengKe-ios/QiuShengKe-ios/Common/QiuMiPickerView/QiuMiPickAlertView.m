//
//  QiuMiPickAlertView.m
//  Qiumi
//
//  Created by xieweijie on 16/4/24.
//  Copyright © 2016年 51viper.com. All rights reserved.
//

#import "QiuMiPickAlertView.h"

@implementation QiuMiPickAlertView

+ (instancetype)createWithXib{
    return [[NSBundle mainBundle] loadNibNamed:@"QiuMiPickAlertView" owner:self options:nil][0];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.alertView setTag:1];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    CGPoint touchPoint = [touch locationInView:self];
    return !CGRectContainsPoint([self viewWithTag:1].frame, touchPoint);
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_data objectAtIndex:row];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_data count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_confirm) {
        self.confirm([_data objectAtIndex:row]);
    }
}

- (void)hideAlert
{
    if (_confirm) {
        self.confirm([_data objectAtIndex:[_picker selectedRowInComponent:0]]);
    }
    [super hideAlert];
}

- (void)setData:(NSArray *)data
{
    _data = [data copy];
    [_picker reloadAllComponents];
}
@end
