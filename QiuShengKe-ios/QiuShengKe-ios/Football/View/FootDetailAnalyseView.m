//
//  FootDetailAnalyseView.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/12.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "FootDetailAnalyseView.h"
#import "FootDetailHeaderView.h"
#import "FootballDetailAnalyseTableViewCell.h"

#import "FDARankTableViewCell.h"
#import "FDAScheduleTableViewCell.h"
#import "FDAResultTableViewCell.h"
#import "FDAHistoryTableViewCell.h"

@interface FootDetailAnalyseView(){
    //交锋往绩 同赛事
    BOOL _history_l;
    //交锋望绩 同主客
    BOOL _history_h;
    //近期同赛事
    BOOL _recent_l;
    //近期同主客
    BOOL _recent_h;
}
@property(nonatomic, strong)NSDictionary* analyse;
@end
@implementation FootDetailAnalyseView
- (void)awakeFromNib{
    [super awakeFromNib];
    _history_l = false;
    _history_h = false;
    [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableview setBackgroundColor:QIUMI_COLOR_G5];
}

- (void)loadData{
    NSString* url = [NSString stringWithFormat:QSK_MATCH_FOOT_DETAIL_ANALYSE,[QSKCommon paramWithMid:_mid]];
    QiuMiWeakSelf(self);
    [[QiuMiHttpClient instance] GET:url parameters:nil cachePolicy:QiuMiHttpClientCachePolicyHttpCache success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QiuMiStrongSelf(self);
        self.analyse = responseObject;
        [self.tableview reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            if ([_analyse existForKey:@"rank"] && [[_analyse objectForKey:@"rank"] existForKey:@"rank"]) {
                return 3;
            }
            else{
                return 0;
            }
        }
            break;
        case 1:{
            if ([_analyse existForKey:@"historyBattle"] && [[_analyse objectForKey:@"historyBattle"] isKindOfClass:[NSDictionary class]] && [[_analyse objectForKey:@"historyBattle"] existForKey:@"historyBattle"]) {
                NSString* key = [self _historyString];
                return 1 + [(NSArray*)[[[_analyse objectForKey:@"historyBattle"] objectForKey:@"historyBattle"] objectForKey:key] count];
            }
            return 0;
        }
            break;
        case 2:{
            NSString* key = [self _recentString];
            NSInteger hcount = 0;
            NSInteger acount = 0;
            if ([_analyse existForKey:@"recentBattle"]) {
                hcount = MIN(20, [(NSArray*)[[[_analyse objectForKey:@"recentBattle"] objectForKey:@"home"] objectForKey:key] count]);
                acount = MIN(20, [(NSArray*)[[[_analyse objectForKey:@"recentBattle"] objectForKey:@"away"] objectForKey:key] count]);
            }
            return 2 + 2 + hcount + acount;
        }
            break;
        case 3:{
            return 10;
        }
        case 4:{
            return 4 + ([(NSArray*)[[_analyse objectForKey:@"schedule"] objectForKey:@"home"] count]) + ([(NSArray*)[[_analyse objectForKey:@"schedule"] objectForKey:@"away"] count]);
        }
        default:
            break;
    }
    return 0;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                FDARankTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FDARankTableViewCell"];
                if (cell == nil) {
                    cell = [[NSBundle mainBundle] loadNibNamed:@"FDARankTableViewCell" owner:nil
                                                       options:nil][0];
                }
                return cell;
            }
            else{
                FDARankTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FDARankTableViewCell2"];
                if (cell == nil) {
                    cell = [[NSBundle mainBundle] loadNibNamed:@"FDARankTableViewCell" owner:nil options:nil][1];
                }
                if (indexPath.row == 1) {
                    NSDictionary* tmp = [[[[_analyse objectForKey:@"rank"] objectForKey:@"rank"] objectForKey:@"host"] objectForKey:@"all"];
                    [cell loadData:tmp withTeam:[_match objectForKey:@"hname"]];
                }
                else{
                    NSDictionary* tmp = [[[[_analyse objectForKey:@"rank"] objectForKey:@"rank"] objectForKey:@"away"] objectForKey:@"all"];
                    [cell loadData:tmp withTeam:[_match objectForKey:@"aname"]];
                }
                return cell;
            }
        }
            break;
        case 1:{
            NSString* key = [self _historyString];
            if (indexPath.row == 0) {
                FDAHistoryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FDAHistoryTableViewCell"];
                if (cell == nil) {
                    cell = [[NSBundle mainBundle] loadNibNamed:@"FDAHistoryTableViewCell" owner:nil
                                                       options:nil][0];
                }
                return cell;
            }
            else{
                FDAHistoryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FDAHistoryTableViewCell2"];
                if (cell == nil) {
                    cell = [[NSBundle mainBundle] loadNibNamed:@"FDAHistoryTableViewCell" owner:nil options:nil][1];
                }
                    if ([(NSArray*)[[[_analyse objectForKey:@"historyBattle"] objectForKey:@"historyBattle"] objectForKey:key] count] > indexPath.row - 1) {
                        NSDictionary* tmp = [[[[_analyse objectForKey:@"historyBattle"] objectForKey:@"historyBattle"] objectForKey:key] objectAtIndex:indexPath.row - 1];
                        [cell loadData:tmp teamId:[_match integerForKey:@"hid"]];
                    }
                return cell;
            }
        }
            break;
        case 2:{
            NSString* key = [self _recentString];
            NSInteger hcount = 0;
            NSInteger acount = 0;
            if ([_analyse existForKey:@"recentBattle"]) {
                hcount = MIN(20, [(NSArray*)[[[_analyse objectForKey:@"recentBattle"] objectForKey:@"home"] objectForKey:key] count]);
                acount = MIN(20, [(NSArray*)[[[_analyse objectForKey:@"recentBattle"] objectForKey:@"away"] objectForKey:key] count]);
            }
            if (indexPath.row == 0  || indexPath.row == (hcount + 2)) {
                FootballDetailAnalyseTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FootballDetailAnalyseTableViewCell"];
                if (cell == nil) {
                    cell = [[NSBundle mainBundle] loadNibNamed:@"FootballDetailAnalyseTableViewCell" owner:nil
                                                       options:nil][0];
                }
                if (indexPath.row == 0) {
                    [cell.text setText:[_match stringForKey:@"hname"]];
                }
                else{
                    [cell.text setText:[_match stringForKey:@"aname"]];
                }
                return cell;
            }
            else if (indexPath.row == 1 || indexPath.row == (hcount + 2 + 1)) {
                FDAHistoryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FDAHistoryTableViewCell"];
                if (cell == nil) {
                    cell = [[NSBundle mainBundle] loadNibNamed:@"FDAHistoryTableViewCell" owner:nil
                                                       options:nil][0];
                }
                return cell;
            }
            else{
                FDAHistoryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FDAHistoryTableViewCell2"];
                if (cell == nil) {
                    cell = [[NSBundle mainBundle] loadNibNamed:@"FDAHistoryTableViewCell" owner:nil options:nil][1];
                }
                if (indexPath.row < (hcount + 2)) {
                    if (hcount > indexPath.row - 2) {
                        NSDictionary* tmp = [[[[_analyse objectForKey:@"recentBattle"] objectForKey:@"home"] objectForKey:key] objectAtIndex:indexPath.row - 2];
                        [cell loadData:tmp teamId:[_match integerForKey:@"hid"]];
                    }
                }
                else{
                    if (acount > indexPath.row - 2 - 2 - hcount) {
                        NSDictionary* tmp = [[[[_analyse objectForKey:@"recentBattle"] objectForKey:@"away"] objectForKey:key] objectAtIndex:indexPath.row - 2 - 2 - hcount];
                        [cell loadData:tmp teamId:[_match integerForKey:@"aid"]];
                    }
                }
                return cell;
            }
        }
            break;
        case 3:{
            if (indexPath.row == 0 || indexPath.row == 5) {
                FootballDetailAnalyseTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FootballDetailAnalyseTableViewCell"];
                if (cell == nil) {
                    cell = [[NSBundle mainBundle] loadNibNamed:@"FootballDetailAnalyseTableViewCell" owner:nil
                                                       options:nil][0];
                }
                if (indexPath.row == 0) {
                    [cell.text setText:[_match stringForKey:@"hname"]];
                }
                else{
                    [cell.text setText:[_match stringForKey:@"aname"]];
                }
                return cell;
            }
            else if (indexPath.row == 1 || indexPath.row == 6){
                FDAResultTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FDAResultTableViewCell"];
                if (cell == nil) {
                    cell = [[NSBundle mainBundle] loadNibNamed:@"FDAResultTableViewCell" owner:nil
                                                       options:nil][0];
                }
                return cell;
            }
            else{
                FDAResultTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FDAResultTableViewCell2"];
                if (cell == nil) {
                    cell = [[NSBundle mainBundle] loadNibNamed:@"FDAResultTableViewCell" owner:nil options:nil][1];
                }
                NSDictionary* data = nil;
                if (indexPath.row < 6 && [_analyse existForKey:@"oddResult"] && [[_analyse objectForKey:@"oddResult"] existForKey:@"home"]) {
                    data = [[_analyse objectForKey:@"oddResult"] objectForKey:@"home"];
                }
                else if([_analyse existForKey:@"oddResult"] && [[_analyse objectForKey:@"oddResult"] existForKey:@"away"]){
                    data = [[_analyse objectForKey:@"oddResult"] objectForKey:@"away"];
                }
                switch (indexPath.row%5) {
                    case 2:
                        [cell loadData:[data objectForKey:@"all"]];
                        [cell.count setText:@"全"];
                        break;
                    case 3:
                        [cell loadData:[data objectForKey:@"home"]];
                        [cell.count setText:@"主"];
                        break;
                    case 4:
                        [cell loadData:[data objectForKey:@"away"]];
                        [cell.count setText:@"客"];
                        break;
                    case 5:
                        [cell loadData:[data objectForKey:@"six"]];
                        [cell.count setText:@"近6"];
                        break;
                    default:
                        break;
                }
                return cell;
            }
        }
        case 4:{
            NSInteger hcount = [(NSArray*)[[_analyse objectForKey:@"schedule"] objectForKey:@"home"] count];
            NSInteger acount = [(NSArray*)[[_analyse objectForKey:@"schedule"] objectForKey:@"away"] count];
            if (indexPath.row == 0  || indexPath.row == (hcount + 2)) {
                FootballDetailAnalyseTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FootballDetailAnalyseTableViewCell"];
                if (cell == nil) {
                    cell = [[NSBundle mainBundle] loadNibNamed:@"FootballDetailAnalyseTableViewCell" owner:nil
                                                       options:nil][0];
                }
                if (indexPath.row == 0) {
                    [cell.text setText:[_match stringForKey:@"hname"]];
                }
                else{
                    [cell.text setText:[_match stringForKey:@"aname"]];
                }
                return cell;
            }
            else if (indexPath.row == 1 || indexPath.row == (hcount + 2 + 1)) {
                FDAScheduleTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FDAScheduleTableViewCell"];
                if (cell == nil) {
                    cell = [[NSBundle mainBundle] loadNibNamed:@"FDAScheduleTableViewCell" owner:nil
                                                       options:nil][0];
                }
                return cell;
            }
            else{
                FDAScheduleTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FDAScheduleTableViewCell2"];
                if (cell == nil) {
                    cell = [[NSBundle mainBundle] loadNibNamed:@"FDAScheduleTableViewCell" owner:nil options:nil][1];
                }
                if (indexPath.row < (hcount + 2)) {
                    if (hcount > indexPath.row - 2) {
                        NSDictionary* tmp = [[[_analyse objectForKey:@"schedule"] objectForKey:@"home"] objectAtIndex:indexPath.row - 2];
                        [cell loadData:tmp teamId:[_match integerForKey:@"hid"]];
                    }
                }
                else{
                    if (acount > indexPath.row - 2 - 2 - hcount) {
                        NSDictionary* tmp = [[[_analyse objectForKey:@"schedule"] objectForKey:@"away"] objectAtIndex:indexPath.row - 2 - 2 - hcount];
                        [cell loadData:tmp teamId:[_match integerForKey:@"aid"]];
                    }
                }
                return cell;
            }
        }
            break;
        default:
            break;
    }
    
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
            //排名
        case 0:
            if (indexPath.row == 0) {
                return [FDARankTableViewCell heightOfTitle];
            }
            else{
                return [FDARankTableViewCell heightOfCell];
            }
            break;
        case 1:{
            NSString* key = [self _historyString];
            NSInteger hcount = 0;
            if ([_analyse existForKey:@"historyBattle"]) {
                hcount = MIN(20, [(NSArray*)[[[_analyse objectForKey:@"historyBattle"] objectForKey:@"historyBattle"] objectForKey:key] count]);
            }
            if (indexPath.row == 0) {
                return [FDAHistoryTableViewCell heightOfTitle];
            }
            else{
                return [FDAHistoryTableViewCell heightOfCell];
            }
            break;
        }
        case 2:{
            NSString* key = [self _recentString];
            NSInteger hcount = 0;
            if ([_analyse existForKey:@"recentBattle"]) {
                hcount = MIN(20, [(NSArray*)[[[_analyse objectForKey:@"recentBattle"] objectForKey:@"home"] objectForKey:key] count]);
            }
            if (indexPath.row == 0  || indexPath.row == (hcount + 2)) {
                return [FootballDetailAnalyseTableViewCell heightOfName];
            }
            else if (indexPath.row == 1 || indexPath.row == (hcount + 2 + 1)) {
                return [FDAHistoryTableViewCell heightOfTitle];
            }
            else{
                return [FDAHistoryTableViewCell heightOfCell];
            }
        }
            break;
        case 3:{
            if (indexPath.row == 0 || indexPath.row == 5) {
                return [FootballDetailAnalyseTableViewCell heightOfName];
            }
            else if(indexPath.row == 1 || indexPath.row == 6){
                return [FDAResultTableViewCell heightOfTitle];
            }
            else{
                return [FDAResultTableViewCell heightOfCell];
            }
        }
            break;
        case 4:
            if (indexPath.row == 0  || indexPath.row == ([(NSArray*)[[_analyse objectForKey:@"schedule"] objectForKey:@"home"] count] + 2)) {
                return [FootballDetailAnalyseTableViewCell heightOfName];
            }
            else if (indexPath.row == 1 || indexPath.row == ([(NSArray*)[[_analyse objectForKey:@"schedule"] objectForKey:@"home"] count] + 2 + 1)) {
                return [FDAScheduleTableViewCell heightOfTitle];
            }
            else{
                return [FDAScheduleTableViewCell heightOfCell];
            }
            break;
        default:
            break;
    }
    
    return [FootballDetailAnalyseTableViewCell heightOfName];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 8)];
    [view setBackgroundColor:QIUMI_COLOR_G5];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    FootDetailHeaderView* head = [[NSBundle mainBundle] loadNibNamed:@"FootDetailHeaderView" owner:nil options:nil][0];
    switch (section) {
        case 0:
            [head.name setText:@"积分排名"];
            break;
        case 1:
            [head.name setText:@"交锋往绩"];
            break;
        case 2:
            [head.name setText:@"最近战绩"];
            break;
        case 3:
            [head.name setText:@"赛事盘路"];
            break;
        case 4:
            [head.name setText:@"未来赛程"];
            break;
        default:
            break;
    }
    return head;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 74;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}

- (NSString*) _recentString{
    if (_recent_h) {
        if (_recent_l) {
            return @"sameHAL";
        }
        else{
            return @"sameHA";
        }
    }
    else{
        if (_recent_l) {
            return @"sameL";
        }
        else{
            return @"all";
        }
    }
}

- (NSString*) _historyString{
    if (_history_h) {
        if (_history_l) {
            return @"shsl";
        }
        else{
            return @"shnl";
        }
    }
    else{
        if (_history_l) {
            return @"nhsl";
        }
        else{
            return @"nhnl";
        }
    }
}
@end
