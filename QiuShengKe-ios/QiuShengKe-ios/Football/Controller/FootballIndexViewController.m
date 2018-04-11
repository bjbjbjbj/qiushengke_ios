//
//  FootballIndexViewController.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/10.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "FootballIndexViewController.h"
#import "FootballMatchListViewController.h"

@interface FootballIndexViewController ()
@property(nonatomic, strong)IBOutlet UIView* tabBG;
@property(nonatomic, strong)IBOutlet UIScrollView* contentView;

@property(nonatomic, strong)QiuMiTabView* tabView;
@property(nonatomic, strong)NSMutableArray* controllers;
@end

@implementation FootballIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.needToHideNavigationBar = YES;
    self.controllers = [[NSMutableArray alloc] init];
    [self _setupUI];
    [self loadData:0];
}

- (void)_setupUI{
    [_contentView setDelegate:self];
    
    self.tabView = [[QiuMiTabView alloc]initWithFrame:CGRectMake(0, 20, SCREENWIDTH, 44) withCanScroll:NO];
    [_tabView setSelectedColor:QIUMI_COLOR_G7];
    [_tabView setNormalColor:COLOR(234, 234, 234, 1)];
    [_tabView setLineColor:QIUMI_COLOR_G7];
    [_tabView setColumnTitles:@[@"即时比分",@"完场赛果",@"未来赛程"]];
    [_tabBG addSubview:_tabView];
    
    [_contentView setContentSize:CGSizeMake(SCREENWIDTH*3, SCREENHEIGHT - _tabBG.frame.size.height - self.tabBarController.tabBar.frame.size.height)];
    
    __weak typeof(self) wself = self;
    _tabView.doSelectBlock = ^(NSInteger index){
        CGRect rect = wself.contentView.frame;
        rect.origin.x = SCREENWIDTH * index;
        [wself.contentView scrollRectToVisible:rect animated:YES];
        [wself loadData:index];
    };
    
    for(NSInteger i = 0 ; i < 3 ; i++){
        FootballMatchListViewController* controller = (FootballMatchListViewController*)[QiuMiCommonViewController controllerWithStoryBoardName:@"Football" withControllerName:@"FootballMatchListViewController"];
        [self.controllers addObject:controller];
        switch (i) {
                case 0:
                [controller setTimeStr:[self getCurrentTime]];
                break;
                case 1:
                [controller setTimeStr:[self GetYesterDay:[NSDate date]]];
                break;
                case 2:
                [controller setTimeStr:[self GetTomorrowDay:[NSDate date]]];
            default:
                break;
        }
        [controller.view setFrame:CGRectMake(SCREENWIDTH*i, 0, SCREENWIDTH, SCREENHEIGHT - _tabBG.frame.size.height)];
        [_contentView addSubview:controller.view];
    }
}

//获取当地时间
- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

//传入今天的时间，返回明天的时间
- (NSString *)GetYesterDay:(NSDate *)aDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
    [components setDay:([components day]-1)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"yyyyMMdd"];
    return [dateday stringFromDate:beginningOfWeek];
}

//传入今天的时间，返回明天的时间
- (NSString *)GetTomorrowDay:(NSDate *)aDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
    [components setDay:([components day]+1)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"yyyyMMdd"];
    return [dateday stringFromDate:beginningOfWeek];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData:(NSInteger)index{
    for (NSInteger i = 0; i < [_controllers count]; i++) {
        if (index == i) {
            [[_controllers objectAtIndex:i] performSelector:@selector(loadData) withObject:nil];
        }
    }
}

#pragma mark - scrollview
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _contentView) {
        [_tabView contentScrollPositionX:scrollView.contentOffset.x withContentWidth:scrollView.contentSize.width];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _contentView) {
        NSInteger index = scrollView.contentOffset.x/SCREENWIDTH;
        [self loadData:index];
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

@end

