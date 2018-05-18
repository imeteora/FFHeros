//
//  ffCharactersApi.m
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/16.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffFetchCharactersApi.h"
#import "ffCharacterDataContainerModel.h"
#import "ffAPIRequest.h"

@implementation ffFetchCharactersApi

- (void)requestAfterComplete:(void (^)(ffCharacterDataContainerModel * _Nonnull))completeBlock ifError:(void (^)(NSError * _Nonnull, id __nullable))errorBlock {
    ffAPIConfig *config = [[ffAPIConfig alloc] init];
    config.baseURL = MARVEL_BASE_URL@"/v1/public/characters";
    config.method = FFApiRequestMethodGET;
    config.params = [self gt_dictionaryWithKeyValues];
    config.modelDescriptions = @[[ffAPIModelDescription modelWith:@"/data" toMappingClass:[ffCharacterDataContainerModel class]]];

    ffAPIRequest *request = [[ffAPIRequest alloc] initWithConfig:config];
    [request setCompleleHandler:^(NSDictionary * _Nonnull result) {
        if (completeBlock) {
            completeBlock(result[@"/data"]);
        }
    }];

    [request setErrorHandler:^(NSError * _Nonnull error, NSDictionary * _Nullable result) {
        if (errorBlock) {
            errorBlock(error, result);
        }
    }];

    [request requestAsync];
}

@end
