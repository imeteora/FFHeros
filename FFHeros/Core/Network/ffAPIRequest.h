//
//  ffAPIRequest.h
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/15.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ffAPIConfig.h"

@interface ffAPIRequest : NSObject

/**
 the callback lambda function when web request returns successfully
 */
@property (nonatomic, nullable, copy) void (^compleleHandler)(NSDictionary * _Nonnull);

/**
 the callback lambda function when any error occurs during web request.
 */
@property (nonatomic, nullable, copy) void (^errorHandler)(NSError * _Nonnull, NSDictionary * _Nullable);

+ (_Nullable instancetype)new UNAVAILABLE_ATTRIBUTE;

- (_Nullable instancetype)initWithConfig:(ffAPIConfig * _Nonnull)config;

- (void)requestAsync;
- (void)requestSync;

@end
