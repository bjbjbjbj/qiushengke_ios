//
//  ChatCreateViewController.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/26.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "ChatCreateViewController.h"

@interface ChatCreateViewController ()
@property(nonatomic, strong)IBOutlet UITextField* content;
@property(nonatomic, strong)IBOutlet UITextField* nickname;
@end

@implementation ChatCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self useDefaultRight:@"发表"];
    [self useDefaultBack];
    [self.view setBackgroundColor:QIUMI_COLOR_G5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickBarRight:(UIButton *)btn{
    if (_nickname.text.length == 0 || _content.text.length ==0) {
        [QiuMiPromptView showText:@"昵称、内容不能为空"];
        return;
    }
    NSString* url = @"http://www.qiushengke.com/chat/post";
    NSDictionary* params = @{
                             @"user":_nickname.text,
                             @"message":_content.text,
                             @"sport":[NSNumber numberWithInteger:_sport],
                             @"mid":[NSNumber numberWithInteger:_mid],
                             };
    [[QiuMiHttpClient instance] POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[QiuMiCommonViewController navigationController] popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [QiuMiPromptView showText:@"发送失败"];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
