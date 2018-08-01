//
//  AKQLivingView.h
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/8/1.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKQLivingView : UIView
@property(nonatomic, strong)IBOutlet UIImageView* icon;
@property(nonatomic, strong)IBOutlet UILabel* text;

- (void)loadData:(NSDictionary*)data;
@end
