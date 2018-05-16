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
        _method = FFApiRequestMethodGET;
        _signType = FFApiSignOAuthServer;
        _signKey = @"hash";
    }
    return self;
}

- (NSDictionary<NSString *,NSString *> *)getFinalParams {
    NSMutableDictionary<NSString *, NSString *> *result = [[NSMutableDictionary alloc] init];
    [result setObject:[self ts] forKey:@"ts"];
    [result setObject:MARVEL_API_PUB_KEY forKey:@"apikey"];
    [result addEntriesFromDictionary:_params];
    return result;
}

- (nullable NSString *)authSignStringOfRequest {
    return [NSString stringWithFormat:@"%@%@%@", [self ts], MARVEL_API_PRV_KEY, MARVEL_API_PUB_KEY];
}

- (nullable NSDictionary<NSString *,NSString *> *)authSignDictOfRequest {
    return @{};
}


- (nonnull NSString *)ts {
    static NSString * __ts = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __ts = [NSString stringWithFormat:@"%lld", (int64_t)[[NSDate date] timeIntervalSince1970]];
    });
    return __ts;
}
@end
