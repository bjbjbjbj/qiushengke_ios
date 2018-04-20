//
//  BasketDetailBaseView.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/18.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "BasketDetailBaseView.h"
#import "FootballDetailBaseTechTableViewCell.h"
#import "FootDetailHeaderView.h"
#import "BDBScoreTableViewCell.h"
@interface BasketDetailBaseView()
{
    BOOL _closeScore;
    BOOL _closeTech;
}
@property(nonatomic, strong)NSArray* techs;
@end

@implementation BasketDetailBaseView
- (void)awakeFromNib{
    [super awakeFromNib];
    [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableview setBackgroundColor:QIUMI_COLOR_G5];
    _closeScore = false;
    _closeTech = false;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)loadData{
    NSString* url = [NSString stringWithFormat:QSK_MATCH_BASKET_DETAIL_TECH,[QSKCommon paramWithMid:_mid]];
    QiuMiWeakSelf(self);
    [[QiuMiHttpClient instance] GET:url parameters:nil cachePolicy:QiuMiHttpClientCachePolicyHttpCache success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QiuMiStrongSelf(self);
        self.techs = responseObject;
        [self.tableview reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 1:
            if (_closeTech) {
                return 0;
            }
            return [_techs count];
            break;
        case 0:
            if (_closeScore) {
                return 0;
            }
            return 3;
        default:
            break;
    }
    return 0;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    FootballDetailBaseTechTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FootballDetailBaseTechTableViewCell"];
                    if (cell == nil) {
                        cell = [[NSBundle mainBundle] loadNibNamed:@"FootballDetailBaseTechTableViewCell" owner:nil options:nil][0];
                    }
                    [cell loadMatchData:_match];
                    return cell;
                }
                    break;
                default:{
                    FootballDetailBaseTechTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FootballDetailBaseTechTableViewCell2"];
                    if (cell == nil) {
                        cell = [[NSBundle mainBundle] loadNibNamed:@"FootballDetailBaseTechTableViewCell" owner:nil options:nil][1];
                    }
                    if ([_techs count] > indexPath.row - 1) {
                        [cell loadData:[_techs objectAtIndex:indexPath.row - 1] sport:2];
                    }
                    return cell;
                }
                    break;
            }
        }
            break;
        case 0:{
            switch (indexPath.row) {
                case 0:{
                    BDBScoreTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BDBScoreTableViewCell"];
                    if (cell == nil) {
                        cell = [[NSBundle mainBundle] loadNibNamed:@"BDBScoreTableViewCell" owner:nil options:nil][0];
                    }
                    [cell loadTitle:_match];
                    return cell;
                }
                    break;
                case 1:{
                    BDBScoreTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BDBScoreTableViewCell2"];
                    if (cell == nil) {
                        cell = [[NSBundle mainBundle] loadNibNamed:@"BDBScoreTableViewCell" owner:nil options:nil][1];
                    }
                    [cell loadData:_match isHost:YES];
                    return cell;
                }
                    break;
                case 2:{
                    BDBScoreTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BDBScoreTableViewCell2"];
                    if (cell == nil) {
                        cell = [[NSBundle mainBundle] loadNibNamed:@"BDBScoreTableViewCell" owner:nil options:nil][1];
                    }
                    [cell loadData:_match isHost:NO];
                    return cell;
                }
                    break;
                default:
                    break;
            }
        }
        default:
            break;
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"test"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 1:
        {
            if (indexPath.row == 0) {
                return [FootballDetailBaseTechTableViewCell heightOfCell];
            }
            else{
                return [FootballDetailBaseTechTableViewCell heightOfCell2];
            }
        }
            break;
        case 0:{
            if (indexPath.row == 0) {
                return [BDBScoreTableViewCell heightOfTitle];
            }
            else{
                return [BDBScoreTableViewCell heightOfCell];
            }
        }
            break;
        default:
            break;
    }
    return FLT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 8)];
    [view setBackgroundColor:QIUMI_COLOR_G5];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    FootDetailHeaderView* head = [[NSBundle mainBundle] loadNibNamed:@"FootDetailHeaderView" owner:nil options:nil][0];
    switch (section) {
        case 1:
            [head.name setText:@"技术统计"];
            head.closeImg.tag = 1;
            [head.closeImg addTarget:self action:@selector(clickClose:) forControlEvents:UIControlEventTouchDown];
            if (_closeTech) {
                [head.closeImg setImage:[UIImage imageNamed:@"data_icon_close_n"] forState:UIControlStateNormal];
            }
            else{
                [head.closeImg setImage:[UIImage imageNamed:@"data_icon_open_n"] forState:UIControlStateNormal];
            }
            break;
        case 0:
            [head.name setText:@"比分统计"];
            head.closeImg.tag = 0;
            [head.closeImg addTarget:self action:@selector(clickClose:) forControlEvents:UIControlEventTouchDown];
            if (_closeScore) {
                [head.closeImg setImage:[UIImage imageNamed:@"data_icon_close_n"] forState:UIControlStateNormal];
            }
            else{
                [head.closeImg setImage:[UIImage imageNamed:@"data_icon_open_n"] forState:UIControlStateNormal];
            }
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
            _closeTech = !_closeTech;
            break;
        default:
            break;
    }
    [_tableview reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 74;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}
@end
