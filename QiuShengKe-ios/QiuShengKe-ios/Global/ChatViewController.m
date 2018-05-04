//
//  ChatViewController.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/26.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatTableViewCell.h"
#import "ChatCreateViewController.h"

@interface ChatViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)IBOutlet UITableView* tableView;
@property(nonatomic, strong)NSMutableArray* chats;
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.chats = [[NSMutableArray alloc] init];
    [self useDefaultBack];
    [self useDefaultRight:@"发表"];
    self.title = @"助威";
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self _loadData];
}

-(void)dealloc{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)clickBarRight:(UIButton *)btn{
    ChatCreateViewController* controller = (ChatCreateViewController*)[QiuMiCommonViewController controllerWithStoryBoardName:@"My" withControllerName:@"ChatCreateViewController"];
    controller.sport = _sport;
    controller.mid = _mid;
    [[QiuMiCommonViewController navigationController] pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_loadData{
    NSString* url = @"http://www.qiushengke.com/chat/json";
    NSString* midStr = [[NSNumber numberWithInteger:_mid] stringValue];
    url = [NSString stringWithFormat:@"%@/%ld/%@/%@/%@.json",url,_sport,[midStr substringWithRange:NSMakeRange(0, 2)],[midStr substringWithRange:NSMakeRange(2, 2)],midStr];
    QiuMiWeakSelf(self);
    [[QiuMiHttpClient instance] GET:url cachePolicy:QiuMiHttpClientCachePolicyNoCache success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QiuMiStrongSelf(self);
        [self.chats removeAllObjects];
        [self.chats addObjectsFromArray:responseObject];
        [self.tableView reloadData];
        
        [self performSelector:@selector(_loadData) withObject:nil afterDelay:5];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_chats count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ChatTableViewCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ChatTableViewCell" owner:nil options:nil][0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    if ([_chats count] > indexPath.row) {
        NSDictionary* dic = [_chats objectAtIndex:[_chats count] - 1 - indexPath.row];
        [cell.nickname setText:[NSString stringWithFormat:@"%@：",[dic objectForKey:@"user"]]];
        [cell.content setText:[dic objectForKey:@"content"]];
    }
    else{
        [cell.nickname setText:@"-"];
        [cell.content setText:@"-"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
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
