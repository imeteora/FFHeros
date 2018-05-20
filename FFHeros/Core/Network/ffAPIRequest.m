//
//  ffAPIRequest.m
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/15.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffAPIRequest.h"
#import "ffApiSignHelper.h"
#import "ffApiError.h"

@interface ffApiOperationQueue : NSOperationQueue <NSURLSessionDelegate>
{
    NSURLSession *_session;
}
@end

@implementation ffApiOperationQueue
+ (ffApiOperationQueue *)shared {
    static ffApiOperationQueue *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ffApiOperationQueue alloc] init];
        _instance.maxConcurrentOperationCount = 6;
    });
    return _instance;
}

- (NSURLSession *)session {
    if (_session == nil) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    }
    return _session;
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

@interface ffAPIRequest ()
{
    NSURLSessionTask *task;
    NSURLSession *session;
    ffAPIConfig *_requestConfig;
    NSThread    *_currentThread;
    BOOL _isFinished;
    BOOL _isCanceled;
    BOOL _isRequested;
}

@property (nonatomic, strong, nonnull) BOOL (^preRequestHandler)(NSString *);
@property (nonatomic, strong, nonnull) void (^postRequestHandler)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable);
@property (nonatomic, strong) NSMutableURLRequest *request;
@end

@implementation ffAPIRequest

- (instancetype)initWithConfig:(ffAPIConfig *)config {
    if (self = [self init]) {
        _requestConfig = config;
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        _currentThread = [NSThread currentThread];
        _isFinished = NO;
        _isCanceled = NO;
        _isRequested = NO;
    }
    return self;
}

- (void)dealloc {
    [self didCanceledRequestOperation];
}

#pragma mark - public helpers
- (void)requestAsync {
    NSAssert(_currentThread == [NSThread currentThread], @"ffApiRquest: current thread is not same as one when request be created.");
    if (NOT _isRequested) {
        _isRequested = YES;
        [[ffApiOperationQueue shared] addOperation:self];
    } else {
        NSAssert(NO, @"ffApiRequest: current http request had been already established.");
    }
    return;
}

#pragma mark - private helpers
- (void)main
{
    weakify(self);
    BOOL (^preHttpRequestBlock)(NSString *url) = ^BOOL(NSString *url) {
        return YES;
    };

    void (^postHttpRequestBlock)(NSData *_Nullable, NSURLResponse * _Nullable, NSError * _Nullable) = ^(NSData *_Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        strongify(self);
        if (data == nil OR error) {
            if (self.errorHandler) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.errorHandler(error, nil);
                });
            }
        }
        else {
            NSError *error = nil;
            NSDictionary *jsonDict = [self _deserializeData:data response:response ifErrorOrNot:&error];
#if DEBUG
            NSLog(@"---- query success ----\n %@ \n------------------", jsonDict);
#endif  // DEBUG
            if (jsonDict == nil OR error) {
                if (self.errorHandler) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.errorHandler(error, jsonDict);
                    });
                }
            } else {
                NSDictionary<NSString *, id> * result = [self _mappingModelFrom:jsonDict errorIfError:&error];
                if (self.compleleHandler) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.compleleHandler(result);
                    });
                }
            }
        }
    };

    [self _makeRequestOperationWithPreOp:preHttpRequestBlock andPostOp:postHttpRequestBlock];
    [self _establish];

    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:60]];
}


- (void)_makeRequestOperationWithPreOp:(BOOL (^)(NSString *))preRequestBlock andPostOp:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))postRequestBlock
{
    weakify(self);
    self.preRequestHandler = preRequestBlock;
    self.postRequestHandler = ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        strongify(self);
        postRequestBlock(data, response, error);
        [self didCanceledRequestOperation];
    };

    NSMutableURLRequest *request = nil;

    NSString *queryString = [self _quertyString];

    if (_requestConfig.method == FFApiRequestMethodGET) {
        NSString *requestUrlStr = nil;
        if ([queryString length]) {
            requestUrlStr = [NSString stringWithFormat:@"%@?%@", _requestConfig.baseURL, queryString];
        } else {
            requestUrlStr = _requestConfig.baseURL;
        }

        NSURL *requestUrl = [NSURL URLWithString:requestUrlStr];
        request = [NSMutableURLRequest requestWithURL:requestUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:(_requestConfig.timeout > 0?:60)];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
        [request setValue:@"*/*" forHTTPHeaderField:@"Accept"];
        [request setValue:@"en-us" forHTTPHeaderField:@"Accept-Language"];
        [request setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];

    } else if (_requestConfig.method == FFApiRequestMethodPOST) {
        NSString *requestUrlStr = _requestConfig.baseURL;
        NSURL *requestUrl = [NSURL URLWithString:requestUrlStr];
        request = [NSMutableURLRequest requestWithURL:requestUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:(_requestConfig.timeout > 0?:60)];
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

#if DEBUG
    NSLog(@"----\n request URL: %@\n ----", request.URL.absoluteString);
#endif  // DEBUG

    
    self.request = [request mutableCopy];
}


