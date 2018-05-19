//
//  ffApiRequestQueue.m
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/15.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffApiRequestOperationQueue.h"

@interface ffApiRequestOperationQueue () <NSURLSessionDelegate>
{
    NSURLSession *_session;
}
@end

@implementation ffApiRequestOperationQueue

+ (_Nonnull instancetype)shared
{
    static ffApiRequestOperationQueue *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ffApiRequestOperationQueue alloc] init];
        _instance.maxConcurrentOperationCount = 5;
        _instance->_session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:_instance delegateQueue:nil];
    });
    return _instance;
}

- (NSURLSession *)session {
    return self->_session;
}

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
