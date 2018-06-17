//
//  RouterNode.swift
//  FFRouter
//
//  Created by ZhuDelun on 2018/5/26.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

import UIKit

class RouterNode {

    public typealias RouterNodeResultType = (RouterNode, [String: String])

    var keyPath: String
    // 仅仅用于通过 router 找到对应 class 时，匹配并搜集参数列表时使用的属性。
    var value: String
    var ruby: Any?
    weak var parentNode: RouterNode?
    var childNotes: [RouterNode] = [RouterNode]()

    init() {

        self.keyPath = Constants.KeyPathInvalid
        self.value = Constants.KeyPathEmpty
    }

    deinit {

        self.clearNode()
    }

    func clearNode() {

        _ = self.childNotes.map { $0.clearNode() }

        if !self.childNotes.isEmpty {

            self.childNotes.removeAll()
        }
    }

    func mappingKeyValuesTree(_ object: Any, with keyPath: [String]) {

        guard let key: String = keyPath.first else {

            return
        }

        if let node = self.childNode(with: key) {

            if keyPath.count == 1 {

                node.ruby = object /// !!! overwrite could be happend here !!!
            } else {

                node.mappingKeyValuesTree(object, with: Array(keyPath.dropFirst(1)))
            }

        } else {

            let newNode = RouterNode()
            newNode.keyPath = key
            newNode.parentNode = self
            self.childNotes.append(newNode)

            if keyPath.count == 1 {

                newNode.ruby = object
            } else {

                newNode.mappingKeyValuesTree(object, with: Array(keyPath.dropFirst(1)))
            }
        }
    }

    /// 从且仅仅从当前节点的子节点中，找到对应keypath的子节点。
    ///
    /// - Parameter keyPath: 查找的键
    /// - Returns: 对应键的值（子节点）
    func childNode(with keyPath: String) -> RouterNode? {

        let array = self.childNotes.filter { $0.keyPath == keyPath }
        if let result = array.first {

            return result
        } else {

            return nil
        }
    }

    func recursiveFindChildNode(_ url: String) -> RouterNodeResultType? {

        let allKeyPaths: [String] = url.components(separatedBy: "/")

        if let key: String = allKeyPaths.first, let subNode = self.childNode(with: key) {

            if allKeyPaths.count == 1 {

                return (subNode, [:])
            } else {

                let tailKeyPaths: [String] = Array(allKeyPaths.dropFirst(1))

                return subNode.childNodeDeeplyWith(tailKeyPaths)
            }
        } else {

            return nil
        }
    }

    /// 从当前节点的子节点中找到对应的子节点
    ///
    /// - Parameter keyPath: 被查找的键
    /// - Returns: 对应键的值（节点）
    func childNodeDeeplyWith(_ keyPath: [String]) -> RouterNodeResultType? {

        guard let key = keyPath.first else {

            return nil
        }

        var tailKeyPath: [String] = []
        var curMatchResult: [String: String] = [:]

        // 如果是数字，表明本节点的子节点必须要 参数匹配 节点
        if isNumber(key) {

            for eachChildNode in childNotes {

                if !(eachChildNode.keyPath.hasPrefix(":")) {

                    continue
                }

                curMatchResult = [eachChildNode.keyPath: key]

                // 如果是 参数适配 节点，则需要继续深探是否匹配后续的字段，才能够确定是否完全匹配。
                if (eachChildNode.childNotes.isEmpty) || (keyPath.count == 1) {

                    return (eachChildNode, curMatchResult)  // 当前节点为叶子节点，直接返回ruby
                } else {

                    // 当前节点的 参数适配 孩子节点中的孩子节点中找到后继适配，找到则HIT，否则无法适配
                    if keyPath.count == 1 {

                        continue
                    } else {

                        tailKeyPath = Array(keyPath.dropFirst(1))
                    }

                    if let nodeResult = eachChildNode.childNodeDeeplyWith(tailKeyPath) {

                        curMatchResult.merge(nodeResult.1) { (_, new) in new }

                        return (nodeResult.0, curMatchResult)
                    }
                }
            }

            return nil

        } else {

            let node = self.childNode(with: key)
            if (node == nil || node?.ruby == nil),
                let `parentNode` = self.parentNode,
                parentNode.keyPath.hasPrefix(":") {

                return nil
            }

            if let `node` = node, keyPath.count == 1 {

                return (node, [:])

            } else {

                tailKeyPath = Array(keyPath.dropFirst(1))
            }

            if let `node` = node, let nodeResult = node.childNodeDeeplyWith(tailKeyPath) {

                curMatchResult.merge(nodeResult.1) { (_, new) in new }

                return (nodeResult.0, curMatchResult)

            } else {

                return nil
            }
        }
    }

    fileprivate func isNumber(_ value: String) -> Bool {

        let scanner: Scanner = Scanner.init(string: value)
        var number: Int64 = 0

        return scanner.scanInt64(&number) && scanner.isAtEnd
    }
}

extension RouterNode {

    struct Constants {

        static public let KeyPathEmpty = ""
        static public let KeyPathInvalid = "."
    }
}
