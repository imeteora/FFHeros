//
//  ffHomeViewController.m
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/19.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffHomeViewController.h"
#import "ffHomeViewModel.h"
#import "ffFavouriteItemModel.h"

#import "ffHeroInfoTableViewCell.h"
#import "ffRefreshScrollView.h"

#import "ffHeroDetailViewController.h"
#import "ffSearchViewController.h"
#import "ffFavTableViewController.h"

#import "ffFavouriteHelper.h"

#import "UIView+WebImage.h"

@interface ffHomeViewController () <UITableViewDelegate, UITableViewDataSource, ffHeroInfoTableViewCellDelegate>

@end

@implementation ffHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Marvel";

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Find" style:UIBarButtonItemStylePlain target:self action:@selector(onFindButtonClicked:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Like" style:(UIBarButtonItemStylePlain) target:self action:@selector(onFavListButtonClicked:)];

    self.viewModel = [[ffHomeViewModel alloc] init];
    [self addPullToRefresh];
    [self addPullToRefreshMore];
    
    [self.tableView registerNib:[ffHeroInfoTableViewCell nibClass] forCellReuseIdentifier:[ffHeroInfoTableViewCell identifier]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.tableView reloadData];
}

#pragma mark - actions & events
- (void)onFindButtonClicked:(id)sender
{
    [[ffNavigationHelper shared] showSearchViewController];
}

- (void)onFavListButtonClicked:(id)sender {
    [[ffNavigationHelper shared] showFavouriteListViewController];
}

#pragma mark - ffHeroInfoTableViewCellDelegate
- (void)heroInfoItem:(ffHeroInfoTableViewCell *)cell likeButtonDidClicked:(int32_t)index {
    ffCharacterModel *pHero = self.viewModel.objects[index];

    const int64_t cid = (int64_t)[pHero.idField longLongValue];
    if ([[ffFavouriteHelper shared] favouriteStatusWithCid:cid]) {
        [[ffFavouriteHelper shared] removeFavouriteWithCid:cid];
    } else {
        ffFavouriteItemModel *favItem = [[ffFavouriteItemModel alloc] init];
        favItem.cid = @(cid);
        favItem.avatar = pHero.thumbnail;
        favItem.name = pHero.name;
        favItem.descField = pHero.descField;
        favItem.referenceUri = pHero.resourceURI;

        NSDictionary *favDict = [favItem gt_dictionaryWithKeyValues];
        [[ffFavouriteHelper shared] addFavourite:favDict asCharacter:(int64_t)[favItem.cid longLongValue]];
    }
    [[ffFavouriteHelper shared] save];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
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
    cell.delegate = self;
    cell.index = (int32_t)indexPath.row;
    [cell.avatarView ff_setImageWithUrl:[pCharacter.thumbnail pathWithPortraitSize:CGSizeZero] placeHolderImage:nil afterComplete:nil];
    [cell.heroNameLabel setText:pCharacter.name];
    [cell.heroDescLabel setText:pCharacter.descField];
    if ([[ffFavouriteHelper shared] favouriteStatusWithCid:(int64_t)[pCharacter.idField longLongValue]]) {
        [cell.favouriteBtn setSelected:YES];
    } else {
        [cell.favouriteBtn setSelected:NO];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.viewModel.objects count]) {
        ffCharacterModel *pCharacter = self.viewModel.objects[indexPath.row];
        [[ffNavigationHelper shared] showHeroInfoViewController:(int64_t)[pCharacter.idField longLongValue]];
    }
}

@end
