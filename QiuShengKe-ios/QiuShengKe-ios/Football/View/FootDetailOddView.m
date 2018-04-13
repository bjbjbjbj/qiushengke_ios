//
//  FootDetailOddView.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/12.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "FootDetailOddView.h"
#import "FootballDetailOddTableViewCell.h"
@interface FootDetailOddView(){
    NSInteger _type;
}
@property(nonatomic, strong)IBOutlet UITableView* tableview;
@property(nonatomic, strong)IBOutlet UIButton* aBtn;
@property(nonatomic, strong)IBOutlet UIButton* oBtn;
@property(nonatomic, strong)IBOutlet UIButton* gBtn;
@property(nonatomic, strong)NSMutableArray* odds;
@property(nonatomic, strong)NSMutableArray* aOdds;
@property(nonatomic, strong)NSMutableArray* oOdds;
@property(nonatomic, strong)NSMutableArray* gOdds;
@end
@implementation FootDetailOddView
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setBackgroundColor:QIUMI_COLOR_G5];
    QiuMiViewBorder([_gBtn superview], 2, 1, QIUMI_COLOR_C1);
    _type = 0;
    [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableview setBackgroundColor:QIUMI_COLOR_G5];
    self.odds = [[NSMutableArray alloc] init];
    self.aOdds = [[NSMutableArray alloc] init];
    self.oOdds = [[NSMutableArray alloc] init];
    self.gOdds = [[NSMutableArray alloc] init];
    
    [_aBtn setTitleColor:QIUMI_COLOR_G7 forState:UIControlStateNormal];
    [_aBtn setBackgroundColor:QIUMI_COLOR_C1];
    [_oBtn setTitleColor:QIUMI_COLOR_C1 forState:UIControlStateNormal];
    [_oBtn setBackgroundColor:QIUMI_COLOR_G7];
    [_gBtn setTitleColor:QIUMI_COLOR_C1 forState:UIControlStateNormal];
    [_gBtn setBackgroundColor:QIUMI_COLOR_G7];
}

- (void)loadData{
    NSString* url = [NSString stringWithFormat:QSK_MATCH_FOOT_DETAIL_ODD,[QSKCommon paramWithMid:_mid]];
    QiuMiWeakSelf(self);
    [[QiuMiHttpClient instance] GET:url parameters:nil cachePolicy:QiuMiHttpClientCachePolicyHttpCache success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QiuMiStrongSelf(self);
        [self.odds removeAllObjects];
        for (NSString* key in responseObject) {
            if ([responseObject objectForKey:key]) {
                [self.odds addObject:[responseObject objectForKey:key]];
            }
        }
        
        [self.aOdds removeAllObjects];
        [self.oOdds removeAllObjects];
        [self.gOdds removeAllObjects];
        for (NSDictionary* item in self.odds) {
            if ([item objectForKey:@"asia"]) {
                NSMutableDictionary* tmp = [[NSMutableDictionary alloc] initWithDictionary:[item objectForKey:@"asia"]];
                [tmp setObject:[item objectForKey:@"name"] forKey:@"name"];
                [self.aOdds addObject:tmp];
            }
            if ([item objectForKey:@"goal"]) {
                NSMutableDictionary* tmp = [[NSMutableDictionary alloc] initWithDictionary:[item objectForKey:@"goal"]];
                [tmp setObject:[item objectForKey:@"name"] forKey:@"name"];
                [self.gOdds addObject:tmp];
            }
            if ([item objectForKey:@"ou"]) {
                NSMutableDictionary* tmp = [[NSMutableDictionary alloc] initWithDictionary:[item objectForKey:@"ou"]];
                [tmp setObject:[item objectForKey:@"name"] forKey:@"name"];
                [self.oOdds addObject:tmp];
            }
        }
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
    switch (section) {
        case 0:
            return [_aOdds count];
            break;
        case 1:
            return [_oOdds count];
            break;
        case 2:
            return [_gOdds count];
            break;
        default:
            break;
    }
    return 0;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            FootballDetailOddTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FootballDetailOddTableViewCell"];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"FootballDetailOddTableViewCell" owner:nil options:nil][0];
            }
            [cell loadDataTitle:_type];
            return cell;
        }
            break;
        default:{
            FootballDetailOddTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FootballDetailOddTableViewCell2"];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"FootballDetailOddTableViewCell" owner:nil options:nil][1];
            }
            
            NSArray* tmp = nil;
            
            switch (_type) {
                case 0:
                    tmp = _aOdds;
                    break;
                case 1:
                    tmp = _oOdds;
                    break;
                case 2:
                    tmp = _gOdds;
                    break;
                default:
                    break;
            }
            
            if ([tmp count] > indexPath.row - 1) {
                [cell loadData:[tmp objectAtIndex:indexPath.row - 1]];
            }
            return cell;
        }
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return [FootballDetailOddTableViewCell heightOfCell];
    }
    else{
        return [FootballDetailOddTableViewCell heightOfCell2];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 8)];
    [view setBackgroundColor:QIUMI_COLOR_G5];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}

- (IBAction)clickBtn:(UIButton*)sender{
    [_aBtn setTitleColor:QIUMI_COLOR_C1 forState:UIControlStateNormal];
    [_aBtn setBackgroundColor:QIUMI_COLOR_G7];
    [_oBtn setTitleColor:QIUMI_COLOR_C1 forState:UIControlStateNormal];
    [_oBtn setBackgroundColor:QIUMI_COLOR_G7];
    [_gBtn setTitleColor:QIUMI_COLOR_C1 forState:UIControlStateNormal];
    [_gBtn setBackgroundColor:QIUMI_COLOR_G7];
    switch (sender.tag) {
        case 0:
            _type = 0;
            [_aBtn setTitleColor:QIUMI_COLOR_G7 forState:UIControlStateNormal];
            [_aBtn setBackgroundColor:QIUMI_COLOR_C1];
            [_tableview reloadData];
            break;
        case 1:
            _type = 1;
            [_oBtn setTitleColor:QIUMI_COLOR_G7 forState:UIControlStateNormal];
            [_oBtn setBackgroundColor:QIUMI_COLOR_C1];
            [_tableview reloadData];
            break;
        case 2:
            _type = 2;
            [_gBtn setTitleColor:QIUMI_COLOR_G7 forState:UIControlStateNormal];
            [_gBtn setBackgroundColor:QIUMI_COLOR_C1];
            [_tableview reloadData];
            break;
        default:
            break;
    }
}
@end