- (void)_establish
{
    NSAssert(self.request, @"HTTP request has no available url request instance.");
    NSAssert(self.preRequestHandler, @"HTTP request has no available pre operation callback handler");
    NSAssert(self.postRequestHandler, @"HTTP request has no available url response callback handler");

    if (! self.preRequestHandler(self.request.URL.absoluteString)) {
        [self didCanceledRequestOperation];
        return;
    }
    __block NSData *retData = nil;
    __block NSURLResponse *retResponse = nil;
    __block NSError *retError = nil;
    __block BOOL hadBeHandled = NO;

    dispatch_semaphore_t _semaphore = dispatch_semaphore_create(0);
    task = [[[ffApiOperationQueue shared] session] dataTaskWithRequest:[self.request mutableCopy] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
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
                                   userInfo:@{NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:@"%@, %@, %lld", [NSDate date], self.request.URL.absoluteString, (int64_t)(self.request.timeoutInterval)]}];
    }
    self.postRequestHandler(retData, retResponse, retError);
}




- (NSString *)_quertyString {
    NSMutableDictionary<NSString *, NSString *> *mutableParms = [[NSMutableDictionary alloc] init];
    [mutableParms addEntriesFromDictionary:_requestConfig.params];
    if (_requestConfig.signType == FFApiSignOAuthServer) {
        mutableParms[_requestConfig.signKey] = [ffApiSignHelper signQueryFrom:_requestConfig.authSignStringOfRequest];
    } else if (_requestConfig.signType == FFApiSignOAuthClient) {
        mutableParms[_requestConfig.signKey] = _requestConfig.authSignStringOfRequest;
    }

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

- (nullable NSDictionary *)_deserializeData:(NSData *)data response:(NSURLResponse * _Nonnull)response ifErrorOrNot:(NSError * __autoreleasing _Nonnull * _Nullable)errorPtr
{
    if (NOT data) return nil;
    id x = [NSJSONSerialization JSONObjectWithData:data options:0 error:errorPtr];
    if (errorPtr != nil AND *errorPtr) {
        *errorPtr = [NSError errorWithDomain:ffApiErrorDomainParser code:ffApiRequestErrorCodeSerialization userInfo:nil];
        return nil;
    }
    if (NOT [x isKindOfClass:[NSDictionary class]]) {
        *errorPtr = [NSError errorWithDomain:ffApiErrorDomainFeature code:ffApiNetworkErrorCodeInvalidResult userInfo:nil];
        return nil;
    }
    return x;
}

- (nullable NSDictionary<NSString *, id> *)_mappingModelFrom:(NSDictionary * _Nonnull)jsonDict errorIfError:(NSError * _Nonnull __autoreleasing * _Nullable)error {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    for (id each_model in _requestConfig.modelDescriptions) {
        NSAssert([each_model isKindOfClass:[ffAPIModelDescription class]], @"ffApiRequest: invalid model reflect description model.");
        ffAPIModelDescription *each_desc = (ffAPIModelDescription *)each_model;
        id x = [ffAPIModelDescription findObjectByKeyPath:each_desc.keyPath inObject:jsonDict];
        if (x) {
            if ([x isKindOfClass:[NSDictionary class]]) {
                Class clsTarget = each_desc.mappingClass;
                id objTarget = [[clsTarget alloc] initWithDictionary:((NSDictionary *) x)];
                if (objTarget) {
                    result[each_desc.keyPath] = objTarget;
                }
            } else if ([x isKindOfClass:[NSArray class]]) {
                NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[(NSArray *)x count]];
                for (id sub_value in ((NSArray *)x)) {
                    NSAssert([sub_value isKindOfClass:[NSDictionary class]], @"ffApiRequest: dictiona is needed in the leaf node");
                    Class clsTarget = each_desc.mappingClass;
                    id objTarget = [[clsTarget alloc] initWithDictionary:((NSDictionary *) sub_value)];
                    if (objTarget) {
                         [tmpArray addObject:objTarget];
                    }
                }
                result[each_desc.keyPath] = tmpArray;
            }
        }
    }
    return result;
}

#pragma mark - ffApiRequestOperationDelegate
- (void)didCanceledRequestOperation
{
    @synchronized(self) {
        self->session = nil;
        self->task = nil;
        self->_requestConfig = nil;
        self->_isCanceled = YES;
        self->_isFinished = YES;
        self->_isRequested = YES;
    }
}

@end
