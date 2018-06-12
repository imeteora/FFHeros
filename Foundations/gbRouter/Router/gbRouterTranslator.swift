//
//  ffRouterTransfer.swift
//  FFRouter
//
//  Created by ZhuDelun on 2018/5/26.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

import UIKit
import gbUtils

internal func gb_router_encodeUrl(_ url: String) -> String {
    if url.count <= 0 {
        return url
    }
    let encodedUrl: String = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    return encodedUrl
}

internal func gb_router_decodeUrl(_ url: String) -> String {
    if url.count <= 0  {
        return url
    }
    let decodedUrl: String = url.removingPercentEncoding ?? ""
    return decodedUrl
}

@objc internal class gbRouterTranslator: NSObject
{
    @objc weak public var navigationController: UINavigationController? = nil
    @objc internal var acceptHosts: [String] = []
    @objc internal var acceptScheme: [String] = []

    private var allRouterTransfer: [String: gbRouterTranslatorBehaviorProtocol] = [:]

    @objc internal static let shared: gbRouterTranslator = {
        let _instance: gbRouterTranslator = gbRouterTranslator()
        return _instance
    }()


    required override public init() {
        acceptScheme = ["http", "https"]
    }

    deinit {
        self.allRouterTransfer.removeAll()
        self.acceptHosts.removeAll()
    }


    /// 以域名domain注册RESTful URL转义成内部router格式的转义器
    ///
    /// - Parameters:
    ///   - domain: 需要关注并过滤的特定domain
    ///   - transfer: 域名转义器
    /// - Returns: 注册成功，返回true；否则返回false
    @objc internal func registerTransfer(_ domain: String!, transfer: AnyObject!) -> Bool {
        return _registerTransfer(domain, transfer:transfer, forceReplace:true)
    }

    /// 以域名domain注册RESTful URL转义成内部router格式的转义器
    ///
    /// - Parameters:
    ///   - domain: 需要关注并过滤的特定domain
    ///   - transfer: 域名转义器
    ///   - forceReplace: 如果已经之前已注册了相关domain下的转义器，是否需要强行覆盖早起已注册的转义器
    /// - Returns: 注册成功，返回true；否则返回false
    @objc internal func registerTransfer(_ domain: String!, transfer: AnyObject!, forceReplace: Bool) -> Bool {
        return _registerTransfer(domain, transfer:transfer, forceReplace:forceReplace)
    }

    /// 处理URL，可能是视图跳转，也有可能执行已注册的block
    ///
    /// - Parameters:
    ///   - url: 需要处理的URL
    ///   - animated: 如果是视图跳转是否需要进行动画跳转
    /// - Returns: 如果处理成功，返回true；否则返回false
    @objc internal func processUrl(_ url: String!, animated:Bool) -> Bool {
        return _processUrl(url, animated: animated)
    }


    fileprivate func _registerTransfer(_ domain: String!, transfer: AnyObject!, forceReplace: Bool = false) -> Bool {
        let alreadyHasOne: Bool  = allRouterTransfer.contains { (key:String, _) -> Bool in
            return (key == domain)
        }

        if alreadyHasOne == true && forceReplace == false {
            return false
        }
        allRouterTransfer[domain] = transfer as? gbRouterTranslatorBehaviorProtocol;
        return true
    }

    fileprivate func _processUrl(_ url: String!, animated:Bool) -> Bool
    {
        assert(acceptHosts.count != 0, self.classForCoder.description() + ": acceptable host list is empty")

        var args: [String: String] = [:]

        if _isWebUrl(url) {
            let _url: URL? = URL.init(string: url)
            if _url == nil {
                return false
            }
            if self.acceptScheme.contains((_url?.scheme!)!) == false {
                return false
            }

            var matchOneHost: Bool = false
            for (_, eachAcceptHost) in self.acceptHosts.enumerated() {
                matchOneHost = self._matchUrl(eachAcceptHost, url:_url?.host)
                if matchOneHost {
                    break;
                }
            }

            // 没有匹配任何已设定的主机地址，表示不可处理
            if (matchOneHost == false) {
                return false
            }

            // 截取query形成参数键值对
            args = gbURLUtils.parametersInQuery(_url!.absoluteString) ?? [:]
        } else {
            args = gbURLUtils.parametersInQuery(url) ?? [:]
        }

        var _urlTransfered: String = url   // set as origin url firstly.
        for (eachDomain, eachTransfer) in self.allRouterTransfer {
            if self._matchDomain(eachDomain, url: url)
            {
                let tmpTransferedUrl:String = eachTransfer.tryTranslateUrl(url)
                if tmpTransferedUrl.elementsEqual(url) == false {
                    _urlTransfered = tmpTransferedUrl
                    break;
                }
            }
        }

        if _urlTransfered.count <= 0 {
            return false
        }

        if _isWebUrl(_urlTransfered) {
            args.merge(["url": gb_router_encodeUrl(_urlTransfered)]) { (_, new) -> String in new }
            _urlTransfered = "/browser"
        }

        return _internalProcessRouter(_urlTransfered, withParameter: args, animated: animated)
    }

    fileprivate func _internalProcessRouter(_ router:String!, withParameter argu: [String : String]?, animated: Bool = true) -> Bool
    {
        assert(navigationController != nil, self.classForCoder.description() + ": NavigationController is null")

        if let cls: gbRouter.MatchResultType = gbRouter.shared.classMatchRouter(router) {
            var param: [String: String]! = [:]
            if cls.1.count != 0 {
                param.merge(cls.1) { (_, new) -> String in new }
            }
            if (argu != nil) && (argu!.count > 0) {
                param.merge(argu!) { (_, new) -> String in new }
            }

            if cls.0 is UIViewController.Type {
                if let vc = UIViewController.viewController(router, withParameter: param, userInfo: nil) {
                    self.navigationController?.pushViewController(vc, animated: animated)
                    return true
                }
            } else if cls.0 is gbRouter.MatchCallbackType {
                let __callback: gbRouter.MatchCallbackType = cls.0 as! gbRouter.MatchCallbackType
                __callback(cls.1)
                return true
            } else {
                //TODO: 准备其他基础类型的判断，并增加对应的实例化过程
            }
            return false
        } else {
            return false;
        }
    }

    fileprivate  func _isWebUrl(_ url:String!) -> Bool {
        return gbURLUtils.isWebUrl(url)
    }

    fileprivate func _matchDomain(_ domain:String!, url: String!) -> Bool
    {
        let url: URL? = URL.init(string:url)
        if url == nil || url!.host!.count <= 0 {
            return false
        }

        if url!.host! == domain {
            return true
        }

        let hostStr: String = url!.host!
        let hostArr: [String] = hostStr.components(separatedBy: ".")
        if hostArr.count == 3 && hostArr[0].elementsEqual(domain) {
            return true
        }

        let pathStr: String = url!.path
        if pathStr.hasPrefix("/" + domain + "/") {
            return true
        }
        return false
    }

    /// 判断url是否符合所期望域名的格式匹配
    ///
    /// - Parameters:
    ///   - base: 期望的host格式
    ///   - url: 被检查的url链接
    /// - Returns: 返回true表示符合所期望的格式，否则不匹配
    fileprivate func _matchUrl(_ base: String!, url: String!) -> Bool {
        return gbURLUtils.matchString(base, withSource: url, separatedBy: ".")
    }
}
