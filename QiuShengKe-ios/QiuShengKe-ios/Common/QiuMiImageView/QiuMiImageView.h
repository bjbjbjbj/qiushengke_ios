//
//  QiuMiImageView.h
//  Qiumi
//
//  Created by xieweijie on 15/4/20.
//  Copyright (c) 2015年 51viper.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OLImageView.h"
typedef void(^QiuMiImageClickFinish)();
@interface QiuMiImageView : UIView
@property(nonatomic, strong)IBOutlet UIButton* button;
@property(nonatomic, strong)IBOutlet OLImageView* imageView;
@property(nonatomic, strong)IBOutlet UIImageView* isGif;
@property(nonatomic, strong)IBOutlet UIView* progress;
@property(nonatomic, copy)QiuMiImageClickFinish clickFinshBlock;
+ (instancetype)viewFromXib;
- (void)loadImageWithString:(NSString*)path withPlaceHoldString:(NSString*)placeHoldString withFinishClick:(QiuMiImageClickFinish)clickFinish;
@end
