//
//  ffFavListViewModel.m
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/20.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffFavListViewModel.h"
#import "ffFavouriteHelper.h"

@implementation ffFavListViewModel

- (void)loadData {
    NSArray * const favRaw = [[ffFavouriteHelper shared] allFavourites];
    NSMutableArray * const objArray = [[NSMutableArray alloc] init];
    [favRaw enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            ffFavouriteItemModel *item = [[ffFavouriteItemModel alloc] initWithDictionary:obj];
            [objArray addObject:item];
        }
    }];
    self.objects = objArray;
    self.isLoading = NO;
    self.isEnd = YES;
    self.error = nil;
}


#pragma mark - public helpers
- (int32_t)numberOfFavouriteList {
    return (int32_t)[self.objects count];
}

- (ffFavouriteItemModel *)itemAtIndex:(int32_t)index {
    if (index < 0 OR index >= [self numberOfFavouriteList]) return nil;
    return self.objects[index];
}

@end
