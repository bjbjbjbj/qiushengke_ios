//
//  FootballMatchListViewController.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/10.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "FootballMatchListViewController.h"
#import "FootballDetailViewController.h"
#import "FootballMatchTableViewCell.h"
#import "LeagueFilterCollectionViewCell.h"
#import "PlayerViewController.h"

@interface FootballMatchListViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate,UICollectionViewDataSource>{
    BOOL _isSelf;
}
@property(nonatomic, strong)IBOutlet UITableView* tableView;
@property(nonatomic, strong)IBOutlet UIButton* leagueBtn;
@property(nonatomic, strong)IBOutlet UIButton* oddBtn;
@property(nonatomic, strong)IBOutlet UILabel* tips;
@property(nonatomic, strong)IBOutlet UICollectionView* collectionView;

@property(nonatomic, strong)IBOutlet UIButton* filterBtn1;
@property(nonatomic, strong)IBOutlet UIButton* filterBtn2;
@property(nonatomic, strong)IBOutlet UIButton* filterBtn3;
@property(nonatomic, strong)IBOutlet UIButton* filterBtn4;

@property(nonatomic, strong)NSArray* matches;
@property(nonatomic, strong)NSMutableArray* showMatches;

@property(nonatomic, strong)NSMutableArray* firstLids;
@property(nonatomic, strong)NSMutableArray* selfLids;

@property(nonatomic, strong)NSDictionary* firstF;
@property(nonatomic, strong)NSDictionary* lotteryF;
@property(nonatomic, strong)NSDictionary* allF;
@property(nonatomic, strong)NSDictionary* selfF;
@property(nonatomic, strong)NSDictionary* currentF;
@end

@implementation FootballMatchListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isSelf = false;
    // Do any additional setup after loading the view.
    self.showMatches = [[NSMutableArray alloc] init];
    self.firstLids = [[NSMutableArray alloc] init];
    self.selfLids = [[NSMutableArray alloc] init];
    [self _setupUI];
    [self.tableView setBackgroundColor:QIUMI_COLOR_G5];
}

- (void)_setupUI{
    [[_collectionView superview] setHidden:YES];
    [_filterBtn2 setTitleColor:COLOR(158, 158, 158, 1) forState:UIControlStateNormal];
    [_filterBtn3 setTitleColor:COLOR(158, 158, 158, 1) forState:UIControlStateNormal];
    [_filterBtn4 setTitleColor:COLOR(158, 158, 158, 1) forState:UIControlStateNormal];
    [_collectionView setBackgroundColor:QIUMI_COLOR_G5];
    UINib *cellNib = [UINib nibWithNibName:@"LeagueFilterCollectionViewCell" bundle:nil];
    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"LeagueFilterCollectionViewCell"];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.needToHideNavigationBar = YES;
    _leagueBtn.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    _leagueBtn.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    _leagueBtn.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    
    _oddBtn.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    _oddBtn.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    _oddBtn.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
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

