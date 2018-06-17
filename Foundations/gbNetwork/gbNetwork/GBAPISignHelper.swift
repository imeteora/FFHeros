//
//  gbAPIHelper.swift
//  gbNetwork
//
//  Created by Zhu Delun on 2018/6/19.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

import Foundation
import gbUtils

class GBAPISignHelper {
    static func signQuery(fromParameter param: [String: String], withOrder order: [String]) -> String {
        guard order.count == param.count else {

            return ""
        }

        var paramsArray: [String] = []
        for eachKey in order {
            if param.keys.contains(eachKey), let eachValue = param[each_key] {
                paramsArray.append("\(eachKey)=\(eachValue)")
            }
        }

        if paramsArray.isEmpty {

            return ""
        }

        return signQuery(fromParameter: paramsArray, withPathComponent: "&")
    }

    static func signQuery(fromParameter param: [String], withPathComponent component: String = "") -> String {
        if param.isEmpty == false, let result = param.joined(separator: ((!component.isEmpty) ? component : "")) {

            return signQuery(fromParameter: result)
        } else {

            return ""
        }
    }

    static func signQuery(fromParameter param: String) -> String {
        guard param.isEmpty == false else {

            return ""
        }

        return param.md5()
    }
}
