//
// Created by ZhuDelun on 2018/5/17.
// Copyright (c) 2018 ZhuDelun. All rights reserved.
//

#import "ffFetchCharacterInfoApi.h"
#import "ffCharacterDataContainerModel.h"
#import "ffAPIConfig.h"
#import "ffAPIRequest.h"

@implementation ffFetchCharacterInfoApi

- (void)requestWithCharacterId:(NSString * _Nonnull)characterId
                 afterComplete:(void (^__nullable)(ffCharacterDataContainerModel * __nullable))completeHandler
                       ifError:(void (^__nullable)(NSError * __nullable, id __nullable ))errorHandler
{
    ffAPIConfig *config = [[ffAPIConfig alloc] init];
    config.baseURL = [NSString stringWithFormat:@"%@/v1/public/characters/%@", MARVEL_BASE_URL, characterId];
    config.method = FFApiRequestMethodGET;
    config.modelDescriptions = @[[ffAPIModelDescription modelWith:@"/data" toMappingClass:[ffCharacterDataContainerModel class]]];

    ffAPIRequest *request = [[ffAPIRequest alloc] initWithConfig:config];
    [request setCompleleHandler:^(NSDictionary *result) {
        if (completeHandler) {
            completeHandler(result[@"/data"]);
        }
    }];
    [request setErrorHandler:^(NSError *error, NSDictionary *result) {
        if (errorHandler) {
            errorHandler(error, result);
        }
    }];
    [request requestAsync];
}

@end
