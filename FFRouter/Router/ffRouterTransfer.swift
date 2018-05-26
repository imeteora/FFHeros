//
//  ffRouterTransfer.swift
//  FFRouter
//
//  Created by ZhuDelun on 2018/5/26.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

import UIKit

protocol ffRouterTransferProtocol {
    func tryTransferUrl(_ url:String!) -> String!;
}

@objc
class ffRouterTransfer: NSObject
{
    public var navigationController: UINavigationController? = nil

    var acceptHosts: [String] = []
    var acceptScheme: [String] = []
    private var allRouterTransfer: [String: ffRouterTransferProtocol] = [:]

    public static let shared: ffRouterTransfer = {
        let _instance: ffRouterTransfer = ffRouterTransfer()
        return _instance
    }()


    required override init() {
        acceptScheme = ["http", "https"]
    }

    deinit {
        self.allRouterTransfer.removeAll()
        self.acceptHosts.removeAll()
    }

    public func registerTransfer(_ domain: String!, transfer: ffRouterTransferProtocol) {
        self.registerTransfer(domain, transfer: transfer, forceReplace: true)
    }

    public func registerTransfer(_ domain: String!, transfer: ffRouterTransferProtocol, forceReplace: Bool = false) {
        let alreadyHasOne: Bool  = allRouterTransfer.contains { (key:String, _) -> Bool in
            return (key == domain)
        }
        
        if alreadyHasOne == true && forceReplace == false {
            return
        }
        allRouterTransfer[domain] = transfer;
    }

    public func processUrl(_ url: String!, animted:Bool) -> Bool
    {
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

        if (matchOneHost == false) {
            return false
        }

        var _urlTransfered: String = url   // set as origin url firstly.
        for (eachDomain, eachTransfer) in self.allRouterTransfer {
            if self._matchDomain(eachDomain, url: url)
            {
                let tmpTransferedUrl:String = eachTransfer.tryTransferUrl(url)
                if tmpTransferedUrl.elementsEqual(url) == false {
                    _urlTransfered = tmpTransferedUrl
                    break;
                }
            }
        }

        if true == _internalPushUrl(_urlTransfered, animated: animted) {
            return true;
        }


        if _urlTransfered.count > 0 && _isWebUrl(_urlTransfered) {
            let webWrapUrl = "/browser/?url=" + ff_router_encodeUrl(_urlTransfered);
            return _internalPushUrl(webWrapUrl, animated: animted);
        }

        return false
    }

    private func _internalPushUrl(_ url:String!, animated: Bool) -> Bool {
        assert(navigationController != nil, self.classForCoder.description() + ": NavigationController is null")

        let cls: (AnyClass?, [String: String]?)? = ffRouter.shared.classMatchRouter(url)
        if cls == nil {
            return false;
        }

        if cls!.0 == UIViewController.self {
            let vc: UIViewController? = UIViewController.viewController(url, userInfo: nil)
            if vc != nil {
                self.navigationController?.pushViewController(vc!, animated: animated)
            }
        }
        return true
    }

    private  func _isWebUrl(_ url:String!) -> Bool {
        let kRegStr = "^((?:(http|https|Http|Https|rtsp|Rtsp):\\/\\/(?:(?:[a-zA-Z0-9\\$\\-\\_\\.\\+\\!\\*\\'\\(\\)\\,\\;\\?\\&\\=]|(?:\\%[a-fA-F0-9]{2})){1,64}(?:\\:(?:[a-zA-Z0-9\\$\\-\\_\\.\\+\\!\\*\\'\\(\\)\\,\\;\\?\\&\\=]|(?:\\%[a-fA-F0-9]{2})){1,25})?\\@)?)?(?:(([a-zA-Z0-9\\u00A0-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFEF]([a-zA-Z0-9\\u00A0-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFEF\\-]{0,61}[a-zA-Z0-9\\u00A0-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFEF]){0,1}\\.)+[a-zA-Z0-9\\u00A0-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFEF]{2,63}|((25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9])\\.(25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[0-9]))))(?:\\:\\d{1,5})?)(\\/(?:(?:[a-zA-Z0-9\\u00A0-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFEF\\;\\/\\?\\:\\@\\&\\=\\#\\~\\-\\.\\+\\!\\*\\'\\(\\)\\,\\_])|(?:\\%[a-fA-F0-9]{2}))*)?(?:\\b|$)";
        let regUrlTextWebUrl = NSPredicate.init(format: "SELF MATCHES %@", kRegStr)
        if regUrlTextWebUrl.evaluate(with: url) {
            return true
        } else {
            return false
        }
    }

    private func _matchDomain(_ domain:String!, url: String!) -> Bool {
        let url: URL? = URL.init(string:url)
        if url == nil || url!.host!.count <= 0 {
            return false
        }

        if url!.host! == domain {
            return true
        }

        let hostStr: String = url!.host!
        if hostStr.hasPrefix(domain) {
            return true
        }

        let pathStr: String = url!.path
        if pathStr.hasPrefix("/" + domain) {
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
    private func _matchUrl(_ base: String!, url: String!) -> Bool {
        let baseArray: [String] = base.components(separatedBy: ".")
        let urlArray: [String] = url.components(separatedBy: ".")
        if baseArray.count != urlArray.count {
            return false
        }

        var result = true
        for (idx, each_base) in baseArray.enumerated() {
            if each_base == "*" {
                continue
            }
            if each_base.elementsEqual(urlArray[idx]) == false {
                result = false
                break;
            }
        }
        return result
    }
}

func ff_router_encodeUrl(_ url: String) -> String {
    if url.count <= 0 {
        return url
    }
    let encodedUrl: String = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    return encodedUrl
}

func ff_router_decodeUrl(_ url: String) -> String {
    if url.count <= 0  {
        return url
    }
    let decodedUrl: String = url.removingPercentEncoding ?? ""
    return decodedUrl
}