#pragma mark - load data
- (void)loadData{
    QiuMiWeakSelf(self);
    [[QiuMiHttpClient instance]GET:[NSString stringWithFormat:QSK_MATCH_FOOT_LIST,_timeStr] parameters:nil cachePolicy:QiuMiHttpClientCachePolicyHttpCache prompt:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QiuMiStrongSelf(self);
        self.matches = [responseObject objectForKey:@"matches"];
        NSArray* filters = [responseObject objectForKey:@"filter"];
        for (NSDictionary* filter in filters) {
            if([[filter objectForKey:@"type"] isEqualToString:@"all"]){
                for (NSDictionary* data in [filter objectForKey:@"data"]) {
                    [self.selfLids addObject:[data objectForKey:@"id"]];
                }
            }
            if([[filter objectForKey:@"type"] isEqualToString:@"first"]){
                for (NSDictionary* data in [filter objectForKey:@"data"]) {
                    [self.firstLids addObject:[data objectForKey:@"id"]];
                }
            }
        }
        self.currentF = [[responseObject objectForKey:@"filter"] objectAtIndex:2];
        self.allF = [[responseObject objectForKey:@"filter"] objectAtIndex:0];
        self.firstF = [[responseObject objectForKey:@"filter"] objectAtIndex:2];
        self.lotteryF = [[responseObject objectForKey:@"filter"] objectAtIndex:1];
        self.selfF = [[responseObject objectForKey:@"filter"] objectAtIndex:0];
        [self _sortMathces];
        [self.collectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)_sortMathces{
    [self.showMatches removeAllObjects];
    
    for (NSDictionary* match in _matches) {
        if([_firstLids containsObject:[match objectForKey:@"lid"]]){
            [_showMatches addObject:match];
        }
    }
    
    [self.tableView reloadData];
    NSMutableAttributedString* text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%d场  隐藏%d场",[_matches count],[_matches count] - [_showMatches count]]];
    NSInteger count = [[[NSNumber numberWithInteger:[_matches count]] stringValue] length];
    NSInteger count2 = [[[NSNumber numberWithInteger:[_matches count] - [_showMatches count]] stringValue] length];
    [text setAttributes:@{
                          NSForegroundColorAttributeName:COLOR(203, 86, 70, 1)
                          } range:NSMakeRange(1, count)];
    [text setAttributes:@{
                          NSForegroundColorAttributeName:COLOR(203, 86, 70, 1)
                          } range:NSMakeRange(6 + count, count2)];
    [_tips setAttributedText:text];
}

#pragma mark - table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_showMatches count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FootballMatchTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FootballMatchTableViewCell"];
    if(cell == nil){
        cell = [[NSBundle mainBundle] loadNibNamed:@"FootballMatchTableViewCell" owner:nil
                                           options:nil][0];
    }
    if([_showMatches count] > indexPath.row){
        [cell loadData:[_showMatches objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FootballDetailViewController* controller = (FootballDetailViewController*)[QiuMiCommonViewController controllerWithStoryBoardName:@"Football" withControllerName:@"FootballDetailViewController"];
    if([_showMatches count] > indexPath.row){
        [controller setMid:[[_showMatches objectAtIndex:indexPath.row] integerForKey:@"mid"]];
        if ([[_showMatches objectAtIndex:indexPath.row] integerForKey:@"pc_live"] > 0) {
            [controller setHasLive:YES];
        }
        else{
            [controller setHasLive:NO];
        }
    }
    [[QiuMiCommonViewController navigationController] pushViewController:controller animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [FootballMatchTableViewCell heightOfCell];
}

#pragma mark - collect delegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"LeagueFilterCollectionViewCell";
    LeagueFilterCollectionViewCell * cell = (LeagueFilterCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSDictionary* tmp = [[_currentF objectForKey:@"data"] objectAtIndex:indexPath.row];
    [cell.button setTitle:[tmp objectForKey:@"name"] forState:UIControlStateNormal];
    [cell.button setTag:[tmp integerForKey:@"id"]];
    NSString* key = [@([tmp integerForKey:@"id"]) stringValue];
    if(_isSelf){
        if ([_firstLids containsObject:key]) {
            [cell.button setTitleColor:QIUMI_COLOR_G7 forState:UIControlStateNormal];
            [cell.button setBackgroundColor:QIUMI_COLOR_C1];
        }
        else{
            [cell.button setTitleColor:QIUMI_COLOR_G2 forState:UIControlStateNormal];
            [cell.button setBackgroundColor:QIUMI_COLOR_G6];
        }
    }
    else{
        [cell.button setTitleColor:QIUMI_COLOR_G7 forState:UIControlStateNormal];
        [cell.button setBackgroundColor:COLOR(193, 193, 193, 1)];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[_currentF objectForKey:@"data"] count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(floorf((SCREENWIDTH)/3), 36);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(_isSelf){
        NSDictionary* tmp = [[_currentF objectForKey:@"data"] objectAtIndex:indexPath.row];
        NSString* key = [@([tmp integerForKey:@"id"]) stringValue];
        if ([_firstLids containsObject:key]) {
            [_firstLids removeObject:key];
            [collectionView reloadData];
        }
        else{
            [_firstLids addObject:key];
            [collectionView reloadData];
        }
    }
}

#pragma mark - click
- (IBAction)clickFilter:(UIButton*)sender{
    [_filterBtn1 setTitleColor:COLOR(158, 158, 158, 1) forState:UIControlStateNormal];
    [_filterBtn2 setTitleColor:COLOR(158, 158, 158, 1) forState:UIControlStateNormal];
    [_filterBtn3 setTitleColor:COLOR(158, 158, 158, 1) forState:UIControlStateNormal];
    [_filterBtn4 setTitleColor:COLOR(158, 158, 158, 1) forState:UIControlStateNormal];
    _isSelf = false;
    [_firstLids removeAllObjects];
    if([sender.titleLabel.text isEqualToString:@"全部赛事"]){
        [_filterBtn3 setTitleColor:QIUMI_COLOR_C1 forState:UIControlStateNormal];
        _currentF = _allF;
        for (NSDictionary* data in [_allF objectForKey:@"data"]) {
            [self.firstLids addObject:[data objectForKey:@"id"]];
        }
    }
    else if([sender.titleLabel.text isEqualToString:@"竞彩赛事"]){
        [_filterBtn2 setTitleColor:QIUMI_COLOR_C1 forState:UIControlStateNormal];
        _currentF = _lotteryF;
        for (NSDictionary* data in [_lotteryF objectForKey:@"data"]) {
            [self.firstLids addObject:[data objectForKey:@"id"]];
        }
    }
    else if([sender.titleLabel.text isEqualToString:@"重要赛事"]){
        [_filterBtn1 setTitleColor:QIUMI_COLOR_C1 forState:UIControlStateNormal];
        _currentF = _firstF;
        for (NSDictionary* data in [_firstF objectForKey:@"data"]) {
            [self.firstLids addObject:[data objectForKey:@"id"]];
        }
    }
    else if([sender.titleLabel.text isEqualToString:@"自定义"]){
        [_filterBtn4 setTitleColor:QIUMI_COLOR_C1 forState:UIControlStateNormal];
        _isSelf = true;
        _currentF = _selfF;
        _firstLids = _selfLids;
    }
    [_collectionView reloadData];
}

- (IBAction)clickChooseFilter:(id)sender{
    [[_collectionView superview] setHidden:![[_collectionView superview] isHidden]];
}

- (IBAction)clickConfirm:(id)sender{
    [self _sortMathces];
    [[_collectionView superview] setHidden:YES];
}
@end

