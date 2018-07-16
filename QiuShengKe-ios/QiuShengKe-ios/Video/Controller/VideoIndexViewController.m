//
//  BasketballIndexViewController.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/18.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "VideoIndexViewController.h"
#import "AKQVideoListViewController.h"

@interface VideoIndexViewController ()<UIScrollViewDelegate>
@property(nonatomic, strong)IBOutlet UIView* tabBG;
@property(nonatomic, strong)IBOutlet UIScrollView* contentView;

@property(nonatomic, strong)QiuMiTabView* tabView;
@property(nonatomic, strong)NSMutableArray* controllers;
@end

@implementation VideoIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.needToHideNavigationBar = YES;
    [self.view setBackgroundColor:QIUMI_COLOR_C1];
    self.controllers = [[NSMutableArray alloc] init];
    [self _setupUI];
    [self loadData:0];
    
    [self _loadTitles];
}

- (void)_loadTitles{
    QiuMiWeakSelf(self);
    [[QiuMiHttpClient instance] GET:VIDEO_TITLES_LIST parameters:nil cachePolicy:QiuMiHttpClientCachePolicyNoCache success:^(AFHTTPRequestOperation *operation, id responseObject) {
        QiuMiStrongSelf(self);
        if ([responseObject count] > 0) {
            NSMutableArray* titles = [[NSMutableArray alloc] initWithArray:responseObject];
            [titles writeToStore:VIDEO_TITLES];
            if ([self.tabView.columnTitles count] == 0) {
                [self _setupUI];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)_setupUI{
    [_contentView setDelegate:self];
    
    if (_tabView) {
        [_tabView removeFromSuperview];
        self.tabView = nil;
    }
    
    self.tabView = [[QiuMiTabView alloc]initWithFrame:CGRectMake(0, 20, SCREENWIDTH, 44) withCanScroll:YES];
    [_tabView setSelectedColor:QIUMI_COLOR_G7];
    [_tabView setNormalColor:COLOR(234, 234, 234, 1)];
    [_tabView setLineColor:QIUMI_COLOR_G7];
    NSArray* titles = [[NSMutableArray alloc] initWithStore:VIDEO_TITLES];
    NSMutableArray* tmp = [[NSMutableArray alloc] init];
    for (NSDictionary* dic in titles) {
        [tmp addObject:[dic objectForKey:@"name"]];
    }
    [_tabView setColumnTitles:tmp];
    [_tabBG addSubview:_tabView];
    
    if ([self respondsToSelector:@selector(additionalSafeAreaInsets)]) {
        [_contentView setContentSize:CGSizeMake(SCREENWIDTH*[titles count], SCREENHEIGHT - _tabBG.frame.size.height - self.tabBarController.tabBar.frame.size.height)];
    }
    else{
        [_contentView setContentSize:CGSizeMake(SCREENWIDTH*[titles count], SCREENHEIGHT - _tabBG.frame.size.height - self.tabBarController.tabBar.frame.size.height)];
    }
    
    __weak typeof(self) wself = self;
    _tabView.doSelectBlock = ^(NSInteger index){
        CGRect rect = wself.contentView.frame;
        rect.origin.x = SCREENWIDTH * index;
        [wself.contentView scrollRectToVisible:rect animated:YES];
        [wself loadData:index];
    };
    
    for(NSInteger i = 0 ; i < [titles count] ; i++){
        AKQVideoListViewController* controller = (AKQVideoListViewController*)[QiuMiCommonViewController controllerWithStoryBoardName:@"Video" withControllerName:@"AKQVideoListViewController"];
        [self.controllers addObject:controller];
        [controller setType:[[titles objectAtIndex:i] objectForKey:@"type"]];
        [controller updateFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - _tabBG.frame.size.height - self.tabBarController.tabBar.frame.size.height)];
        [controller.view setFrame:CGRectMake(SCREENWIDTH*i, 0, SCREENWIDTH, SCREENHEIGHT - _tabBG.frame.size.height - self.tabBarController.tabBar.frame.size.height)];
        [_contentView addSubview:controller.view];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData:(NSInteger)index{
    for (NSInteger i = 0; i < [_controllers count]; i++) {
        if (index == i) {
            [[_controllers objectAtIndex:i] performSelector:@selector(loadData) withObject:nil];
        }
    }
}

#pragma mark - scrollview
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _contentView) {
        [_tabView contentScrollPositionX:scrollView.contentOffset.x withContentWidth:scrollView.contentSize.width];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _contentView) {
        NSInteger index = scrollView.contentOffset.x/SCREENWIDTH;
        [self loadData:index];
    }
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
