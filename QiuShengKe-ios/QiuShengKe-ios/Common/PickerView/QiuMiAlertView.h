//
//  QiuMiAlertView.h
//  Qiumi
//
//  Created by xieweijie on 16/1/4.
//  Copyright © 2016年 51viper.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^QiuMiAlertViewHideBlock)();

@interface QiuMiAlertView : UIView
@property (nonatomic , weak) IBOutlet UIImageView * bgImage;
@property (nonatomic , weak) IBOutlet UIView * bgView;
@property (nonatomic , weak) IBOutlet UIView * alertView;
@property (nonatomic , weak) IBOutlet UIButton* closeBtn;
@property (nonatomic , strong) QiuMiAlertViewHideBlock hideBlock;

- (void)showAlert;
- (IBAction)hideAlert;
@end
