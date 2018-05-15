//
//  ffApiSignHelper.m
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/15.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffApiSignHelper.h"
#import "DESUtils.h"

@implementation ffApiSignHelper

+ (NSString *_Nullable)signQueryFrom:(nonnull NSDictionary<NSString *,NSString *> *)param withOrder:(nonnull NSArray<NSString *> *)order
{
    if ([order count] != [param.allKeys count]) return nil;

    NSMutableArray<NSString *> *tmpParamsArray = [[NSMutableArray alloc] init];

    for (NSString *each_key in order) {
        if (NOT [param.allKeys containsObject:each_key]) {
            return nil;
        }
        NSString *each_value = [param valueForKey:each_key];
        [tmpParamsArray addObject:[NSString stringWithFormat:@"%@=%@", each_key, each_value]];
    }
    if ([tmpParamsArray count] == 0) return nil;

    return  [self signQueryFrom:tmpParamsArray withCombineComponent:@"&"];
}

+ (NSString *_Nullable)signQueryFrom:(nonnull NSArray<NSString *> *)param withCombineComponent:(NSString *_Nullable)component {
    if ([param count] == 0) return nil;

    NSString *result = [param componentsJoinedByString:(component?:@"")];
    result = [self signQueryFrom:result];
    return result;
}

+ (NSString *_Nullable)signQueryFrom:(nonnull NSString *)paramStr {
    if ([paramStr length] == 0) return nil;
    return [DESUtils MD5:paramStr];
}

@end

