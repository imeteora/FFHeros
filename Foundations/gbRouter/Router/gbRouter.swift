//
//  ffRouter.swift
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/21.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

import UIKit

@objcMembers
public class gbRouter: NSObject
{
    public typealias MatchCallbackType = (_ param: [String: String]) -> ()
    public typealias MatchResultType = (Any, [String: String])
    public typealias MatchResultArrayType = [Any]

    private var _root: gbRouterNode = gbRouterNode()

    public static var shared: gbRouter = {
        let _instance: gbRouter = gbRouter()
        return _instance;
    }()

    deinit {
        _clearAllRouterMapping()
    }

    /// 用短链接注册目标对象，短连接格式 "/abc/def/:param1/ghi/:param2 ..."
    ///
    /// - code [[ffRouter shared] map:@"/hero/:cid/comics" toClass:[ffHeroDetailViewController class]];
    /// - Parameters:
    ///   - router: 短连接 例如：/abc/def/:param1/ghi/:param2 ...
    ///   - cls: 需要被注册是类型
    public func map(_ router: String!, toClass cls: AnyClass!) {
        gbRouter._rebuildRouterMapping(_root, fromRouter: router, toClass: cls)
    }

    public func map(_ router: String!, toCallback cb: MatchCallbackType!) {
        gbRouter._rebuildRouterMapping(_root, fromRouter: router, toCallback: cb)
    }

    /// 证据给定的短连接，查找对应的对象类型
    ///
    /// - Parameter router: 短连接
    /// - Returns: 被注册好的类型，如果未被注册，则返回空类型
    public func classMatchRouter(_ router: String!) -> MatchResultArrayType?
    {
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
    public func classMatchRouter(_ router: String!) -> MatchResultType?
    {
        if let result = _root.recursiveFindChildNode(router) {
            if result.0.ruby != nil  {
                let target_cls = result.0.ruby!
                let target_param = result.1
                return (target_cls, target_param)
            }
        }
        return nil
    }

    fileprivate func _clearAllRouterMapping() {
        _root.clearNode()
    }

    fileprivate static func _rebuildRouterMapping(_ root: gbRouterNode!, fromRouter router: String!, toClass cls: AnyClass!) {
        _rebuildRouterMapping(root, fromRouter: router, toAnything: cls)
    }

    fileprivate static func _rebuildRouterMapping(_ root: gbRouterNode!, fromRouter router: String!, toCallback cb: MatchCallbackType!) {
        _rebuildRouterMapping(root, fromRouter: router, toAnything: cb)
    }

    fileprivate static func _rebuildRouterMapping(_ root: gbRouterNode!, fromRouter router: String!, toAnything anything: Any!) {
        let keypathArray: [String]? = router.components(separatedBy: "/")
        root.mappingKeyValuesTree(anything, withKeyPath: keypathArray)
    }
}

extension gbRouter {
    public func setNavigationController(_ naviCtrl: UINavigationController) {
        gbRouterTranslator.shared.navigationController = naviCtrl
    }

    public func setAcceptHosts(_ hosts: [String]!) {
        gbRouterTranslator.shared.acceptHosts = hosts
    }

    /// 针对不同的域下的uri注册对应的长连接转义器，实现从正常的RESTful链接转义成内部定义的短连接（短连接只包括PATH，Query)
    ///
    /// - Parameters:
    ///   - domain: 域
    ///   - translator: 链接转义器，必须符合ffRouterTranslatorBehaviorProtocol
    /// - Returns: 返回true表示注册成功，否则失败
    public func registerTranslator(_ domain: String!, translator:gbRouterTranslatorBehaviorProtocol!) -> Bool {
        return gbRouterTranslator.shared.registerTransfer(domain, transfer: translator)
    }


    /// 请求处理链接，并对应做出相应的行为（界面跳转等）
    ///
    /// - Parameters:
    ///   - url: 请求链接，可以是标准的RESTful长连接
    ///   - animated: 是否需要使用推入动画
    /// - Returns: 返回true表示处理成功
    public func processUrl(_ url:String!, animated: Bool) -> Bool {
        return gbRouterTranslator.shared.processUrl(url, animated: animated)
    }
}