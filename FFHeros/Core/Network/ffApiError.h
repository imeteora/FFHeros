//
//  ffApiError.h
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/16.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 对应NSURLErrorDomain，应对网络错误
 @remark error.code为NSURLError的code
 */
#define ffApiErrorDomainNetwork     @"com.farfetch.error.network"

/**
 对应服务端返回的数据解析错误
 */
#define ffApiErrorDomainParser      @"com.farfetch.error.parser"

/**
 对应服务器返回的4xx和5xx错误
 */
#define ffApiErrorDomainServer      @"com.farfetch.error.server"

/**
 对应服务端返回的数据中，功能性逻辑错误
 @remark error.code为业务方对应的逻辑错误码
 */
#define ffApiErrorDomainFeature      @"com.farfetch.error.feature"


typedef enum : NSUInteger {
    ffApiRequestErrorCodeUnknown = 0,
    ffApiRequestErrorCode4xx = 256,
    ffApiRequestErrorCode5xx,
    ffApiRequestErrorCodeSerialization,
    ffApiNetworkErrorCodeInvalidResult,     // api特定逻辑错误码
} ffApiRequestErrorCode;


@interface ffApiError : NSObject

@end
