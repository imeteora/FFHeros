//
// Created by ZhuDelun on 2018/5/17.
// Copyright (c) 2018 ZhuDelun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "gtModelizable.h"
#import "ffCharacterDataContainerModel.h"


/**
 This method fetches a single character resource. It is the canonical URI for any character resource provided by the API.
 */
@interface ffFetchCharacterInfoApi : gtModelizable

/**
 This method fetches a single character resource. It is the canonical URI for any character resource provided by the API.

 @param characterId character's id
 @param completeHandler the success callback lambda block
 @param errorHandler the error callback lambda block
 */
- (void)requestWithCharacterId:(NSString *_Nonnull)characterId afterComplete:(void (^__nullable)(ffCharacterDataContainerModel * __nullable))completeHandler ifError:(void (^__nullable)(NSError * __nullable, id __nullable ))errorHandler;

@end
