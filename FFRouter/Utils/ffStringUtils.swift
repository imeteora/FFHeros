//
// Created by Zhu Delun on 2018/6/1.
// Copyright (c) 2018 ZhuDelun. All rights reserved.
//

import Foundation

class ff {
    class ffStringUtils {
        static func matchString(_ template: String, withSource source: String, separatedBy sep: String = " ") -> Bool {
            let sourceArr: [String] = source.components(separatedBy: sep)
            let tempArr: [String] = template.components(separatedBy: sep)

            var condition: Bool = true
            for (idx, eachTmp) in tempArr.enumerated() {
//                if eachTmp == "*" {
//                    continue
//                }

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
    }
}
