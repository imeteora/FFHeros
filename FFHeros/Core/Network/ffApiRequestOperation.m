//
//  ffApiRequestOperation.m
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/15.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffApiRequestOperation.h"
#import "ffApiRequestOperationQueue.h"
#import "ffApiError.h"

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

//        NSCondition *condition = [[NSCondition alloc] init];
        __block NSData *retData = nil;
        __block NSURLResponse *retResponse = nil;
        __block NSError *retError = nil;

        __block BOOL hadBeHandled = NO;

        dispatch_semaphore_t _semaphore = dispatch_semaphore_create(0);
        [self _sessionTaskWithRequest:self.request completeHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (NOT hadBeHandled) {
                hadBeHandled = YES;
                retData = data;
                retResponse = response;
                retError = error;
            }

            dispatch_semaphore_signal(_semaphore);
//            [condition signal];
        }];

//        [condition lock];
//        [condition waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:MAX(self.request.timeoutInterval, 60)]];
        dispatch_semaphore_wait(_semaphore, dispatch_time(DISPATCH_TIME_NOW, 60 * NSEC_PER_SEC));

        if (NOT hadBeHandled) {
            hadBeHandled = YES;
            retError = [NSError errorWithDomain:ffApiErrorDomainNetwork code:NSURLErrorTimedOut
                                       userInfo:@{NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:@"%@, %@, %lld", [NSDate date], self.request.URL.absoluteString, (int64_t)(self.request.timeoutInterval)]}];
        }

//        [condition unlock];
        if (self.isCancelled) {
            return;
        }
        self.postRequestHandler(retData, retResponse, retError);
    }
}

- (void)cancel {
    if (_delegate AND [_delegate respondsToSelector:@selector(didCanceledRequestOperation:)]) {
        [_delegate didCanceledRequestOperation:self];
    }
}

#pragma mark - private helpers
- (void)_sessionTaskWithRequest:(NSURLRequest *)request completeHandler:(void (^_Nullable)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completeBlock {
    [[[[ffApiRequestOperationQueue shared] session] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (completeBlock) {
            completeBlock(data, response, error);
        }
    }] resume];
}

@end
