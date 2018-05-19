//
//  ffHeroDetailViewModel.m
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/19.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffHeroDetailViewModel.h"
#import "ffFetchCharactersInfoApi.h"

@interface ffHeroDetailViewModel ()
@property (nonatomic, strong, readwrite) ffCharacterModel *heroData;
@end

@implementation ffHeroDetailViewModel

- (instancetype)initWithCharacterId:(int64_t)cid {
    if (self = [super init]) {
        _cid = cid;
    }
    return self;
}

- (void)loadData
{
    weakify(self);
    ffFetchCharactersInfoApi *api = [[ffFetchCharactersInfoApi alloc] init];
    [api requestWithCharacterId:[@(self.cid) stringValue] afterComplete:^(ffCharacterModel *model) {
        strongify(self);
        self.heroData = model;
        self.isLoading = NO;
        self.isEnd = YES;
        self.error = nil;
    } ifError:^(NSError *error, id o) {
        strongify(self);
        self.isLoading = NO;
        self.isEnd = YES;
        self.error = error;
    }];
    return;
}


@end
