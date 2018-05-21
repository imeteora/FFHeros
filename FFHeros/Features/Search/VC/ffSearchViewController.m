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
#import "ffNavigationControllerProtocol.h"
#import "ffFavouriteHelper.h"

#import "UIView+ffExt.h"
#import "UIView+WebImage.h"

@interface ffSearchViewController () <UISearchBarDelegate, UIScrollViewDelegate, ffNavigationControllerProtocol, ffHeroInfoTableViewCellDelegate> {
    CGFloat _keyboardHeight;
}
@property (nonatomic, strong) ffSearchViewModel *viewModel;
@property (nonatomic, strong) UISearchBar *searchBar;
@end

@implementation ffSearchViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Search";
    
    _keyboardHeight = 0;
    self.view.backgroundColor = [UIColor whiteColor];
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
    if (indexPath.row < [self.viewModel.objects count])
    {
        [self hideKeyboard];
        ffCharacterModel *pCharacter = self.viewModel.objects[indexPath.row];
        [[ffNavigationHelper shared] showHeroInfoViewController:(int64_t)[pCharacter.idField longLongValue]];
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
        _searchBar.showsCancelButton = YES;
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

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self ff_back];
}


@end
