//
//  ffBaseTableViewController.m
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/19.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffBaseTableViewController.h"
#import "ffRefreshScrollView.h"

@interface ffBaseTableViewController () < UITableViewDelegate, UITableViewDataSource >
@property (nonatomic, readwrite) UITableView *tableView;
@end

@implementation ffBaseTableViewController

- (void)dealloc
{
    if (_tableView) {
        _tableView.delegate = nil;
        _tableView.dataSource = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)triggerRefresh {
    [self.tableView ff_startRefreshing];
}


- (void)addPullToRefresh {
    weakify(self);
    [self.tableView ff_addHeaderWith:^{
        strongify(self);
        [self.viewModel tryLoadData];
    }];
    return;
}

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler
{
    [self.tableView ff_addHeaderWith:actionHandler];
    return;
}

- (void)addPullToRefreshMore {
    weakify(self);
    [self.tableView ff_addFooterWith:^{
        strongify(self);
        [self.viewModel loadMoreData];
    }];
    return;
}

- (void)addPullToRefreshMoreWithActionHandler:(void (^)(void))actionHandler
{
    [self.tableView ff_addFooterWith:actionHandler];
    return;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSAssert(NO, @"%@: %s must be implemented in sub-class.", NSStringFromClass([self class]), __PRETTY_FUNCTION__);
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSAssert(NO, @"%@: %s must be implemented in sub-class.", NSStringFromClass([self class]), __PRETTY_FUNCTION__);
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(NO, @"%@: %s must be implemented in sub-class.", NSStringFromClass([self class]), __PRETTY_FUNCTION__);
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(NO, @"%@: %s must be implemented in sub-class.", NSStringFromClass([self class]), __PRETTY_FUNCTION__);
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"com.farfetch.tableviewcell.default"];
}


#pragma mark - lazy loading
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 11, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return _tableView;
}

@end
