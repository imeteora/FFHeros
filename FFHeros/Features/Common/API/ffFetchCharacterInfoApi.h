//
//  ffCharactersApi.h
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/16.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "gtModelizable.h"

@interface ffFetchCharacterInfoApi : gtModelizable
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

- (void)requestAfterComplete:(void (^_Nullable)(NSDictionary * _Nonnull))completeBlock ifError:(void (^_Nullable)(NSError * _Nonnull, id __nullable))errorBlock;

@end
