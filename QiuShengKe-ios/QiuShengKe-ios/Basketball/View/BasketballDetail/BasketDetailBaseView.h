//
//  BasketDetailBaseView.h
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/18.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasketDetailBaseView : UIView<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)IBOutlet UITableView* tableview;
@property(nonatomic, strong)NSDictionary* match;
@property(nonatomic, strong)NSDictionary* tech;
@property(nonatomic, assign)NSInteger mid;
- (void)loadData;
@end
