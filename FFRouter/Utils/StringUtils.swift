//
// Created by Zhu Delun on 2018/6/1.
// Copyright (c) 2018 ZhuDelun. All rights reserved.
//

import Foundation

class StringUtils
{
    
    static func matchString(_ template: String, withSource source: String, separatedBy sep: String = " ") -> Bool {
        let sourceArr: [String] = source.components(separatedBy: sep)
        let tempArr: [String] = template.components(separatedBy: sep)

        var condition: Bool = true
        for (idx, _) in tempArr.enumerated() {
            condition = true
            for (idxsrc, eachSrc) in sourceArr.enumerated() {
                if tempArr[idxsrc + idx] == "*" {
                    continue
                }
                condition = condition && tempArr[idxsrc + idx] == eachSrc
                if !condition {
                    break
                }
            }

            if condition == true {
                break
            }
        }

        return condition
    }

    static func parametersInQuery(_ url: String!) -> [String: String]! {
        if let queryRange = url.range(of: "?") {
            var result: [String: String] = [:]
            let queryStr: String = String(url[queryRange.upperBound ..< url.endIndex])

            if queryStr.isEmpty {
                return result
            }

            let queryArray: [String] = queryStr.components(separatedBy: "&")
            for (_, each_comp) in queryArray.enumerated() {
                let keyValue: [String] = each_comp.components(separatedBy: "=")
                result[keyValue[0]] = keyValue[1]
            }
            return result
        } else {
            return [:]
        }
    }
}
