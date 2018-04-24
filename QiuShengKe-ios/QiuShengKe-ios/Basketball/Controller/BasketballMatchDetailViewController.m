//
//  BasketballMatchDetailViewController.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/18.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "BasketballMatchDetailViewController.h"
#import "BasketDetailBaseView.h"
#import "FootDetailOddView.h"
#import "FootDetailAnalyseView.h"

@interface BasketballMatchDetailViewController ()<UIScrollViewDelegate>
@property(nonatomic, strong)IBOutlet UIView* tabBG;
@property(nonatomic, strong)IBOutlet UIScrollView* content;

@property(nonatomic, strong)IBOutlet UILabel* nav;
@property(nonatomic, strong)IBOutlet UIImageView* hicon;
@property(nonatomic, strong)IBOutlet UIImageView* aicon;
@property(nonatomic, strong)IBOutlet UILabel* hname;
@property(nonatomic, strong)IBOutlet UILabel* aname;
@property(nonatomic, strong)IBOutlet UILabel* hrank;
@property(nonatomic, strong)IBOutlet UILabel* arank;
@property(nonatomic, strong)IBOutlet UILabel* score;
@property(nonatomic, strong)IBOutlet UILabel* time;

@property(nonatomic, strong)IBOutlet QiuMiTabView* tab;
@property(nonatomic, strong)NSMutableArray* views;
@property(nonatomic, strong)NSDictionary* match;
@end

@implementation BasketballMatchDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.needToHideNavigationBar = YES;
    self.views = [[NSMutableArray alloc] init];
    [self _setupUI];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_setupBtn{
    [_liveBtn setHidden:NO];
    [_liveBtn setTitle:@"预约" forState:UIControlStateNormal];
    NSMutableDictionary* tmp = [[NSMutableDictionary alloc] initWithStore:@"test"];
    if ([tmp objectForKey:[[NSNumber numberWithInteger:_mid] stringValue]]) {
        [_liveBtn setTitle:@"取消预约" forState:UIControlStateNormal];
    }
}

- (void)_setupUI{
    if (_hasLive) {
        [_liveBtn setHidden:NO];
    }
    else{
        [_liveBtn setHidden:YES];
    }
    if (_afterInReview) {
        
    }
    else{
        [self _setupBtn];
    }
    
    QiuMiViewBorder(_liveBtn, 2, 0, QIUMI_COLOR_C1);
    [_content setDelegate:self];
    QiuMiViewBorder(_hicon, _hicon.frame.size.height/2, 0, [UIColor clearColor]);
    QiuMiViewBorder(_aicon, _aicon.frame.size.height/2, 0, [UIColor clearColor]);
    [_content setContentSize:CGSizeMake(SCREENWIDTH*3, SCREENHEIGHT - 190 - 44)];
    self.tab = [[QiuMiTabView alloc] initWithFrame:CGRectMake(0, 2, SCREENWIDTH, 40) withCanScroll:NO];
    [_tab setSelectedColor:QIUMI_COLOR_C1];
    [_tab setNormalColor:QIUMI_COLOR_G2];
    [_tab setColumnTitles:@[@"分析",@"赛况",@"指数"]];
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
            case 1:
                view = [[NSBundle mainBundle] loadNibNamed:@"BasketDetailBaseView" owner:nil options:nil][0];
                [self.views addObject:view];
                [(BasketDetailBaseView*)view setMid:_mid];
                [(BasketDetailBaseView*)view setMatch:_match];
                [(BasketDetailBaseView*)view loadData];
                break;
            case 2:
                view = [[NSBundle mainBundle] loadNibNamed:@"FootDetailOddView" owner:nil options:nil][0];
                [self.views addObject:view];
                [(FootDetailOddView*)view setMid:_mid];
                [(FootDetailOddView*)view setSport:2];
                [(FootDetailOddView*)view loadData];
                break;
            case 0:
                view = [[NSBundle mainBundle] loadNibNamed:@"FootDetailAnalyseView" owner:nil options:nil][0];
                [self.views addObject:view];
                [(FootDetailAnalyseView*)view setMid:_mid];
                [(FootDetailAnalyseView*)view setSport:2];
                [(FootDetailAnalyseView*)view loadData];
            default:
                break;
        }
        if (view) {
            [view setFrame:CGRectMake(SCREENWIDTH*i, 0, SCREENWIDTH, SCREENHEIGHT - 190 - 44)];
            [_content addSubview:view];
        }
    }
}

