//
//  ffAPIRequest.m
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/15.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffAPIRequest.h"
#import "ffApiRequestOperation.h"
#import "ffApiSignHelper.h"

@interface ffAPIRequest () <ffApiRequestOperationDelegate>
{
    ffApiRequestOperation *_requestOperation;
    ffAPIConfig *_requestConfig;
    NSThread    *_currentThread;
    BOOL _isFinished;
    BOOL _isCanceled;
    BOOL _isRequested;
}
@end

@implementation ffAPIRequest

- (instancetype)initWithConfig:(ffAPIConfig *)config {
    if (self = [super init]) {

    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        _requestOperation = [[ffApiRequestOperation alloc] init];
        _currentThread = [NSThread currentThread];
        _isFinished = NO;
        _isCanceled = NO;
        _isRequested = NO;
    }
    return self;
}

#pragma mark - public helpers
- (void)requestSync {
    NSAssert(_currentThread == [NSThread currentThread], @"ffApiRquest: current thread is not same as one when request be created.");
    if (NOT _isRequested) {
        _isRequested = YES;
        [self _queryNowOrNot:YES];
    } else {
        NSAssert(NO, @"ffApiRequest: current http request had been already established.");
    }
    return;
}

- (void)requestAsync {
    NSAssert(_currentThread == [NSThread currentThread], @"ffApiRquest: current thread is not same as one when request be created.");
    if (NOT _isRequested) {
        _isRequested = YES;
        [self _queryNowOrNot:NO];
    } else {
        NSAssert(NO, @"ffApiRequest: current http request had been already established.");
    }
    return;
}

#pragma mark - private helpers
- (void)_queryNowOrNot:(BOOL)bNowOrNot
{
    BOOL (^preHttpRequestBlock)(void) = ^BOOL{
        return YES;
    };

    void (^postHttpRequestBlock)(NSData *_Nullable, NSURLResponse * _Nullable, NSError * _Nullable) = ^(NSData *_Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

    };

    ffApiRequestOperation *operation = [self _makeRequestOperationWithPreOp:preHttpRequestBlock andPostOp:postHttpRequestBlock];
    _requestOperation = operation;
    [_requestOperation establish:bNowOrNot];
}


- (nullable ffApiRequestOperation *)_makeRequestOperationWithPreOp:(BOOL (^)(void))preRequestBlock andPostOp:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))postRequestBlock
{
    ffApiRequestOperation *result = [[ffApiRequestOperation alloc] init];
    result.preRequestHandler = preRequestBlock;
    result.postRequestHandler = ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        postRequestBlock(data, response, error);
        weakify(self);
        @synchronized(self) {
            strongify(self);
            self->_requestOperation = nil;
            self->_isCanceled = YES;
            self->_isFinished = YES;
            self->_isRequested = YES;
        }
    };

    NSMutableURLRequest *request = nil;
    if (NOT request) {
        NSString *queryString = [self _quertyString];

        if ([_requestConfig.authSignStringOfRequest length] > 0) {
            if ([queryString hasSuffix:@"&"]) {
                queryString = [queryString stringByAppendingString:_requestConfig.authSignStringOfRequest];
            } else {
                queryString = [queryString stringByAppendingFormat:@"&%@", _requestConfig.authSignStringOfRequest];
            }
        }

        if (_requestConfig.method == FFApiRequestMethodGET) {
            NSString *requestUrlStr = nil;
            if ([queryString length]) {
                requestUrlStr = [NSString stringWithFormat:@"%@?%@", _requestConfig.baseURL, queryString];
            } else {
                requestUrlStr = _requestConfig.baseURL;
            }
            NSURL *requestUrl = [NSURL URLWithString:requestUrlStr];
            request = [NSMutableURLRequest requestWithURL:requestUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:(_requestConfig.timeout > 0?:15)];
            [request setHTTPMethod:@"GET"];

        } else if (_requestConfig.method == FFApiRequestMethodPOST) {
            NSString *requestUrlStr = _requestConfig.baseURL;
            NSURL *requestUrl = [NSURL URLWithString:requestUrlStr];
            request = [NSMutableURLRequest requestWithURL:requestUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:(_requestConfig.timeout > 0?:15)];
            [request setHTTPMethod:@"POST"];

        } else if (_requestConfig.method == FFApiRequestMethodPUT) {
            NSAssert(NO, @"not implemented yet");
        } else if (_requestConfig.method == FFApiRequestMethodDELETE) {
            NSAssert(NO, @"not implemented yet");
        }

        // external http header if has some.
        for (NSString *each_key in _requestConfig.extHttpHeader.allKeys) {
            NSString *each_value = [_requestConfig.extHttpHeader valueForKey:each_key];
            [request setValue:each_value forHTTPHeaderField:each_key];
        }

        for (NSString *each_key in _requestConfig.authSignDictOfRequest.allKeys) {
            NSString *each_value = [_requestConfig.authSignDictOfRequest valueForKey:each_key];
            [request setValue:each_value forHTTPHeaderField:each_key];
        }

        NSData *httpBodyData = [self _queryBodyFromQuery:queryString];
        if (httpBodyData) {
            [request setHTTPBody:httpBodyData];
        }
    }
    
    result.request = request;
    return result;
}

- (NSString *)_quertyString {
    NSMutableDictionary<NSString *, NSString *> *mutableParms = [[NSMutableDictionary alloc] init];
    if (_requestConfig.signType != FFApiSignNone) {
        mutableParms[_requestConfig.signKey] = [ffApiSignHelper signQueryFrom:_requestConfig.authSignStringOfRequest];
    }
    [mutableParms addEntriesFromDictionary:_requestConfig.params];

    NSMutableArray<NSString *> *all_params = [[NSMutableArray alloc] init];
    [mutableParms enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *param_pair = [NSString stringWithFormat:@"%@=%@", key, obj];
        [all_params addObject:param_pair];
    }];

    NSString *finalQuery = [all_params componentsJoinedByString:@"&"];
    return finalQuery;
}

- (nullable NSData *)_queryBodyFromQuery:(NSString *)query {
    if (_requestConfig.method == FFApiRequestMethodGET) return nil;
    return [query dataUsingEncoding:kCFStringEncodingUTF8];
}


#pragma mark - ffApiRequestOperationDelegate
- (void)didCanceledRequestOperation:(ffApiRequestOperation *)requestOperation {
    if (_requestOperation == requestOperation) {
        _requestOperation = nil;
    }
}

@end
