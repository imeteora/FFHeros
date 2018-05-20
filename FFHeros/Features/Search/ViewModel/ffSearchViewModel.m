//
//  ffSearchViewModel.m
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/20.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffSearchViewModel.h"
#import "ffFetchCharactersInfoApi.h"

@implementation ffSearchViewModel

- (void)loadData {
    if ([self.keyword length] <= 0) {
        self.isLoading = NO;
        self.isEnd = YES;
        self.error = nil;
        return;
    }

    weakify(self);
    ffFetchCharactersInfoApi *api = [[ffFetchCharactersInfoApi alloc] init];
    [api setNameStartsWith:self.keyword];
    [api requestAfterComplete:^(ffCharacterDataContainerModel * _Nonnull result) {
        strongify(self);
        self.objects = result.results;
        self.isLoading = NO;
        self.isEnd = YES;
        self.error = nil;
    } ifError:^(NSError * _Nonnull error, id _Nullable result) {
        strongify(self);
        self.isLoading = NO;
        self.isEnd = YES;
        self.error = error;
    }];
}

@end
