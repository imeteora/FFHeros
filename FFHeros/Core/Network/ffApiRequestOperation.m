//
//  ffApiRequestOperation.m
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/15.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffApiRequestOperation.h"
#import "ffApiRequestOperationQueue.h"

@implementation ffApiRequestOperation

- (void)establish:(BOOL)nowOrNot {
    if (nowOrNot) {
        [self main];
    } else {
        [[ffApiRequestOperationQueue shared] addOperation:self];
    }
}

- (void)main {
    NSAssert(self.request, @"HTTP request has no available url request instance.");
    NSAssert(self.preRequestHandler, @"HTTP request has no available pre operation callback handler");
    NSAssert(self.postRequestHandler, @"HTTP request has no available url response callback handler");
    @autoreleasepool {
        if (! self.preRequestHandler) {
            if (_delegate && [_delegate respondsToSelector:@selector(didCanceledRequestOperation:)]) {
                [_delegate didCanceledRequestOperation:self];
            }
            return;
        }
    }
}

@end
