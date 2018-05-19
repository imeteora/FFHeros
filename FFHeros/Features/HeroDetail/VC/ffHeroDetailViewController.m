//
//  ffHeroDetailViewController.m
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/19.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffHeroDetailViewController.h"
#import "ffHeroDetailViewModel.h"
#import "ffHeroDetailTableViewCell.h"

@interface ffHeroDetailViewController () <UITableViewDataSource, UITableViewDelegate>
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

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (self.viewModel.heroData? 1: 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [ffHeroDetailTableViewCell heightForData:self.viewModel.heroData];
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ffHeroDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ffHeroDetailTableViewCell identifier] forIndexPath:indexPath];
        [cell setAvatar:[self.viewModel.heroData.thumbnail pathWithSize:CGSizeZero]];
        [cell setName:self.viewModel.heroData.name];
        [cell setModifyInfo:self.viewModel.heroData.modified];
        [cell setDescriptionInfo:[self.viewModel.heroData descField]];
        return cell;
    } else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
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
