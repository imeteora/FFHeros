//
//  ffSearchViewController.m
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/20.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffSearchViewController.h"
#import "ffSearchViewModel.h"

#import "ffCharacterModel.h"
#import "ffHeroInfoTableViewCell.h"
#import "ffHeroDetailViewController.h"

#import "UIView+ffExt.h"
#import "UIView+WebImage.h"

@interface ffSearchViewController () <UISearchBarDelegate, UIScrollViewDelegate> {
    CGFloat _keyboardHeight;
}
@property (nonatomic, strong) ffSearchViewModel *viewModel;
@property (nonatomic, strong) UISearchBar *searchBar;
@end

@implementation ffSearchViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    _keyboardHeight = 0;

    self.viewModel = [[ffSearchViewModel alloc] init];

    [self.tableView registerNib:[ffHeroInfoTableViewCell nibClass] forCellReuseIdentifier:[ffHeroInfoTableViewCell identifier]];
    [self.view addSubview:self.searchBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.searchBar canBecomeFirstResponder]) {
        [self.searchBar becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.searchBar canResignFirstResponder]) {
        [self.searchBar resignFirstResponder];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    int32_t topY = 0;
    if (@available(iOS 11, *)) {
        if (IS_IPHONE_X) {
            topY = self.additionalSafeAreaInsets.top;
        }
    }
    self.searchBar.frame = CGRectMake(0, topY, self.view.viewWidth, 64);
    self.tableView.frame = CGRectMake(0, self.searchBar.viewBottom, self.view.viewWidth, self.view.viewHeight - self.searchBar.viewBottom - _keyboardHeight);
}

#pragma mark - keyboard event
- (BOOL)ff_shouldRegisterKeyboardEvent {
    return YES;
}

- (void)ff_keyboardHeightChanged:(CGFloat)newHeight {
    _keyboardHeight = newHeight;
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = CGRectMake(0, self.searchBar.viewBottom, self.view.viewWidth, self.view.viewHeight - self.searchBar.viewBottom - _keyboardHeight);
    }];
}

#pragma mark - private helpers
- (void)showKeyboard {
    if ([self.searchBar canBecomeFirstResponder]) {
        [self.searchBar becomeFirstResponder];
    }
}

- (void)hideKeyboard {
    if ([self.searchBar canResignFirstResponder]) {
        [self.searchBar resignFirstResponder];
    }
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
    if (indexPath.row < [self.viewModel.objects count])
    {
        [self hideKeyboard];
        ffCharacterModel *pCharacter = self.viewModel.objects[indexPath.row];
        ffHeroDetailViewController *detailVC = [[ffHeroDetailViewController alloc] initWithCharacterId:[pCharacter.idField longLongValue]];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark - UIScrollDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self hideKeyboard];
}

#pragma mark - lazy load
- (UISearchBar *)searchBar {
    if (NOT _searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.delegate = self;
    }
    return _searchBar;
}


#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText length] <= 0) return;
    self.viewModel.keyword = searchText;
    [self.viewModel tryLoadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.viewModel.keyword = searchBar.text;
    [self.viewModel tryLoadData];
    [self hideKeyboard];
}


@end
