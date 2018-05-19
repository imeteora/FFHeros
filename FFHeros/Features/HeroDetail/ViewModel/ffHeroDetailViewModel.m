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


- (int32_t)numberOfSection {
    if (self.heroData == nil) return 0;
    else return 5;
//    int32_t result = 1;
//    if (self.heroData.comics AND [self.heroData.comics.items count] > 0) {
//        result += 1;
//    }
//    if (self.heroData.events AND [self.heroData.events.items count] > 0) {
//        result += 1;
//    }
//    if (self.heroData.series AND [self.heroData.series.items count] > 0) {
//        result += 1;
//    }
//    if (self.heroData.stories AND [self.heroData.stories.items count] > 0) {
//        result += 1;
//    }
//    return result;
}

- (BOOL)containSection:(int32_t)section {
    if (section == 0) return (self.heroData != nil);
    if (section == 1) return ([self.heroData.comics.items count] > 0);
    if (section == 2) return ([self.heroData.events.items count] > 0);
    if (section == 3) return ([self.heroData.series.items count] > 0);
    if (section == 4) return ([self.heroData.stories.items count] > 0);
    return NO;
}

- (NSString *)titleOfSection:(int32_t)section {
    if (section == 1) return ([self containSection:section]? @"Comics": @"");
    if (section == 2) return ([self containSection:section]? @"Events": @"");
    if (section == 3) return ([self containSection:section]? @"Series": @"");
    if (section == 4) return ([self containSection:section]? @"Stories": @"");
    return @"";
}

- (int32_t)numberOfItemsInSection:(int32_t)section {
    if (self.heroData == nil) return 0;
    if (section == 0) return 1;
    if (section == 1) return (int32_t)[self.heroData.comics.items count];
    if (section == 2) return (int32_t)[self.heroData.events.items count];
    if (section == 3) return (int32_t)[self.heroData.series.items count];
    if (section == 4) return (int32_t)[self.heroData.stories.items count];
    return 0;
}

- (ffSummaryModel *)summaryDataForIndex:(int32_t)index inSection:(int32_t)section {
    if (section == 0) return nil;
    if (section == 1) return self.heroData.comics.items[index];
    if (section == 2) return self.heroData.events.items[index];
    if (section == 3) return self.heroData.series.items[index];
    if (section == 4) return self.heroData.stories.items[index];
    return nil;
}


@end
