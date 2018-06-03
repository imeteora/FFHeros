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

    @objc public static var shared: ffRouter = {
        let _instance: ffRouter = ffRouter()
        return _instance;
    }()

    deinit {
        self.clearAllRouterMapping()
    }

    func clearAllRouterMapping() {
        _root.clearNode()
    }

    /// 用短链接注册目标对象，短连接格式 "/abc/def/:param1/ghi/:param2 ..."
    ///
    /// - code [[ffRouter shared] map:@"/hero/:cid/comics" toClass:[ffHeroDetailViewController class]];
    /// - Parameters:
    ///   - router: 短连接 例如：/abc/def/:param1/ghi/:param2 ...
    ///   - cls: 需要被注册是类型
    @objc public func map(_ router: String!, toClass cls: AnyClass!) {
        ffRouter.rebuildRouterMapping(_root, fromRouter: router, toClass: cls)
    }

    /// 证据给定的短连接，查找对应的对象类型
    ///
    /// - Parameter router: 短连接
    /// - Returns: 被注册好的类型，如果未被注册，则返回空类型
    @objc public func classMatchRouter(_ router: String!) -> [Any]?
    {
        let result: (AnyClass?, [String: String]?)? = self.classMatchRouter(router)
        if result != nil {
            return [(result!.0)!, result?.1 as AnyObject]
        } else {
            return nil
        }
    }

    /// 证据给定的短连接，查找对应的对象类型
    ///
    /// - Parameter router: 短连接
    /// - Returns: 被注册好的类型，如果未被注册，则返回空类型
    public func classMatchRouter(_ router: String!) -> (AnyClass?, [String: String]?)? {
        let result: (ffRouterNode?, [String: String]?)? = _root.recursiveFindChildNode(router)
        if result != nil {
            return (result!.0?.ruby!, result?.1)
        } else {
            return nil
        }
    }

    fileprivate static func rebuildRouterMapping(_ root: ffRouterNode!, fromRouter router: String!, toClass cls: AnyClass!) {
        let keypathArray: [String]? = router.components(separatedBy: "/")
        root.mappingKeyValuesTree(cls, withKeyPath: keypathArray)
    }
}
