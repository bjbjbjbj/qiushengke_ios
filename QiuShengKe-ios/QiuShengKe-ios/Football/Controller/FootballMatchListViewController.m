//
//  FootballMatchListViewController.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/10.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "FootballMatchListViewController.h"
#import "FootballMatchTableViewCell.h"
#import "LeagueFilterCollectionViewCell.h"
#import "PlayerViewController.h"
#import "QiuMiDatePickerAlertView.h"
#import "PlayerViewController.h"
#import "AKQLivingView.h"

@interface FootballMatchListViewController ()<UITableViewDelegate, UITableViewDataSource>{
    BOOL _isSelf;
}
@property(nonatomic, strong)NSString* selectDate;
@property(nonatomic, strong)NSArray* matches;
@property(nonatomic, strong)NSArray* date_keys;

@property(nonatomic, strong)UIView* tableHead;
@property(nonatomic, strong)NSMutableArray* headSubs;
@property(nonatomic, strong)NSTimer* timer;
@end

@implementation FootballMatchListViewController
- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.timer invalidate];
    self.timer = nil;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(loadData) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isSelf = false;
    // Do any additional setup after loading the view.
    self.headSubs = [[NSMutableArray alloc] init];
    [self _setupUI];
    [self.tableview setBackgroundColor:QIUMI_COLOR_G5];
}

- (void)_setupUI{
//    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.needToHideNavigationBar = YES;
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH/375*60)];
    UIImageView* bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH/375*60)];
    [bg setImage:[UIImage imageNamed:@"image_bg_live_n"]];
    [view addSubview:bg];
    UIScrollView* sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, view.frame.size.height)];
    [sv setTag:99];
    [sv setShowsHorizontalScrollIndicator:NO];
    [view addSubview:sv];
    [sv setBackgroundColor:[UIColor clearColor]];
    self.tableHead = view;
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

- (void)setTimeStr:(NSString *)timeStr{
    _timeStr = timeStr;
    self.selectDate = timeStr;
}

#pragma mark - load data
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
}

- (void)loadData{
    [self loadDataWithFresh:YES];
    [self loadLivingData];
}

- (void)loadDataWithFresh:(BOOL)isRefresh{
    QiuMiWeakSelf(self);
    [[QiuMiHttpClient instance]GET:AKQ_LIVES_URL parameters:nil cachePolicy:isRefresh?QiuMiHttpClientCachePolicyNoCache:QiuMiHttpClientCachePolicyHttpCache prompt:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QiuMiStrongSelf(self);
        [self.tableview.refresh endRefreshing];
        NSDictionary* matches = [responseObject objectForKey:@"matches"];
        NSMutableArray* result = [[NSMutableArray alloc] init];
        //数据做一次处理
        NSArray* date_keys = [matches allKeys];
        date_keys = [date_keys sortedArrayUsingSelector:@selector(compare:)];
        //日期
        for (NSString* date_key in date_keys) {
            NSMutableArray* tmp = [[NSMutableArray alloc] init];
            NSDictionary* date_matches = [matches objectForKey:date_key];
            NSArray* keys = [date_matches allKeys];
            //日期里面比赛
            for (NSString* key in keys) {
                NSDictionary* match = [date_matches objectForKey:key];
                [tmp addObject:match];
            }
            //排序
            NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES];
            tmp = [tmp sortedArrayUsingDescriptors:@[sd]];
            
            [result addObject:tmp];
        }
        NSArray* r_date_keys = [matches allKeys];
        r_date_keys = [r_date_keys sortedArrayUsingSelector:@selector(compare:)];
        
        self.date_keys = r_date_keys;
        self.matches = result;
        [self.tableview reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableview.refresh endRefreshing];
    }];
}

#pragma mark - table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_matches count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([_matches count] > section){
        return [[_matches objectAtIndex:section] count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* match = nil;
    if ([_matches count] > indexPath.section) {
        NSArray* matches = [_matches objectAtIndex:indexPath.section];
        if([matches count] > indexPath.row){
            match = [matches objectAtIndex:indexPath.row];
        }
    }
    
    FootballMatchTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[match integerForKey:@"sport"] == 3 ?@"FootballMatchTableViewCell2":@"FootballMatchTableViewCell"];
    if(cell == nil){
        cell = [[NSBundle mainBundle] loadNibNamed:@"FootballMatchTableViewCell" owner:nil
                                           options:nil][[match integerForKey:@"sport"] == 3?1:0];
    }
    [cell loadData:match];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_matches count] > indexPath.section) {
        NSArray* matches = [_matches objectAtIndex:indexPath.section];
        if([matches count] > indexPath.row){
            NSDictionary* match = [matches objectAtIndex:indexPath.row];
            PlayerViewController* player = [QSKCommon getPlayerControllerWithMid:[match integerForKey:@"mid"] sport:[match integerForKey:@"sport"]];
            if ([match integerForKey:@"sport"] == 3) {
                [player setNavTitle:[match objectForKey:@"hname"]];
            }
            else{
                [player setNavTitle:[NSString stringWithFormat:@"%@ vs %@",[match objectForKey:@"hname"],[match objectForKey:@"aname"]]];
            }
            [[QiuMiCommonViewController navigationController] pushViewController:player animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [FootballMatchTableViewCell heightOfCell];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
    [view setBackgroundColor:COLOR(242, 242, 242, 1)];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
    [label setTextColor:COLOR(94, 140, 202, 1)];
    [label setFont:[UIFont systemFontOfSize:14]];
    [label setTextAlignment:NSTextAlignmentCenter];
    
    if([_date_keys count] > section){
        [label setText:[_date_keys objectAtIndex:section]];
    }
    [view addSubview:label];
    return view;
}

#pragma mark - load data
- (void)loadLivingData{
    QiuMiWeakSelf(self);
    [[QiuMiHttpClient instance] GET:ANCHOR_LIVING_INDEX cachePolicy:QiuMiHttpClientCachePolicyNoCache success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject integerForKey:@"code"] == 0) {
            QiuMiStrongSelf(self);
            if ([[responseObject objectForKey:@"data"] count] > 0) {
                UIScrollView* sv = (UIScrollView*)[self.tableHead viewWithTag:99];
                [[sv subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
                NSArray* array = [responseObject objectForKey:@"data"];
                for (NSInteger i = 0 ; i < [array count] ; i++) {
                    AKQLivingView* sub = nil;
                    if ([self.headSubs count] > i) {
                        sub = [self.headSubs objectAtIndex:i];
                    }
                    else{
                        sub = [[NSBundle mainBundle] loadNibNamed:@"AKQLivingView" owner:nil options:nil][0];
                        [self.headSubs addObject:sub];
                    }
                    [sub setFrame:CGRectMake(20 + i*(44+15), 0, SCREENWIDTH/375*44, SCREENWIDTH/375*60)];
                    [sub loadData:[array objectAtIndex:i]];
                    [sv addSubview:sub];
                }
                [sv setContentSize:CGSizeMake(25 + [array count]*(44+15), SCREENWIDTH/375*60)];
                self.tableview.tableHeaderView = self.tableHead;
            }
            else{
                self.tableview.tableHeaderView = nil;
            }
            [self.tableview reloadData];
        }
    }];
}
@end

