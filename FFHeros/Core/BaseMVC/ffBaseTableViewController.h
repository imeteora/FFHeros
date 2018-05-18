//
//  ffBaseTableViewController.h
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/19.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffBaseListViewController.h"

@interface ffBaseTableViewController : ffBaseListViewController
@property (nonatomic, readonly) UITableView *tableView;

- (void)triggerRefresh;
- (void)addPullToRefresh;
- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler;
- (void)addPullToRefreshMore;
- (void)addPullToRefreshMoreWithActionHandler:(void (^)(void))actionHandler;

@end
