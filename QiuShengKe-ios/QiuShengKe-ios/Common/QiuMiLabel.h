//
//  QiuMiLabel.h
//  Qiumi
//
//  Created by Viper on 16/1/20.
//  Copyright © 2016年 51viper.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QiuMiLabel : UILabel

@property (nonatomic, assign) BOOL isBlue;
@property (nonatomic, assign) BOOL isOranger;
@property (nonatomic, assign) BOOL isGreen;
@property (nonatomic, assign) BOOL isRed;
@property (nonatomic, assign) BOOL isTitle;
@property (nonatomic, assign) BOOL isSectionTitle;

@property (nonatomic, assign) BOOL qiumiFix;
@property (nonatomic, assign) NSString* qiumiColor;
@property (nonatomic, assign) NSString* qiumiColorBG;
@end
