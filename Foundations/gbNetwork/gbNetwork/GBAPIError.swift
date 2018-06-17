//
//  gbApiError.swift
//  gbNetwork
//
//  Created by ZhuDelun on 2018/6/17.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

import Foundation

struct GBAPIError {
    enum Domain: String {
        /// 对应NSURLErrorDomain，应对网络错误
        /// - error.code为NSURLError的code
        case Network = "com.gbNetwork.error.network"
        /// 对应服务端返回的数据解析错误
        case Parser = "com.gbNetwork.error.parser"
        /// 对应服务器返回的4xx和5xx错误
        case Server = "com.gbNetwork.error.server"
        /// 对应服务端返回的数据中，功能性逻辑错误
        /// - error.code 为业务方对应的逻辑错误码
        case Feature = "com.gbNetwork.error.feature"
    }
    enum ErrorCode: Int {
        case Unknown = 0
        case Code4xx = 256
        case Code5xx
        case Serialization
        case InvalidResult  // api特定逻辑错误码
    }
}
