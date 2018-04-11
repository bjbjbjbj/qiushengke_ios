//
//  QiuMiActivityWebViewController.h
//  Qiumi
//
//  Created by xieweijie on 15/7/2.
//  Copyright (c) 2015年 51viper.com. All rights reserved.
//

#import "QiuMiCommonViewController.h"

@interface QiuMiActivityWebViewController : QiuMiCommonViewController

@property(nonatomic, strong)IBOutlet UIWebView* webView;
@property(nonatomic, strong)NSString* url;
@property(nonatomic, strong)NSString* shareUrl;
//是否user进入
@property(nonatomic, assign)BOOL isUser;

@end
