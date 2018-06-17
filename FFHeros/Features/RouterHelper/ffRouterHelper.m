//
//  ffRouterHelper.m
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/27.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffRouterHelper.h"
@import gbRouter;
#import "ffWebViewController.h"
#import "ffFavTableViewController.h"
#import "ffSearchViewController.h"
#import "ffHeroDetailViewController.h"

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
        [self registerRouterTransfers];
    }
    return self;
}


#pragma mark - private helpers
- (void)registerRouters {
    [[Router shared] map:@"/character/:cid" toClass:[ffHeroDetailViewController class]];
    [[Router shared] map:@"/browser" toClass:[ffWebViewController class]];
    [[Router shared] map:@"/favourite" toClass:[ffFavTableViewController class]];
    [[Router shared] map:@"/search" toClass:[ffSearchViewController class]];
}

- (void)registerRouterTransfers {

}

@end
