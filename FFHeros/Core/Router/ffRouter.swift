//
//  ffRouter.swift
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/21.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

import UIKit


@objc
class ffRouter: NSObject {
    private var root: ffRouterNode = ffRouterNode()

    public lazy var shared: ffRouter = {
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

    }

    /// 证据给定的短连接，查找对应的对象类型
    ///
    /// - Parameter router: 短连接
    /// - Returns: 被注册好的类型，如果未被注册，则返回空类型
    public func classMatchRouter(_ router: String!) -> AnyClass? {
        return nil
    }
}

class ffRouterNode
{
    enum NodeKeyPath: String {
        case Empty = ""
        case Invalid = "."
    }

    var keyPath: String = NodeKeyPath.Invalid.rawValue
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
            node?.childNotes.append(node!);

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

//    func recursiveFindChildNode(_ keyPath: String!) -> (result: ffRouterNode?, param:[String: String]?)? {
//        let allKeyPaths: [String]! = keyPath.components(separatedBy: "/")
//        let key: String = allKeyPaths[0]
//
//        let subNode: ffRouterNode? = self.childNode(with: key)
//        if allKeyPaths.count == 1 {
//            return subNode
//        } else {
//            let tailKeyPaths: [String] = Array(allKeyPaths.dropFirst(1))
//            return subNode?.childNodeDeeplyWith(tailKeyPaths)
//        }
//    }

    /// 从当前节点的子节点中找到对应的子节点
    ///
    /// - Parameter keyPath: 被查找的键
    /// - Returns: 对应键的值（节点）
    func childNodeDeeplyWith(_ keyPath: [String]!) -> ffRouterNode? {
        let key: String = keyPath[0];
        let node: ffRouterNode? = self.childNode(with: key)
        if keyPath.count == 1 {
            return node;
        }

        let tailKeyPath: [String] = Array(keyPath.dropFirst(1))
        return node?.childNodeDeeplyWith(tailKeyPath)
    }


}
