//
//  ffFavListViewModel.h
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/20.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffBaseViewModel.h"
#import "ffFavouriteItemModel.h"

@interface ffFavListViewModel : ffBaseViewModel
@property (nonatomic, assign) int64_t cid;

- (int32_t)numberOfFavouriteList;
- (ffFavouriteItemModel *)itemAtIndex:(int32_t)index;

@end
