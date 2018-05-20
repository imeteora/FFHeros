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
@property (nonatomic, assign) BOOL disableObservingViewModelObject;


- (void)triggerRefresh;
- (void)addPullToRefresh;
- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler;
- (void)addPullToRefreshMore;
- (void)addPullToRefreshMoreWithActionHandler:(void (^)(void))actionHandler;

- (void)showToaste:(NSString *)info;

// just for inherited class to get default table view cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
