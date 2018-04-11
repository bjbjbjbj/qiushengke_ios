//
//  QiuMiCommonTableViewController.m
//  Qiumi
//
//  Created by xieweijie on 16/3/28.
//  Copyright © 2016年 51viper.com. All rights reserved.
//

#import "QiuMiCommonTableViewController.h"

@interface QiuMiCommonTableViewController ()<QiuMiCommonTableViewDelegate>

@end

@implementation QiuMiCommonTableViewController

- (void)dealloc
{
    self.tableview.delegate = nil;
    self.tableview.dataSource = nil;
}

- (void)updateFrame:(CGRect)frame
{
    [self.view setBackgroundColor:[UIColor blueColor]];
    [self.view setFrame:frame];
    QiuMiViewResize(_tableview, CGSizeMake(frame.size.width, frame.size.height));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_tableview == nil) {
        self.tableview = [[QiuMiCommonTableView alloc]initWithFrame:CGRectMake(0, _hasDIYNav?self.navigationController.navigationBar.frame.size.height:0, self.view.frame.size.width, self.view.frame.size.height - (_hasDIYNav?self.navigationController.navigationBar.frame.size.height:0)) style:_isGroup ? UITableViewStyleGrouped : UITableViewStylePlain];
        self.tableview.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _tableview.commonTableViewDelegate = self;
        _tableview.dataSource = self;
        _tableview.delegate = self;
        [self.view addSubview:_tableview];
        [self.view sendSubviewToBack:_tableview];
    }
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

#pragma mark - table view delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}


#pragma mark - scroll view delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate && scrollView ==  _tableview) {
        [self loadMore:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _tableview) {
        [self loadMore:scrollView];
    }
}

- (void)loadMore:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y + scrollView.bounds.size.height + 80 > scrollView.contentSize.height){
        [self loadDataWithFresh:NO];
    }
}

- (void)commonReloadData:(QiuMiCommonTableView *)tableview{
    [self loadDataWithFresh:YES];
}

- (void)loadDataWithFresh:(BOOL)isRefresh
{
    
}

- (void)commonLoadMoreData:(QiuMiCommonTableView *)tableview
{
    
}

@end
