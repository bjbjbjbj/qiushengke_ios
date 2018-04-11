//
//  QiuMiCommonWebViewController.h
//  Qiumi
//
//  Created by xieweijie on 14-12-15.
//  Copyright (c) 2014年 51viper.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QiuMiCommonWebViewController : QiuMiCommonViewController
@property(nonatomic, strong)IBOutlet UIWebView* webView;
@property(nonatomic, strong)NSString* url;
@property(nonatomic, strong)NSString* navText;
@end
