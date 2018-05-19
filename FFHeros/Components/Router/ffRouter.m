//
//  ffRouter.m
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/19.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffRouter.h"

@interface ffRouter ()
@property (nonatomic, strong) NSDictionary<NSString *, id> *allRouter;
@end

@implementation ffRouter

+ (ffRouter *)shared {
    static ffRouter *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ffRouter alloc] init];
    });
    return _instance;
}

- (void)map:(NSString *)router toViewController:(Class)vcClass {
    return;
}



@end
