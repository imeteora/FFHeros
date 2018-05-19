//
//  ffCharactersApi.h
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/16.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "gt_Modelizable.h"
#import "ffCharacterDataContainerModel.h"

/**
 Fetches lists of comic characters with optional filters. See notes on individual parameters below.
 */
@interface ffFetchCharactersInfoApi : gt_Modelizable

/**
 Return only characters matching the specified full character name (e.g. Spider-Man).
 */
@property (nonatomic, nullable, copy) NSString *name;

/**
 Return characters with names that begin with the specified string (e.g. Sp).
 */
@property (nonatomic, nullable, copy) NSString *nameStartsWith;

/**
 Return only characters which have been modified since the specified date.
 */
@property (nonatomic, nullable, copy) NSString *modifiedSince;

/**
 Return only characters which appear in the specified comics (accepts a comma-separated list of ids).
 */
@property (nonatomic, nullable, copy) NSNumber *comics;

/**
 Return only characters which appear the specified series (accepts a comma-separated list of ids).
 */
@property (nonatomic, nullable, copy) NSNumber *series;

/**
 Return only characters which appear in the specified events (accepts a comma-separated list of ids).
 */
@property (nonatomic, nullable, copy) NSNumber *events;

/**
 Return only characters which appear the specified stories (accepts a comma-separated list of ids).
 */
@property (nonatomic, nullable, copy) NSNumber *stories;

/**
 Order the result set by a field or fields. Add a "-" to the value sort in descending order. Multiple values are given priority in the order in which they are passed.
 */
@property (nonatomic, nullable, copy) NSString *orderBy;

/**
 Limit the result set to the specified number of resources.
 */
@property (nonatomic, nullable, copy) NSNumber *limit;

/**
 Skip the specified number of resources in the result set.
 */
@property (nonatomic, nullable, copy) NSNumber *offset;

/**
 Fetches lists of comic characters with optional filters. See notes on individual parameters below.

 @param completeBlock the success callback lambda block
 @param errorBlock the error callback lambda block
 */
- (void)requestAfterComplete:(void (^_Nullable)(ffCharacterDataContainerModel * _Nonnull))completeBlock ifError:(void (^_Nullable)(NSError * _Nonnull, id __nullable))errorBlock;

/**
 This method fetches a single character resource. It is the canonical URI for any character resource provided by the API.

 @param characterId character's id
 @param completeHandler the success callback lambda block
 @param errorHandler the error callback lambda block
 */
- (void)requestWithCharacterId:(NSString *_Nonnull)characterId afterComplete:(void (^__nullable)(ffCharacterModel * __nullable))completeHandler ifError:(void (^__nullable)(NSError * __nullable, id __nullable ))errorHandler;

@end
