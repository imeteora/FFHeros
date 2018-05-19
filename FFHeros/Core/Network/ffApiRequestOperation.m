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


@interface ffApiRequestOperation () <NSURLSessionDelegate>
@end

@implementation ffApiRequestOperation

- (void)dealloc {
    NSLog(@"%@[%@] dealloc", NSStringFromClass([self class]), [self description]);
}

- (void)establish:(BOOL)nowOrNot {
    if (nowOrNot) {
        [self main];
    } else {
        weakify(self);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            strongify(self);
            [self main];
        });
    }
//    if (nowOrNot) {
//        [self main];
//    } else {
//        [[ffApiRequestOperationQueue shared] addOperation:self];
//    }
}

- (void)main {
    NSAssert(self.request, @"HTTP request has no available url request instance.");
    NSAssert(self.preRequestHandler, @"HTTP request has no available pre operation callback handler");
    NSAssert(self.postRequestHandler, @"HTTP request has no available url response callback handler");
//    @autoreleasepool {
        if (! self.preRequestHandler) {
            if (_delegate && [_delegate respondsToSelector:@selector(didCanceledRequestOperation:)]) {
                [_delegate didCanceledRequestOperation:self];
            }
            return;
        }
        __block NSData *retData = nil;
        __block NSURLResponse *retResponse = nil;
        __block NSError *retError = nil;

        __block BOOL hadBeHandled = NO;

        dispatch_semaphore_t _semaphore = dispatch_semaphore_create(0);
        NSMutableURLRequest *request = [self.request mutableCopy];
        NSURLSessionTask *task = [self _sessionTaskWithRequest:request  completeHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (NOT hadBeHandled) {
                hadBeHandled = YES;
                retData = data;
                retResponse = response;
                retError = error;
            }
            dispatch_semaphore_signal(_semaphore);
        }];
        [task resume];

        dispatch_semaphore_wait(_semaphore, dispatch_time(DISPATCH_TIME_NOW, 60 * NSEC_PER_SEC));

        if (NOT hadBeHandled) {
            hadBeHandled = YES;
            retError = [NSError errorWithDomain:ffApiErrorDomainNetwork code:NSURLErrorTimedOut
                                       userInfo:@{NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:@"%@, %@, %lld", [NSDate date], request.URL.absoluteString, (int64_t)(request.timeoutInterval)]}];
        }

//        if (self.isCancelled) {
//            return;
//        }
        self.postRequestHandler(retData, retResponse, retError);
//    }
}

- (void)cancel {
    if (_delegate AND [_delegate respondsToSelector:@selector(didCanceledRequestOperation:)]) {
        [_delegate didCanceledRequestOperation:self];
    }
}

#pragma mark - private helpers
- (NSURLSessionTask *)_sessionTaskWithRequest:(NSURLRequest *)request completeHandler:(void (^_Nullable)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completeBlock {
    return [[[ffApiRequestOperationQueue shared] session] dataTaskWithRequest:request
                                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
#if DEBUG
                                                                NSLog(@"<<< data arrived from: %@", request.URL.absoluteString);
#endif  // DEBUG
                                                                if (completeBlock) {
                                                                    completeBlock(data, response, error);
                                                                }
                                                            }];
}

#pragma mark - NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge.protectionSpace.host containsString:@"marvel.com"]) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
            return;
        }
    }
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, challenge.proposedCredential);
}

@end
