//
//  ffRouterNode.swift
//  FFRouter
//
//  Created by ZhuDelun on 2018/5/26.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

import UIKit

class ffRouterNode
{
    enum NodeKeyPath: String {
        case Empty = ""
        case Invalid = "."
    }

    var keyPath: String = NodeKeyPath.Invalid.rawValue
    var value: String = ""      // 仅仅用于通过 router 找到对应 class 时，匹配并搜集参数列表时使用的属性。
    var ruby: AnyClass? = nil
    var parentNode: ffRouterNode? = nil
    var childNotes: [ffRouterNode] = []

    init() {
        keyPath = NodeKeyPath.Invalid.rawValue
        ruby = nil
        parentNode = nil
        childNotes = []
    }

    deinit {
        self.clearNode()
    }

    func clearNode() {
        for (_, each_sub_node) in self.childNotes.enumerated() {
            each_sub_node.clearNode()
        }

        if (childNotes.count > 0) {
            childNotes.removeAll()
        }
        keyPath = NodeKeyPath.Invalid.rawValue
        ruby = nil
        parentNode = nil
    }


    func mappingKeyValuesTree(_ object: AnyClass!, withKeyPath keyPath: [String]!) {
        let key: String = keyPath[0]
        var node: ffRouterNode? = self.childNode(with: key)
        if node == nil {
            node = ffRouterNode()
            node?.keyPath = key
            node?.parentNode = self
            self.childNotes.append(node!);

            if keyPath.count == 1 {
                node?.ruby = object
            } else {
                let tailKeyPath: [String] = Array(keyPath.dropFirst(1))
                node?.mappingKeyValuesTree(object, withKeyPath: tailKeyPath)
            }
        } else {
            if keyPath.count == 1 {
                node?.ruby = object /// !!! overwrite could be happend here !!!
            } else {
                let tailKeyPath: [String] = Array(keyPath.dropFirst(1))
                node?.mappingKeyValuesTree(object, withKeyPath: tailKeyPath)
            }
        }
    }


    /// 从且仅仅从当前节点的子节点中，找到对应keypath的子节点。
    ///
    /// - Parameter keyPath: 查找的键
    /// - Returns: 对应键的值（子节点）
    func childNode(with keyPath: String!) -> ffRouterNode? {
        var result: ffRouterNode? = nil
        for (_, each_node) in childNotes.enumerated() {
            if each_node.keyPath == keyPath {
                result = each_node
                break
            }
        }
        return result
    }

    func recursiveFindChildNode(_ keyPath: String!) -> (ffRouterNode?, [String: String]?)? {
        let allKeyPaths: [String]! = keyPath.components(separatedBy: "/")
        let key: String = allKeyPaths[0]

        let subNode: ffRouterNode? = self.childNode(with: key)
        if allKeyPaths.count == 1 {
            return (subNode, [:])
        } else {
            let tailKeyPaths: [String] = Array(allKeyPaths.dropFirst(1))
            return subNode?.childNodeDeeplyWith(tailKeyPaths)
        }
    }

    /// 从当前节点的子节点中找到对应的子节点
    ///
    /// - Parameter keyPath: 被查找的键
    /// - Returns: 对应键的值（节点）
    func childNodeDeeplyWith(_ keyPath: [String]!) -> (ffRouterNode?, [String: String]?)? {
        var keyPathArray: [String]! = keyPath
        let key: String = keyPathArray![0];

        var node: ffRouterNode? = nil
        var tailKeyPath: [String] = []

        var curMatchResult: [String: String] = [:]
        // 如果是数字，表明本节点的子节点必须要 参数匹配 节点
        if isNumber(key) {
            for (_, each_node) in childNotes.enumerated() {
                if !(each_node.keyPath.hasPrefix(":")) {
                    continue
                }

                curMatchResult = [each_node.keyPath: key]

                // 如果是 参数适配 节点，则需要继续深探是否匹配后续的字段，才能够确定是否完全匹配。
                if (each_node.childNotes.count == 0) || (keyPathArray.count == 1) {
                    // 当前节点为叶子节点，直接返回ruby
                    return (each_node, curMatchResult)
                } else {
                    // 当前节点的 参数适配 孩子节点中的孩子节点中找到后继适配，找到则HIT，否则无法适配
                    node = each_node
                    if keyPathArray.count == 1 {
                        continue;
                    } else {
                        tailKeyPath = Array(keyPathArray.dropFirst(1))
                    }

                    let node_result = node?.childNodeDeeplyWith(tailKeyPath)
                    if node_result!.0!.ruby != nil && node_result!.1!.count > 0 {
                        curMatchResult.merge((node_result?.1)!) { (_, new) in new }
                        return (node_result?.0, curMatchResult)
                    }
                }
            }
        }
        else {
            node = self.childNode(with: key)
            if (node == nil || node?.ruby == nil) && true == self.parentNode?.keyPath.hasPrefix(":") {
                return (nil, [:])
            }
            if keyPathArray.count == 1 {
                return (node, [:]);
            } else {
                tailKeyPath = Array(keyPathArray.dropFirst(1))
            }
        }

        let node_result = node?.childNodeDeeplyWith(tailKeyPath)
        if node_result!.0!.ruby != nil && node_result!.1!.count > 0 {
            curMatchResult.merge((node_result?.1)!) { (_, new) in new }
        }
        return (node_result!.0, curMatchResult)
    }

    fileprivate func isNumber(_ value: String!) -> Bool {
        let scanner: Scanner = Scanner.init(string: value)
        var d: Int64 = 0
        return scanner.scanInt64(&d) && scanner.isAtEnd
    }

}
