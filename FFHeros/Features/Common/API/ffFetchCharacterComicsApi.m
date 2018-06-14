//
//  ffFetchCharacterComicsApi.m
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/17.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffFetchCharacterComicsApi.h"
#import "ffAPIConfig.h"
#import "ffAPIRequest.h"

@implementation ffFetchCharacterComicsApi

- (void)requestWithCharacterId:(NSString *)cid afterComplete:(void (^)(ffComicsModel *))completeHandler ifError:(void (^)(NSError * _Nullable, id _Nullable))errorHandler {
    ffAPIConfig *config = [[ffAPIConfig alloc] init];
    config.baseURL = [NSString stringWithFormat:@"%@/v1/public/characters/%@/comics", MARVEL_BASE_URL, cid];
    config.method = FFApiRequestMethodGET;
    config.modelDescriptions = @[[ffAPIModelDescription modelWith:@"/data/results" toMappingClass:[ffComicsModel class]]];

    ffAPIRequest *request = [[ffAPIRequest alloc] initWithConfig:config];
    [request setCompleteHandler:^(NSDictionary * _Nonnull result) {
        if (completeHandler) {
            completeHandler(result[@"/data/results"]);
        }
    }];
    [request setErrorHandler:^(NSError * _Nonnull error, NSDictionary * _Nullable result) {
        if (errorHandler) {
            errorHandler(error, result);
        }
    }];
    [request requestAsync];
}

@end
