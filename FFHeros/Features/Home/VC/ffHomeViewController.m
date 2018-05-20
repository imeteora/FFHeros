//
//  ffHomeViewController.m
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/19.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffHomeViewController.h"
#import "ffHomeViewModel.h"
#import "ffHeroInfoTableViewCell.h"
#import "ffRefreshScrollView.h"
#import "UIView+WebImage.h"

#import "ffHeroDetailViewController.h"
#import "ffSearchViewController.h"

@interface ffHomeViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ffHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Marvel";

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Find" style:UIBarButtonItemStylePlain target:self action:@selector(onFindButtonClicked:)];

    self.viewModel = [[ffHomeViewModel alloc] init];
    [self addPullToRefresh];
    [self addPullToRefreshMore];
    
    [self.tableView registerNib:[ffHeroInfoTableViewCell nibClass] forCellReuseIdentifier:[ffHeroInfoTableViewCell identifier]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - actions & events
- (void)onFindButtonClicked:(id)sender
{
    ffSearchViewController *vc = [[ffSearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.objects count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ffHeroInfoTableViewCell heightForData:self.viewModel.objects[indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView != tableView) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    ffCharacterModel *pCharacter = self.viewModel.objects[indexPath.row];
    ffHeroInfoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[ffHeroInfoTableViewCell identifier] forIndexPath:indexPath];
    [cell.avatarView ff_setImageWithUrl:[pCharacter.thumbnail pathWithSize:CGSizeZero] placeHolderImage:nil afterComplete:nil];
    [cell.heroNameLabel setText:pCharacter.name];
    [cell.heroDescLabel setText:pCharacter.descField];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.viewModel.objects count]) {
        ffCharacterModel *pCharacter = self.viewModel.objects[indexPath.row];
        ffHeroDetailViewController *detailVC = [[ffHeroDetailViewController alloc] initWithCharacterId:[pCharacter.idField longLongValue]];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

@end
