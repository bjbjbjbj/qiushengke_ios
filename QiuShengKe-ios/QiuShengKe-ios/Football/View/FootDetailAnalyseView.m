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
    //关闭
    BOOL _closeScore;
    BOOL _closeHis;
    BOOL _closeRec;
    BOOL _closeTrend;
    BOOL _closeSch;
}
@property(nonatomic, strong)NSDictionary* analyse;
@end
@implementation FootDetailAnalyseView
- (void)awakeFromNib{
    [super awakeFromNib];
    _history_l = false;
    _history_h = false;
    
    _closeScore = false;
    _closeHis = false;
    _closeRec = false;
    _closeTrend = false;
    _closeSch = false;
    
    [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableview setBackgroundColor:QIUMI_COLOR_G5];
}

- (void)loadData{
    NSString* url = @"";
    if (_sport == 2) {
        url = [NSString stringWithFormat:QSK_MATCH_BASKET_DETAIL_ANALYSE,[QSKCommon paramWithMid:_mid]];;
    }
    else{
        url = [NSString stringWithFormat:QSK_MATCH_FOOT_DETAIL_ANALYSE,[QSKCommon paramWithMid:_mid]];;
    }
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
            if (_closeScore) {
                return 0;
            }
            if ([_analyse existForKey:@"rank"] && [[_analyse objectForKey:@"rank"] existForKey:@"rank"]) {
                return 3;
            }
            else{
                return 0;
            }
        }
            break;
        case 1:{
            if (_closeHis) {
                return 0;
            }
            if ([_analyse existForKey:@"historyBattle"] && [[_analyse objectForKey:@"historyBattle"] isKindOfClass:[NSDictionary class]] && [[_analyse objectForKey:@"historyBattle"] existForKey:@"historyBattle"]) {
                NSString* key = [self _historyString];
                return 1 + [(NSArray*)[[[_analyse objectForKey:@"historyBattle"] objectForKey:@"historyBattle"] objectForKey:key] count];
            }
            return 0;
        }
            break;
        case 2:{
            if (_closeRec) {
                return 0;
            }
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
            if (_closeTrend) {
                return 0;
            }
            return 10;
        }
        case 4:{
            if (_closeSch) {
                return 0;
            }
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
            head.closeImg.tag = 0;
            [head.closeImg addTarget:self action:@selector(clickClose:) forControlEvents:UIControlEventTouchDown];
            if (_closeScore) {
                [head.closeImg setImage:[UIImage imageNamed:@"data_icon_close_n"] forState:UIControlStateNormal];
            }
            else{
                [head.closeImg setImage:[UIImage imageNamed:@"data_icon_open_n"] forState:UIControlStateNormal];
            }
            break;
        case 1:
            [head.name setText:@"交锋往绩"];
            head.closeImg.tag = 1;
            [head.closeImg addTarget:self action:@selector(clickClose:) forControlEvents:UIControlEventTouchDown];
            if (_closeHis) {
                [head.closeImg setImage:[UIImage imageNamed:@"data_icon_close_n"] forState:UIControlStateNormal];
            }
            else{
                [head.closeImg setImage:[UIImage imageNamed:@"data_icon_open_n"] forState:UIControlStateNormal];
            }
            [[head.sameH superview] setHidden:NO];
            [[head.sameL superview] setHidden:NO];
            [head.sameH addTarget:self action:@selector(clickHisH:) forControlEvents:UIControlEventTouchDown];
            [head.sameL addTarget:self action:@selector(clickHisL:) forControlEvents:UIControlEventTouchDown];
            [head.sameH setSelected:_history_h];
            [head.sameL setSelected:_history_l];
            if (head.sameL.isSelected) {
                [(UIImageView*)[[head.sameL superview] viewWithTag:99] setImage:[UIImage imageNamed:@"match_icon_choose_s"]];
            }
            else{
                [(UIImageView*)[[head.sameL superview] viewWithTag:99] setImage:[UIImage imageNamed:@"match_icon_choose_n"]];
            }
            if (head.sameH.isSelected) {
                [(UIImageView*)[[head.sameH superview] viewWithTag:99] setImage:[UIImage imageNamed:@"match_icon_choose_s"]];
            }
            else{
                [(UIImageView*)[[head.sameH superview] viewWithTag:99] setImage:[UIImage imageNamed:@"match_icon_choose_n"]];
            }
            break;
        case 2:
            head.closeImg.tag = 2;
            [head.closeImg addTarget:self action:@selector(clickClose:) forControlEvents:UIControlEventTouchDown];
            if (_closeRec) {
                [head.closeImg setImage:[UIImage imageNamed:@"data_icon_close_n"] forState:UIControlStateNormal];
            }
            else{
                [head.closeImg setImage:[UIImage imageNamed:@"data_icon_open_n"] forState:UIControlStateNormal];
            }
            [head.name setText:@"最近战绩"];
            [[head.sameH superview] setHidden:NO];
            [[head.sameL superview] setHidden:NO];
            [head.sameH addTarget:self action:@selector(clickRecH:) forControlEvents:UIControlEventTouchDown];
            [head.sameL addTarget:self action:@selector(clickRecL:) forControlEvents:UIControlEventTouchDown];
            [head.sameH setSelected:_recent_h];
            [head.sameL setSelected:_recent_l];
            if (head.sameL.isSelected) {
                [(UIImageView*)[[head.sameL superview] viewWithTag:99] setImage:[UIImage imageNamed:@"match_icon_choose_s"]];
            }
            else{
                [(UIImageView*)[[head.sameL superview] viewWithTag:99] setImage:[UIImage imageNamed:@"match_icon_choose_n"]];
            }
            if (head.sameH.isSelected) {
                [(UIImageView*)[[head.sameH superview] viewWithTag:99] setImage:[UIImage imageNamed:@"match_icon_choose_s"]];
            }
            else{
                [(UIImageView*)[[head.sameH superview] viewWithTag:99] setImage:[UIImage imageNamed:@"match_icon_choose_n"]];
            }
            break;
        case 3:
            head.closeImg.tag = 3;
            [head.closeImg addTarget:self action:@selector(clickClose:) forControlEvents:UIControlEventTouchDown];
            if (_closeTrend) {
                [head.closeImg setImage:[UIImage imageNamed:@"data_icon_close_n"] forState:UIControlStateNormal];
            }
            else{
                [head.closeImg setImage:[UIImage imageNamed:@"data_icon_open_n"] forState:UIControlStateNormal];
            }
            [head.name setText:@"赛事盘路"];
            break;
        case 4:
            head.closeImg.tag = 4;
            [head.closeImg addTarget:self action:@selector(clickClose:) forControlEvents:UIControlEventTouchDown];
            if (_closeSch) {
                [head.closeImg setImage:[UIImage imageNamed:@"data_icon_close_n"] forState:UIControlStateNormal];
            }
            else{
                [head.closeImg setImage:[UIImage imageNamed:@"data_icon_open_n"] forState:UIControlStateNormal];
            }
            [head.name setText:@"未来赛程"];
            break;
        default:
            break;
    }
    return head;
}

- (void)clickClose:(UIButton*)btn{
    switch (btn.tag) {
        case 0:
            _closeScore = !_closeScore;
            break;
        case 1:
            _closeHis = !_closeHis;
            break;
        case 2:
            _closeRec = !_closeRec;
            break;
        case 3:
            _closeTrend = !_closeTrend;
            break;
        case 4:
            _closeSch = !_closeSch;
            break;
        default:
            break;
    }
    [_tableview reloadData];
}

- (void)clickRecH:(UIButton*)btn{
    [btn setSelected:!btn.isSelected];
    _recent_h = btn.isSelected;
    [_tableview reloadData];
}

- (void)clickRecL:(UIButton*)btn{
    [btn setSelected:!btn.isSelected];
    _recent_l = btn.isSelected;
    [_tableview reloadData];
}


- (void)clickHisH:(UIButton*)btn{
    [btn setSelected:!btn.isSelected];
    _history_h = btn.isSelected;
    [_tableview reloadData];
}

- (void)clickHisL:(UIButton*)btn{
    [btn setSelected:!btn.isSelected];
    _history_l = btn.isSelected;
    [_tableview reloadData];
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
