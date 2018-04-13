//
//  FootDetailBaseView.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/11.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "FootDetailBaseView.h"
#import "FootDetailHeaderView.h"
#import "FootballDetailBaseTechTableViewCell.h"
@interface FootDetailBaseView()
@property(nonatomic, strong)NSArray* techs;
@end
@implementation FootDetailBaseView
- (void)awakeFromNib{
    [super awakeFromNib];
    [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableview setBackgroundColor:QIUMI_COLOR_G5];
}

- (void)loadData{
    NSString* url = [NSString stringWithFormat:QSK_MATCH_FOOT_DETAIL_TECH,[QSKCommon paramWithMid:_mid]];
    QiuMiWeakSelf(self);
    [[QiuMiHttpClient instance] GET:url parameters:nil cachePolicy:QiuMiHttpClientCachePolicyHttpCache success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QiuMiStrongSelf(self);
        self.techs = [responseObject objectForKey:@"tech"];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_techs count];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
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
                [cell loadData:[_techs objectAtIndex:indexPath.row - 1]];
            }
            return cell;
        }
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return [FootballDetailBaseTechTableViewCell heightOfCell];
    }
    else{
        return [FootballDetailBaseTechTableViewCell heightOfCell2];
    }
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
            [head.name setText:@"技术统计"];
            break;
        case 1:
            [head.name setText:@"比赛事件"];
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
@end
