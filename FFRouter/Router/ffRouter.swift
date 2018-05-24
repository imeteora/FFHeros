//
//  ffRouter.swift
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/21.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

import UIKit


@objc
public class ffRouter: NSObject {
    private var _root: ffRouterNode = ffRouterNode()

    public static var shared: ffRouter = {
        let _instance: ffRouter = ffRouter()
        return _instance;
    }()

    /// 用短链接注册目标对象，短连接格式 "/abc/def/:param1/ghi/:param2 ..."
    ///
    /// - code [[ffRouter shared] map:@"/hero/:cid/comics" toClass:[ffHeroDetailViewController class]];
    /// - Parameters:
    ///   - router: 短连接 例如：/abc/def/:param1/ghi/:param2 ...
    ///   - cls: 需要被注册是类型
    public func map(_ router: String!, toClass cls: AnyClass!) {
        ffRouter.rebuildRouterMapping(_root, fromRouter: router, toClass: cls)
    }

    /// 证据给定的短连接，查找对应的对象类型
    ///
    /// - Parameter router: 短连接
    /// - Returns: 被注册好的类型，如果未被注册，则返回空类型
    public func classMatchRouter(_ router: String!) -> (AnyClass?, [String: String]?)? {
        let result: (ffRouterNode?, [String: String]?)? = _root.recursiveFindChildNode(router)
        if (result?.0 != nil) {
            return (result?.0?.ruby, result?.1)
        } else {
            return nil
        }
    }

    private static func rebuildRouterMapping(_ root: ffRouterNode!, fromRouter router: String!, toClass cls: AnyClass!) {
        let keypathArray: [String]? = router.components(separatedBy: "/")
        root.mappingKeyValuesTree(cls, withKeyPath: keypathArray)
    }
}

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
        keyPath = NodeKeyPath.Invalid.rawValue
        ruby = nil
        parentNode = nil
        if (childNotes.count > 0) {
            childNotes.removeAll()
        }
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

        // 如果是数字，表明本节点的子节点必须要 参数匹配 节点
        if isNumber(key) {
            for (_, each_node) in childNotes.enumerated() {
                if !(each_node.keyPath.hasPrefix(":")) {
                    continue
                }

                var curMatchResult: [String: String] = [each_node.keyPath: key]
                // 如果是 参数适配 节点，则需要继续深探是否匹配后续的字段，才能够确定是否完全匹配。
                if (each_node.childNotes.count == 0) || (keyPathArray.count == 1) {
                    // 当前节点为叶子节点，直接返回ruby
                    return (each_node, [each_node.keyPath: key])
                } else {
                    // 当前节点的 参数适配 孩子节点中的孩子节点中找到后继适配，找到则HIT，否则无法适配
                    let next_key = keyPathArray[1]
                    node = each_node.childNode(with: next_key)
                    if (node != nil) && (keyPathArray.count == 2) {
                        return (node, [each_node.keyPath: key])
                    } else {
                        tailKeyPath = Array(keyPathArray.dropFirst(2))
                        let node_result_ = node?.childNodeDeeplyWith(tailKeyPath)
                        curMatchResult.merge((node_result_?.1)!) { (_, new) in new }
                        return (node_result_?.0, curMatchResult)
                    }
                }
            }
        }
        else {
            node = self.childNode(with: key)
            if keyPathArray.count == 1 {
                return (node, [:]);
            } else {
                tailKeyPath = Array(keyPathArray.dropFirst(1))
            }
        }
        return node?.childNodeDeeplyWith(tailKeyPath)
    }

    fileprivate func isNumber(_ value: String!) -> Bool {
        let scanner: Scanner = Scanner.init(string: value)
        var d: Int64 = 0
        return scanner.scanInt64(&d) && scanner.isAtEnd
    }

}
