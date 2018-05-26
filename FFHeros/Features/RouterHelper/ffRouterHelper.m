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
