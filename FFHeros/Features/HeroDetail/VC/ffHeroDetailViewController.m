//
//  ffHeroDetailViewController.m
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/19.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffHeroDetailViewController.h"
#import "ffWebViewController.h"
#import "ffHeroDetailViewModel.h"
#import "ffHeroDetailTableViewCell.h"
#import "ffSummeryTableViewCell.h"

@interface ffHeroDetailViewController () <UITableViewDataSource, UITableViewDelegate, ffHeroDetailTableViewCellDelegate, ffSummeryTableViewCellDelegate>
@property (nonatomic, strong) ffHeroDetailViewModel *viewModel;
@end

@implementation ffHeroDetailViewController
@dynamic viewModel;

- (instancetype)initWithCharacterId:(int64_t)cid {
    if (self = [super init]) {
        self.viewModel = [[ffHeroDetailViewModel alloc] initWithCharacterId:cid];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.disableObservingViewModelObject = YES;

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[ffSummeryTableViewCell nibClass] forCellReuseIdentifier:[ffSummeryTableViewCell identifier]];
    [self.tableView registerNib:[ffHeroDetailTableViewCell nibClass] forCellReuseIdentifier:[ffHeroDetailTableViewCell identifier]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.viewModel addObserver:self forKeyPath:@"heroData" options:NSKeyValueObservingOptionNew context:nil];
    [self.viewModel tryLoadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.viewModel removeObserver:self forKeyPath:@"heroData"];
}

#pragma mark - public helpers

#pragma mark - private helpers
- (void)showWebViewControllerWithUrl:(NSString *)url {
    ffWebViewController *webVC = [[ffWebViewController alloc] init];
    webVC.url = url;
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel numberOfSection];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger)[self.viewModel numberOfItemsInSection:(int32_t)section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.viewModel titleOfSection:(int32_t)section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [ffHeroDetailTableViewCell heightForData:self.viewModel.heroData];
    } else {
        return ([self.viewModel containSection:(int32_t)indexPath.section]? [ffSummeryTableViewCell heightForData:nil]: 0);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ffHeroDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ffHeroDetailTableViewCell identifier] forIndexPath:indexPath];
        [cell setAvatar:[self.viewModel.heroData.thumbnail pathWithSize:CGSizeZero]];
        [cell setName:self.viewModel.heroData.name];
        [cell setModifyInfo:self.viewModel.heroData.modified];
        [cell setDescriptionInfo:[self.viewModel.heroData descField]];
        [cell setReferenceURI:[self.viewModel.heroData detailLink]];
        cell.delegate = self;
        return cell;
    } else if (indexPath.section >= 1 AND indexPath.section < [self.viewModel numberOfSection]) {
        ffSummaryModel *summaryData = [self.viewModel summaryDataForIndex:(int32_t)indexPath.row inSection:(int32_t)indexPath.section];
        ffSummeryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ffSummeryTableViewCell identifier] forIndexPath:indexPath];
        [cell setTitle:summaryData.name withReferenceLink:summaryData.resourceURI];
        cell.delegate = self;
        return cell;
    }
    else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

#pragma mark - ffHeroDetailViewController
- (void)heroDetailCell:(ffHeroDetailTableViewCell *)cell showReferenceDoc:(NSString *)url {
    if ([url length] > 0) {
        [self showWebViewControllerWithUrl:url];
    }
}

#pragma mark - ffSummeryTableViewCellDelegate
- (void)summeryItem:(ffSummeryTableViewCell *)cell didClickWithLink:(NSString *)url {
    if ([url length] > 0) {
        [self showWebViewControllerWithUrl:url];
    }
}

#pragma mark - observe object
- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context {
    if ([keyPath isEqualToString:@"heroData"]) {
        if (self.viewModel.heroData) {
            [self setTitle:self.viewModel.heroData.name];
            [self.tableView reloadData];
        }
    }
}

@end
