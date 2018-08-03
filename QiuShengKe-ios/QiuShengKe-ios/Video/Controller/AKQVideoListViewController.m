//
//  BasketballMatchListViewController.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/18.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "AKQVideoListViewController.h"
#import "VideoTableViewCell.h"

@interface AKQVideoListViewController ()<UITableViewDelegate, UITableViewDataSource>{
    BOOL _isSelf;
}
@property(nonatomic, strong)NSMutableArray* datas;
@property(nonatomic, assign)NSInteger page;
@end

@implementation AKQVideoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isSelf = false;
    // Do any additional setup after loading the view.
    self.datas = [[NSMutableArray alloc] init];
    [self _setupUI];
    self.page = 0;
    [self.tableview setBackgroundColor:QIUMI_COLOR_G5];
}

- (void)_setupUI{
//    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.needToHideNavigationBar = YES;
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
    if ([_datas count] == 0) {
        [self loadDataWithFresh:YES];
    }
}

- (void)loadDataWithFresh:(BOOL)isRefresh{
    QiuMiWeakSelf(self);
    if (isRefresh) {
        _page = 1;
    }
    [[QiuMiHttpClient instance]GET:[NSString stringWithFormat:VIDEO_LIST,_type,@(_page)] parameters:nil cachePolicy:_page == 1 ?QiuMiHttpClientCachePolicyHttpCache:QiuMiHttpClientCachePolicyNoCache prompt:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QiuMiStrongSelf(self);
        [self.tableview.refresh endRefreshing];
        if ([responseObject objectForKey:@"page"]) {
            if (self.page == 1) {
                [self.datas removeAllObjects];
            }
            [self.datas addObjectsFromArray:[responseObject objectForKey:@"videos"]];
            [self.tableview reloadData];
            self.page = [[responseObject objectForKey:@"page"] integerForKey:@"curPage"] + 1;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QiuMiStrongSelf(self);
        [self.tableview.refresh endRefreshing];
    }];
}

#pragma mark - table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_datas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"VideoTableViewCell"];
    if(cell == nil){
        cell = [[NSBundle mainBundle] loadNibNamed:@"VideoTableViewCell" owner:nil
                                           options:nil][0];
    }
    if([_datas count] > indexPath.row){
        [cell loadData:[_datas objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_datas count] > indexPath.row) {
        NSString* vid = [[[_datas objectAtIndex:indexPath.row] objectForKey:@"id"] stringValue];
        NSString* url = [NSString stringWithFormat:@"%@/m/live/subject/video/%@/%@/%@.html",[[QSKCommon instance] baseUrl],[vid substringWithRange:NSMakeRange(0, 2)],[vid substringWithRange:NSMakeRange(2, 2)],vid];
        QiuMiCommonWKWebViewController* web = (QiuMiCommonWKWebViewController*)[QiuMiCommonViewController controllerWithStoryBoardName:@"Football" withControllerName:@"QiuMiCommonWKWebViewController"];
        [web setUrl:url];
        [web setIsVideo:YES];
        [[QiuMiCommonViewController navigationController]pushViewController:web animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [VideoTableViewCell heightOfCell];
}
@end
