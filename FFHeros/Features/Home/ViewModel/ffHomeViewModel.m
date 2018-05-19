//
//  ffHomeViewModel.m
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/19.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffHomeViewModel.h"
#import "ffFetchCharactersInfoApi.h"

static const uint32_t kPageSize = 20;

@interface ffHomeViewModel ()
@property (nonatomic, assign) int32_t remoteCursor;     // 远程数据的定位标记量
@end

@implementation ffHomeViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.remoteCursor = 0;
        self.isLoading = NO;
        self.isEnd = NO;
        self.tryLoaded = NO;
        self.error = nil;
    }
    return self;
}

- (void)loadData
{
    self.remoteCursor = 0;  // reset cursor

    ffFetchCharactersInfoApi *api = [[ffFetchCharactersInfoApi alloc] init];
    api.offset = @(self.remoteCursor);
    api.limit = @(kPageSize);

    weakify(self);
    [api requestAfterComplete:^(ffCharacterDataContainerModel * _Nonnull result) {
        strongify(self);
        if (result == nil) return;
        self.objects = result.results;
        self.isLoading = NO;
        self.isEnd = [result.results count] < kPageSize;
        self.error = nil;
    } ifError:^(NSError * _Nonnull error, id _Nullable result) {
        strongify(self);
        self.objects = ((self.objects)?:nil);
        self.isLoading = NO;
        self.isEnd = YES;
        self.error = error;
    }];
    return;
}

- (void)loadMoreData {
    self.remoteCursor = (int32_t)([self.objects count] - 1);
    
    ffFetchCharactersInfoApi *api = [[ffFetchCharactersInfoApi alloc] init];
    api.offset = @(self.remoteCursor);
    api.limit = @(kPageSize);

    weakify(self);
    [api requestAfterComplete:^(ffCharacterDataContainerModel * _Nonnull result) {
        strongify(self);
        self.objects = [self.objects arrayByAddingObjectsFromArray:result.results];
        self.isLoading = NO;
        self.isEnd = ([result.results count] < kPageSize);
        self.error = nil;
    } ifError:^(NSError * _Nonnull error, id _Nullable result) {
        strongify(self);
        self.objects = (self.objects?:nil);
        self.isLoading = NO;
        self.isEnd = YES;
        self.error = error;
    }];
}

@end
