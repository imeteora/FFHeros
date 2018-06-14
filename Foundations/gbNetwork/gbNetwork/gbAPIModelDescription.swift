//
//  gbAPIModelDescription.swift
//  gbNetwork
//
//  Created by ZhuDelun on 2018/6/15.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

import UIKit

@objcMembers
class gbAPIModelDescription: NSObject
{
    var keyPath: String?
    var mappingClass: AnyClass?

    static public func model(withKeyPath keyPath: String!, toMappingClass mappingCls: AnyClass!) -> gbAPIModelDescription {
        assert(keyPath.count > 0, "key path for deserialization is needed.")

        let result = gbAPIModelDescription()
        result.keyPath = keyPath
        result.mappingClass = mappingCls
        return result
    }

    static func findObjectBy(_ keyPath: String!, inResponse obj: [String: AnyObject]!) -> AnyObject? {
        return nil
    }

    static func fetchObjectIn(_ object: [String: AnyObject]!, keyPathArray keyPaths: [String]!) -> AnyObject? {
        return nil
    }
}
