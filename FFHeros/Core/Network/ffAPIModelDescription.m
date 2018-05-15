//
//  ffAPIModelDescription.m
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/15.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffAPIModelDescription.h"

@implementation ffAPIModelDescription

+ (instancetype)modelWith:(NSString *)keyPath toMappingClass:(Class)mappingClass isArray:(BOOL)isArray
{
    NSAssert(((keyPath != nil) && ([keyPath length] > 0)), @"key path for deserialization is needed.");
    NSAssert((mappingClass != Nil), @"class for deserialization is needed.");

    ffAPIModelDescription *result = [[ffAPIModelDescription alloc] init];
    result.keyPath = keyPath;
    result.mappingClass = mappingClass;
    result.isArray = isArray;
    return result;
}

@end
