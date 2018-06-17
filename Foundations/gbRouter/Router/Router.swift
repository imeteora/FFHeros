//
//  Router.swift
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/21.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

import UIKit

@objcMembers
public class Router: NSObject {

    public typealias MatchCallbackType = (_ param: [String: String]) -> Void
    public typealias MatchResultType = (Any, [String: String])
    public typealias MatchResultArrayType = [Any]

    private var root: RouterNode = RouterNode()

    public static var shared: Router = {

        return Router()
    }()

    private override init() {

        debugPrint("?????")
    }

    deinit {

        clearAllRouterMappingInternal()
    }

    /// 用短链接注册目标对象，短连接格式 "/abc/def/:param1/ghi/:param2 ..."
    ///
    /// - code [[ffRouter shared] map:@"/hero/:cid/comics" toClass:[ffHeroDetailViewController class]];
    /// - Parameters:
    ///   - router: 短连接 例如：/abc/def/:param1/ghi/:param2 ...
    ///   - cls: 需要被注册是类型
    public func map(_ router: String, toClass cls: AnyClass) {

        Router.rebuildRouterMappingInternal(root, from: router, toClass: cls)
    }

    public func map(_ router: String, toCallback callback: MatchCallbackType) {

        Router.rebuildRouterMappingInternal(root, from: router, toCallback: callback)
    }

    /// 证据给定的短连接，查找对应的对象类型
    ///
    /// - Parameter router: 短连接
    /// - Returns: 被注册好的类型，如果未被注册，则返回空类型
    public func classMatchRouter(_ router: String) -> MatchResultArrayType? {

        if let result: MatchResultType = self.classMatchRouter(router) {

            return [result.0, result.1]
        } else {

            return nil
        }
    }

    /// 证据给定的短连接，查找对应的对象类型
    ///
    /// - Parameter router: 短连接
    /// - Returns: 被注册好的类型，如果未被注册，则返回空类型
    public func classMatchRouter(_ router: String) -> MatchResultType? {

        if let result = root.recursiveFindChildNode(router) {

            if let targetCls = result.0.ruby {

                let targetParam = result.1

                return (targetCls, targetParam)
            }
        }

        return nil
    }

    fileprivate func clearAllRouterMappingInternal() {

        root.clearNode()
    }

    fileprivate static func rebuildRouterMappingInternal(_ root: RouterNode,
                                                         from router: String,
                                                         toClass cls: AnyClass) {

        rebuildRouterMappingInternal(root, fromRouter: router, toAnything: cls)
    }

    fileprivate static func rebuildRouterMappingInternal(_ root: RouterNode,
                                                         from router: String,
                                                         toCallback handler: MatchCallbackType) {

        rebuildRouterMappingInternal(root, fromRouter: router, toAnything: handler)
    }

    fileprivate static func rebuildRouterMappingInternal(_ root: RouterNode,
                                                         fromRouter router: String,
                                                         toAnything anything: Any) {

        let keypathArray: [String] = router.components(separatedBy: "/")
        root.mappingKeyValuesTree(anything, with: keypathArray)
    }
}

extension Router {

    public func setNavigationController(_ naviCtrl: UINavigationController) {

        RouterTranslator.shared.navigationController = naviCtrl
    }

    public func setAcceptHosts(_ hosts: [String]) {

        RouterTranslator.shared.acceptHosts = hosts
    }

    /// 针对不同的域下的uri注册对应的长连接转义器，实现从正常的RESTful链接转义成内部定义的短连接（短连接只包括PATH，Query)
    ///
    /// - Parameters:
    ///   - domain: 域
    ///   - translator: 链接转义器，必须符合ffRouterTranslatorBehaviorProtocol
    /// - Returns: 返回true表示注册成功，否则失败
    @discardableResult
    @objc(registerDomain:withTranslator:)
    public func registerTranslator(_ domain: String, translator: RouterTranslatorBehaviorProtocol) -> Bool {

        return RouterTranslator.shared.registerTransfer(domain, transfer: translator)
    }

    /// 请求处理链接，并对应做出相应的行为（界面跳转等）
    ///
    /// - Parameters:
    ///   - url: 请求链接，可以是标准的RESTful长连接
    ///   - animated: 是否需要使用推入动画
    /// - Returns: 返回true表示处理成功
    @discardableResult
    @objc(processUrl:animated:)
    public func process(_ url: String, animated: Bool) -> Bool {

        return RouterTranslator.shared.processUrl(url, animated: animated)
    }
}
