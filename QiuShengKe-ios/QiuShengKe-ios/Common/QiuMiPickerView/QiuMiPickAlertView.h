//
//  QiuMiPickAlertView.h
//  Qiumi
//
//  Created by xieweijie on 16/4/24.
//  Copyright © 2016年 51viper.com. All rights reserved.
//

#import "QiuMiPickerView.h"
typedef void(^PickerConfirm)(NSString * text);

@interface QiuMiPickAlertView : QiuMiPickerView<UIPickerViewDelegate, UIPickerViewDataSource>

+ (instancetype)createWithXib;

@property (nonatomic , strong) IBOutlet UIPickerView* picker;

@property (nonatomic, strong)NSArray* data;

@property (nonatomic , strong)PickerConfirm confirm;
@end
