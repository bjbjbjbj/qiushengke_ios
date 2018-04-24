//
//  MyViewController.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/24.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "MyViewController.h"

@interface MyViewController ()
@property(nonatomic, strong)IBOutlet UISwitch* switch1;
@property(nonatomic, strong)IBOutlet UISwitch* switch2;
@property(nonatomic, strong)IBOutlet UISwitch* switch3;
@property(nonatomic, strong)IBOutlet UISwitch* switch4;
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.needToHideNavigationBar = YES;
    NSMutableDictionary* tmp = [[NSMutableDictionary alloc] initWithStore:@"push"];
    if ([tmp objectForKey:@"1"]) {
        [_switch1 setOn:NO];
    }
    else{
        [_switch1 setOn:YES];
    }
    if ([tmp objectForKey:@"2"]) {
        [_switch2 setOn:NO];
    }
    else{
        [_switch2 setOn:YES];
    }
    if ([tmp objectForKey:@"3"]) {
        [_switch3 setOn:NO];
    }
    else{
        [_switch3 setOn:YES];
    }
    if ([tmp objectForKey:@"4"]) {
        [_switch4 setOn:NO];
    }
    else{
        [_switch4 setOn:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickSwitch:(UISwitch*)sender{
    NSString* key = [[NSNumber numberWithInteger:sender.tag] stringValue];
    NSMutableDictionary* tmp = [[NSMutableDictionary alloc] initWithStore:@"push"];
    if (sender.isOn) {
        [tmp removeObjectForKey:key];
    }
    else{
        [tmp setObject:@"1" forKey:key];
    }
    [tmp writeToStore:@"push"];
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
