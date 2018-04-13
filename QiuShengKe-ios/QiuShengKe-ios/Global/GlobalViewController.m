//
//  GlobalViewController.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/13.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "GlobalViewController.h"
#import "FootballMatchTableViewCell.h"

@interface GlobalViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)IBOutlet UIView* tabBG;
@property(nonatomic, strong)IBOutlet UITableView* table;

@property(nonatomic, strong)QiuMiTabView* tab;
@property(nonatomic, strong)NSMutableArray* data;
@end

@implementation GlobalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.data = [[NSMutableArray alloc] init];
    [self _setupUI];
    [self loadData];
}

- (void)_setupUI{
    self.title  = @"世界杯赛程";
    self.tab = [[QiuMiTabView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44) withCanScroll:YES];
    [_tab setSelectedColor:QIUMI_COLOR_C1];
    [_tab setNormalColor:QIUMI_COLOR_G2];
    [_tabBG addSubview:_tab];
    [self.tab setColumnTitles:@[@"A组",@"B组",@"C组",@"D组",@"E组",@"F组",@"G组",@"H组"]];
    QiuMiWeakSelf(self);
    [self.tab setDoSelectBlock:^(NSInteger selectIdx) {
        QiuMiStrongSelf(self);
        [self.table reloadData];
    }];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [FootballMatchTableViewCell heightOfCell];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FootballMatchTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FootballMatchTableViewCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"FootballMatchTableViewCell" owner:nil options:nil][0];
    }
    if ([_data count] > _tab.currentIndex) {
        if ([[[_data objectAtIndex:_tab.currentIndex] objectForKey:@"matches"] count] > indexPath.row) {
            NSDictionary* tmp = [[[_data objectAtIndex:_tab.currentIndex] objectForKey:@"matches"] objectAtIndex:indexPath.row];
            [cell loadData:tmp];
            [cell.league setText:[NSDate stringWithFormat:@"MM-dd" withTime:[[tmp objectForKey:@"time"] longLongValue]]];
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_data count] > _tab.currentIndex) {
        return [[[_data objectAtIndex:_tab.currentIndex] objectForKey:@"matches"] count];
    }
    return 0;
}

- (void)loadData{
    QiuMiWeakSelf(self);
    [[QiuMiHttpClient instance] GET:@"http://match.qiushengke.com/static/league/1/564.json" parameters:nil cachePolicy:QiuMiHttpClientCachePolicyHttpCache success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QiuMiStrongSelf(self);
        [self.data removeAllObjects];
        if ([responseObject objectForKey:@"stages"]) {
            NSDictionary* o = [[[responseObject objectForKey:@"stages"] objectAtIndex:0] objectForKey:@"groupMatch"];
            for (NSString* key in o) {
                [self.data addObject:[o objectForKey:key]];
            }
        }
        [_table reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
@end
