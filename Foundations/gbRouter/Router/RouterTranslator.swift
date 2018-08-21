//
//  ffRouterTransfer.swift
//  FFRouter
//
//  Created by ZhuDelun on 2018/5/26.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

import UIKit
import gbUtils

@objc
internal class RouterTranslator: NSObject {
    @objc weak public var navigationController: UINavigationController?
    @objc internal var acceptHosts: [String] = []
    @objc internal var acceptScheme: [String] = []

    private var allRouterTransfer: [String: RouterTranslatorBehaviorProtocol] = [:]

    @objc static let shared: RouterTranslator = {

        return RouterTranslator()
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
    @objc
    func registerTransfer(_ domain: String, transfer: AnyObject) -> Bool {

        return registerTransferInternal(domain, transfer: transfer, forceReplace: true)
    }

    /// 以域名domain注册RESTful URL转义成内部router格式的转义器
    ///
    /// - Parameters:
    ///   - domain: 需要关注并过滤的特定domain
    ///   - transfer: 域名转义器
    ///   - forceReplace: 如果已经之前已注册了相关domain下的转义器，是否需要强行覆盖早起已注册的转义器
    /// - Returns: 注册成功，返回true；否则返回false
    @objc
    func registerTransfer(_ domain: String, transfer: AnyObject, forceReplace: Bool) -> Bool {

        return registerTransferInternal(domain, transfer: transfer, forceReplace: forceReplace)
    }

    /// 处理URL，可能是视图跳转，也有可能执行已注册的block
    ///
    /// - Parameters:
    ///   - url: 需要处理的URL
    ///   - animated: 如果是视图跳转是否需要进行动画跳转
    /// - Returns: 如果处理成功，返回true；否则返回false
    @objc
    func processUrl(_ url: String, animated: Bool) -> Bool {

        return processUrlInternal(url, animated: animated)
    }

    fileprivate func registerTransferInternal(_ domain: String, transfer: AnyObject, forceReplace: Bool = false) -> Bool {

        let alreadyHasOne: Bool  = allRouterTransfer.contains { return ($0.0 == domain) }

        if alreadyHasOne == true && forceReplace == false {

            return false
        }

        self.allRouterTransfer[domain] = transfer as? RouterTranslatorBehaviorProtocol

        return true
    }

    fileprivate func processUrlInternal(_ url: String, animated: Bool) -> Bool {

        assert(self.acceptHosts.isEmpty == false, self.classForCoder.description() + ": acceptable host list is empty")

        var args: [String: String] = [:]

        if isWebUrl(url) {

            guard
                let pUrl = URL.init(string: url),
                let pUrlScheme = pUrl.scheme,
                let pUrlHost = pUrl.host,
                self.acceptScheme.contains(pUrlScheme)
            else {

                return false
            }

            var matchOneHost: Bool = false
            for eachAcceptHost in self.acceptHosts {

                matchOneHost = self.matchUrlInternal(eachAcceptHost, url: pUrlHost)
                if matchOneHost {

                    break
                }
            }

            // 没有匹配任何已设定的主机地址，表示不可处理
            if matchOneHost == false {

                return false
            }

            // 截取query形成参数键值对
            args = URLUtils.parametersInQuery(pUrl.absoluteString) ?? [:]

        } else {

            args = URLUtils.parametersInQuery(url) ?? [:]
        }

        var urlTransfered: String = url   // set as origin url firstly.
        for (eachDomain, eachTransfer) in self.allRouterTransfer {

            if self.matchDomainInternal(eachDomain, url: url) {

                let tmpTransferedUrl: String = eachTransfer.tryTranslateUrl(url)
                if tmpTransferedUrl.elementsEqual(url) == false {

                    urlTransfered = tmpTransferedUrl
                    break
                }
            }
        }

        if urlTransfered.isEmpty {

            return false
        }

        if isWebUrl(urlTransfered) {

            args.merge(["url": RouterUtils.encodeUrl(urlTransfered)]) { (_, new) -> String in new }
            urlTransfered = "/browser"
        }

        return processRouterInternal(urlTransfered, with: args, animated: animated)
    }

    fileprivate func processRouterInternal(_ router: String, with argu: [String: String]?, animated: Bool = true) -> Bool {

        assert(self.navigationController != nil, self.classForCoder.description() + ": NavigationController is null")

        if let cls: Router.MatchResultType = Router.shared.classMatchRouter(router) {

            var param: [String: String] = [:]
            param.merge(cls.1) { (_, new) -> String in new }

            if let `argu` = argu, argu.isEmpty == false {

                param.merge(argu) { (_, new) -> String in new }
            }

            if (cls.0 as? UIViewController.Type) != nil {

                guard
                    let result = UIViewController.viewController(router, withParameter: param, userInfo: nil),
                    let `navigationController` = self.navigationController
                else {

                    return false
                }
                navigationController.pushViewController(result, animated: animated)

                return true

            } else if let callback = cls.0 as? Router.MatchCallbackType {

                callback(cls.1)

                return true

            } else {
                // HINT: 准备其他基础类型的判断，并增加对应的实例化过程
                return false
            }
        } else {

            return false
        }
    }

    fileprivate  func isWebUrl(_ url: String) -> Bool {

        return URLUtils.isWebUrl(url)
    }

    fileprivate func matchDomainInternal(_ domain: String, url: String) -> Bool {

        guard
            let `url` = URL.init(string: url),
            let hostStr = url.host, hostStr.isEmpty == false, hostStr == domain
        else {

            return false
        }

        let hostArr = hostStr.components(separatedBy: ".")
        guard hostArr.count == 3, hostArr[0] == domain else {

            return false
        }

        guard url.path.hasPrefix("/" + domain + "/") else {

            return false
        }

        return true
    }

    /// 判断url是否符合所期望域名的格式匹配
    ///
    /// - Parameters:
    ///   - base: 期望的host格式
    ///   - url: 被检查的url链接
    /// - Returns: 返回true表示符合所期望的格式，否则不匹配
    fileprivate func matchUrlInternal(_ base: String, url: String) -> Bool {

        return URLUtils.matchString(base, withSource: url, separatedBy: ".")
    }
}