- (void)loadData{
    NSString* url = [NSString stringWithFormat:QSK_MATCH_BASKET_DETAIL,[QSKCommon paramWithMid:_mid]];
    QiuMiWeakSelf(self);
    [[QiuMiHttpClient instance] GET:url parameters:nil cachePolicy:QiuMiHttpClientCachePolicyHttpCache success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QiuMiStrongSelf(self);
        [self reloadMatch:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)reloadMatch:(NSDictionary*)match{
    self.match = match;
    [(BasketDetailBaseView*)[self.views objectAtIndex:0] setMatch:_match];
    [[(BasketDetailBaseView*)[self.views objectAtIndex:0] tableview] reloadData];
    [(FootDetailAnalyseView*)[self.views objectAtIndex:1] setMatch:_match];
    [[(FootDetailAnalyseView*)[self.views objectAtIndex:1] tableview] reloadData];
    
    [self.hname setText:[match objectForKey:@"hname"]];
    [self.aname setText:[match objectForKey:@"aname"]];
    [_hicon qiumi_setImageWithURLString:[match stringForKey:@"hicon"] withHoldPlace:QIUMI_DEFAULT_IMAGE];
    [_aicon qiumi_setImageWithURLString:[match stringForKey:@"aicon"] withHoldPlace:QIUMI_DEFAULT_IMAGE];
    if ([match integerForKey:@"round"] > 0) {
        [_nav setText:[NSString stringWithFormat:@"%@ 第%ld轮",[match objectForKey:@"league"],[match integerForKey:@"round"]]];
    }
    else{
        [_nav setText:[match objectForKey:@"league"]];
    }
    if ([match integerForKey:@"status"] >= 0 || [match integerForKey:@"status"] == -1) {
        [_score setText:[NSString stringWithFormat:@"%ld - %ld",[match integerForKey:@"hscore"],[match integerForKey:@"ascore"]]];
        [_time setText:[match stringForKey:@"current_time"]];
    }
    else{
        [_score setText:@"VS"];
        [_time setText:[NSDate stringWithFormat:@"HH:mm" withTime:[[match objectForKey:@"time"] longLongValue]]];
    }
    
    [_hrank setHidden:YES];
    [_arank setHidden:YES];
    if ([match integerForKey:@"hrank"] > 0) {
        [_hrank setHidden:NO];
        [_hrank setText:[NSString stringWithFormat:@"排名：%ld",[match integerForKey:@"hrank"]]];
    }
    if ([match integerForKey:@"arank"] > 0) {
        [_arank setHidden:NO];
        [_arank setText:[NSString stringWithFormat:@"排名：%ld",[match integerForKey:@"arank"]]];
    }
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



#pragma mark - scrollview
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _content) {
        [_tab contentScrollPositionX:scrollView.contentOffset.x withContentWidth:scrollView.contentSize.width];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _content) {
        //        NSInteger index = scrollView.contentOffset.x/SCREENWIDTH;
        //        [self loadData:index];
    }
}

- (IBAction)clicklive:(id)sender{
    if (!_afterInReview) {
        [_liveBtn setHidden:NO];
        [_liveBtn setTitle:@"预约" forState:UIControlStateNormal];
        NSMutableDictionary* tmp = [[NSMutableDictionary alloc] initWithStore:@"test"];
        if ([tmp objectForKey:[[NSNumber numberWithInteger:_mid] stringValue]]) {
            [tmp removeObjectForKey:[[NSNumber numberWithInteger:_mid] stringValue]];
            [_liveBtn setTitle:@"预约" forState:UIControlStateNormal];
            [QiuMiPromptView showText:@"取消预约"];
        }
        else{
            [tmp setObject:@"1" forKey:[[NSNumber numberWithInteger:_mid] stringValue]];
            [_liveBtn setTitle:@"取消预约" forState:UIControlStateNormal];
            [QiuMiPromptView showText:@"预约成功"];
        }
        [tmp writeToStore:@"test"];
        return;
    }
    QiuMiCommonViewController* player = [QSKCommon getPlayerControllerWithMid:_mid sport:1];
    [[QiuMiCommonViewController navigationController] pushViewController:player animated:YES];
}
@end
