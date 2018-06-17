//
//  gbAPIModelDescription.swift
//  gbNetwork
//
//  Created by ZhuDelun on 2018/6/15.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

import UIKit

@objcMembers
class GBAPIModelDescription: NSObject {
    var keyPath: String?
    var mappingClass: AnyClass?

    /// create a model description for deserializing the json data which returns from remote server.
    ///
    /// - Parameters:
    ///   - keyPath: the key-path which client api focus on
    ///   - mappingCls: model which would be mapping from a json object
    /// - Returns: the instance of the model description
    static public func model(withKeyPath keyPath: String, toMappingClass mappingCls: AnyClass) -> GBAPIModelDescription {
        assert(keyPath.isEmpty == false, "key path for deserialization is needed.")

        let result = GBAPIModelDescription()
        result.keyPath = keyPath
        result.mappingClass = mappingCls

        return result
    }

    /// find object for json object with key-path
    ///
    /// - Parameters:
    ///   - keyPath: the key-path for a value
    ///   - responseObj: the result about finding json object, the result is nullable
    /// - Returns: json object data which looking by using key-path
    static func findObjectBy(_ keyPath: String,
                             inResponse responseObj: [String: AnyObject]) -> AnyObject? {

        if keyPath.elementsEqual("/") {

            return responseObj as AnyObject
        }

        let array: [String] = keyPath.components(separatedBy: "/")
        var keyPathArray: [String] = []

        for each_key_path in array {
            let obj = (each_key_path as NSString).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if !obj.isEmpty {
                keyPathArray.append(obj)
            }
        }

        if let key = keyPathArray.first {
            if keyPathArray.count == 1 {

                return responseObj[key]
            }

            if let value = responseObj[key] as? [String: AnyObject] {

                return _fetchObjectIn(value, keyPathArray: Array(keyPathArray.dropFirst()))
            } else {

                return nil
            }
        }

        return nil
    }

    /// fetch json object from the origin json object in the interation way.
    ///
    /// - Parameters:
    ///   - object: the origin json object
    ///   - keyPaths: key-paths in array form
    /// - Returns: json object data which looking for by using key-path
    static fileprivate func _fetchObjectIn(_ object: [String: AnyObject], keyPathArray keyPaths: [String]) -> AnyObject? {
        if let key = keyPaths.first {
            if keyPaths.count == 1 {

                return object[key]
            }

            if let value = object[key] as? [String: AnyObject] {

                return _fetchObjectIn(value, keyPathArray: Array(keyPaths.dropFirst()))
            } else {

                return nil
            }
        }

        return nil
    }
}
