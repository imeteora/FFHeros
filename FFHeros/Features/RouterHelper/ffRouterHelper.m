//
//  ffRouterHelper.m
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/27.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffRouterHelper.h"
@import FFRouter;
#import "ffWebViewController.h"

@implementation ffRouterHelper

+ (ffRouterHelper *)shared {
    static ffRouterHelper *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ffRouterHelper alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [self registerRouters];
    }
    return self;
}


#pragma mark - private helpers
- (void)registerRouters {
    [[ffRouter shared] map:@"/browser" toClass:[ffWebViewController class]];
}

@end
