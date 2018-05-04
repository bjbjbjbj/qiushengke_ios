//
//  ChatView.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/5/4.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "ChatView.h"
#import "ChatTableViewCell.h"
#import "ChatCreateViewController.h"
@interface ChatView()
@property(nonatomic, strong)NSMutableArray* chats;
@property(nonatomic, strong)IBOutlet UIButton* sendBtn;
@end
@implementation ChatView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    [super awakeFromNib];
    self.chats = [[NSMutableArray alloc]init];
    QiuMiViewBorder(_sendBtn, 2, 0, QIUMI_COLOR_C1);
}

- (IBAction)clickSend:(id)sender{
    ChatCreateViewController* controller = (ChatCreateViewController*)[QiuMiCommonViewController controllerWithStoryBoardName:@"My" withControllerName:@"ChatCreateViewController"];
    controller.sport = _sport;
    controller.mid = _mid;
    [[QiuMiCommonViewController navigationController] pushViewController:controller animated:YES];
}

- (void)loadData{
    NSString* url = @"http://www.qiushengke.com/chat/json";
    NSString* midStr = [[NSNumber numberWithInteger:_mid] stringValue];
    url = [NSString stringWithFormat:@"%@/%ld/%@/%@/%@.json",url,_sport,[midStr substringWithRange:NSMakeRange(0, 2)],[midStr substringWithRange:NSMakeRange(2, 2)],midStr];
    QiuMiWeakSelf(self);
    [[QiuMiHttpClient instance] GET:url cachePolicy:QiuMiHttpClientCachePolicyNoCache success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QiuMiStrongSelf(self);
        [self.chats removeAllObjects];
        [self.chats addObjectsFromArray:responseObject];
        [self.tableView reloadData];
        
        [self performSelector:@selector(loadData) withObject:nil afterDelay:5];
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
@end
