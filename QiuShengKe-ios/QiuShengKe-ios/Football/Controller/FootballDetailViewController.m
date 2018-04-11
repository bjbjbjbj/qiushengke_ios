//
//  FootballDetailViewController.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/11.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "FootballDetailViewController.h"

@interface FootballDetailViewController ()
@property(nonatomic, strong)IBOutlet UIView* tabBG;
@property(nonatomic, strong)IBOutlet UIScrollView* content;

@property(nonatomic, strong)IBOutlet QiuMiTabView* tab;
@end

@implementation FootballDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.needToHideNavigationBar = YES;
    [self _setupUI];
}

- (void)_setupUI{
    self.tab = [[QiuMiTabView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44) withCanScroll:NO];
    [_tab setSelectedColor:QIUMI_COLOR_C1];
    [_tab setNormalColor:QIUMI_COLOR_G2];
    [_tab setColumnTitles:@[@"赛况",@"分析",@"指数"]];
    [_tabBG addSubview:_tab];
    
    __weak typeof(self) wself = self;
    _tab.doSelectBlock = ^(NSInteger index){
        CGRect rect = wself.content.frame;
        rect.origin.x = SCREENWIDTH * index;
        [wself.content scrollRectToVisible:rect animated:YES];
    };
    
    for(NSInteger i = 0 ; i < 3 ; i++){
        UIView* view = nil;
        switch (i) {
            case 0:
                view = [[NSBundle mainBundle] loadNibNamed:@"FootDetailBaseView" owner:nil options:nil][0];
                break;
            case 1:
                view = [[NSBundle mainBundle] loadNibNamed:@"FootDetailBaseView" owner:nil options:nil][0];
                break;
            case 2:
                view = [[NSBundle mainBundle] loadNibNamed:@"FootDetailBaseView" owner:nil options:nil][0];
            default:
                break;
        }
        if (view) {
            [view setFrame:CGRectMake(SCREENWIDTH*i, 0, SCREENWIDTH, SCREENHEIGHT - 190 - 44)];
            [_content addSubview:view];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)clickBack:(id)sender{
    [super goBack:sender];
}
@end
