//
// Created by Zhu Delun on 2018/6/1.
// Copyright (c) 2018 ZhuDelun. All rights reserved.
//

import Foundation

public class gbURLUtils
{
    static public func isWebUrl(_ url:String!) -> Bool {
        let kRegStr = "^((?:(http|https|Http|Https|rtsp|Rtsp):\\/\\/(?:(?:[a-zA-Z0-9\\$\\-\\_\\.\\+\\!\\*\\'\\(\\)\\,\\;\\?\\&\\=]|(?:\\%[a-fA-F0-9]{2})){1,64}(?:\\:(?:[a-zA-Z0-9\\$\\-\\_\\.\\+\\!\\*\\'\\(\\)\\,\\;\\?\\&\\=]|(?:\\%[a-fA-F0-9]{2})){1,25})?\\@)?)?(?:(([a-zA-Z0-9\\u00A0-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFEF]([a-zA-Z0-9\\u00A0-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFEF\\-]{0,61}[a-zA-Z0-9\\u00A0-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFEF]){0,1}\\.)+[a-zA-Z0-9\\u00A0-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFEF]{2,63}|((25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9])\\.(25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[0-9]))))(?:\\:\\d{1,5})?)(\\/(?:(?:[a-zA-Z0-9\\u00A0-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFEF\\;\\/\\?\\:\\@\\&\\=\\#\\~\\-\\.\\+\\!\\*\\'\\(\\)\\,\\_])|(?:\\%[a-fA-F0-9]{2}))*)?(?:\\b|$)";
        let regUrlTextWebUrl = NSPredicate.init(format: "SELF MATCHES %@", kRegStr)
        if regUrlTextWebUrl.evaluate(with: url) {
            return true
        } else {
            return false
        }
    }

    static public func matchString(_ template: String, withSource source: String, separatedBy sep: String = " ") -> Bool {
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

    static public func parametersInQuery(_ url: String!) -> [String: String]! {
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
