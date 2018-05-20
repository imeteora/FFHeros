//
//  ffFavTableViewController.m
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/20.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffFavTableViewController.h"
#import "ffFavItemTableViewCell.h"
#import "ffFavListViewModel.h"

@interface ffFavTableViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ffFavListViewModel    *viewModel;
@end

@implementation ffFavTableViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"My Favourite";
    self.viewModel = [[ffFavListViewModel alloc] init];
    [self.tableView registerNib:[ffFavItemTableViewCell nibClass] forCellReuseIdentifier:[ffFavItemTableViewCell identifier]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.viewModel tryLoadData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfFavouriteList];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (([[self.viewModel objects] count] > 0)? [ffFavItemTableViewCell heightForData:nil]: 44);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ffFavItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ffFavItemTableViewCell identifier] forIndexPath:indexPath];
    ffFavouriteItemModel *model = [self.viewModel itemAtIndex:(int32_t)indexPath.row];
    if (model) {
        [cell setAvatar:[model.avatar pathWithLandscapeSize:CGSizeZero]];
        [cell setName:model.name];
        [cell setDetail:model.descField];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    ffFavouriteItemModel *model = [self.viewModel itemAtIndex:(int32_t)indexPath.row];

}

@end
