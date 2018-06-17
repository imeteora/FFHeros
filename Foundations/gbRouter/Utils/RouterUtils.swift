//
//  RouterUtils.swift
//  gbRouter
//
//  Created by derrick.zhu on 2018/8/8.
//  Copyright © 2018 GameBable Inc, Ltd. All rights reserved.
//

import Foundation

class RouterUtils {
    static func encodeUrl(_ url: String) -> String {
        if url.isEmpty == false, let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {

            return encodedUrl
        } else {

            return url
        }
    }

    static func decodeUrl(_ url: String) -> String {
        if url.isEmpty == false, let decodedUrl: String = url.removingPercentEncoding {

            return decodedUrl
        } else {

            return url
        }
    }
}
