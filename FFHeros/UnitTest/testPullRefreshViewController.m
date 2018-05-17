//
//  testPullRefreshViewController.m
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/18.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "testPullRefreshViewController.h"
#import "ffRefreshScrollView.h"

@interface testPullRefreshViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation testPullRefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    weakify(self);
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell description]];
    [self.tableView ff_addHeaderWith:^{
        strongify(self);
        NSLog(@"Hello world");
        [self.tableView ff_endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell description] forIndexPath:indexPath];
    cell.textLabel.text = [@(indexPath.row) stringValue];
    return cell;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
