//
//  ffAPIConfig.m
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/15.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffAPIConfig.h"

@implementation ffAPIConfig

- (instancetype)init {
    if (self = [super init]) {
        _timeout = 30;
    }
    return self;
}

- (nullable NSString *)authSignStringOfRequest {
    return @"";
}

- (nullable NSDictionary<NSString *,NSString *> *)authSignDictOfRequest {
    return @{};
}

@end
