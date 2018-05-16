//
// Created by ZhuDelun on 2018/5/17.
// Copyright (c) 2018 ZhuDelun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "gtModelizable.h"
#import "ffCharacterDataContainerModel.h"

@interface ffFetchCharacterInfoApi : gtModelizable

- (void)requestWithCharacterId:(NSString *_Nonnull)characterId afterComplete:(void (^__nullable)(ffCharacterDataContainerModel * __nullable))completeHandler ifError:(void (^__nullable)(NSError * __nullable, id __nullable ))errorHandler;

@end
