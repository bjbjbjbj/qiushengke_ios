//
//  ChatView.h
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/5/4.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatView : UIView
@property(nonatomic, strong)IBOutlet UITableView* tableView;
@property(nonatomic, assign)NSInteger mid;
@property(nonatomic, assign)NSInteger sport;
- (void)loadData;
@end
