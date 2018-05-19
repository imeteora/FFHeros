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

@interface ffHomeViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ffHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Marvel";
    self.viewModel = [[ffHomeViewModel alloc] init];
    [self addPullToRefresh];
    [self addPullToRefreshMore];
    [self.tableView registerNib:[ffHeroInfoTableViewCell nibClass] forCellReuseIdentifier:[ffHeroInfoTableViewCell identifier]];
    [self.tableView setEstimatedRowHeight:[ffHeroInfoTableViewCell heightForData:nil]];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.objects count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        return [ffHeroInfoTableViewCell heightForData:self.viewModel.objects[indexPath.row]];
    }
    @catch (NSException *e) {
#if DEBUG
        NSLog(@"%@", e);
#endif  // DEBUG
    }
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

@end
