//
//  ffAPIModelDescription.m
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/15.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffAPIModelDescription.h"

@implementation ffAPIModelDescription

+ (_Nonnull instancetype)modelWith:(NSString *)keyPath toMappingClass:(Class)mappingClass isArray:(BOOL)isArray
{
    NSAssert(((keyPath != nil) && ([keyPath length] > 0)), @"key path for deserialization is needed.");
    NSAssert((mappingClass != Nil), @"class for deserialization is needed.");

    ffAPIModelDescription *result = [[ffAPIModelDescription alloc] init];
    result.keyPath = keyPath;
    result.mappingClass = mappingClass;
    result.isArray = isArray;
    return result;
}


+ (_Nullable id)findObjectByKeyPath:(NSString * _Nonnull)keyPath inObject:(NSDictionary<NSString *, id> *)responseObj {
    if ([keyPath isEqualToString:@"/"]) {
        return responseObj;
    }
    NSArray<NSString *> *array = [keyPath componentsSeparatedByString:@"/"];
    NSMutableArray<NSString *> *keyPathArray = [[NSMutableArray alloc] init];
    [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (0 < [[obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]) {
            [keyPathArray addObject:obj];
        }
    }];

    NSString *key = [keyPathArray firstObject];
    if ([keyPathArray count] == 1) {
        return responseObj[key];
    }

    id value = responseObj[key];
    NSArray<NSString *> *tailKeyPathArray =  [keyPathArray subarrayWithRange:NSMakeRange(1, [keyPathArray count] - 1)];
    return [self fetchObjectIn:(NSDictionary<NSString *, id> *)value keyPathArray:tailKeyPathArray];
}

+ (_Nullable id)fetchObjectIn:(NSDictionary<NSString *, id> *)obj keyPathArray:(NSArray<NSString *> *)keyPathArray {
    NSString *key = [keyPathArray firstObject];
    if ([keyPathArray count] == 1) {
        return obj[key];
    }
    NSArray<NSString *> *tailKeyPathArray =  [keyPathArray subarrayWithRange:NSMakeRange(1, [keyPathArray count] - 1)];
    return [self fetchObjectIn:(NSDictionary<NSString *,id> *)obj[key] keyPathArray:tailKeyPathArray];
}

@end
