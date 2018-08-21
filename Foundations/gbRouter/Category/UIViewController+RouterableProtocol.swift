//
//  ffRouterHelper.swift
//  FFRouter
//
//  Created by ZhuDelun on 2018/5/24.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController: RouterableProtocol {

    static func viewController(_ router: String,
                               withParameter args: [String: String] = [:],
                               userInfo: AnyObject? = nil) -> UIViewController? {

        if let clsParam: Router.MatchResultType = Router.shared.classMatchRouter(router),
            clsParam.0 is UIViewController.Type,
            let clsVC = clsParam.0 as? UIViewController.Type {

            var vcParam: [String: String] = clsParam.1

            if !args.isEmpty {
                vcParam.merge(args) { (_, new) -> String in new }
            }

            let result = clsVC.init()

            if clsVC.conforms(to: RouterableProtocol.self) ||
                result.responds(to: #selector(RouterableProtocol.setUpWith(_:userInfo:))) {

                if false == result.setUpWith(vcParam, userInfo: userInfo) {

                    return nil
                }
            }

            return result
        } else {

            return nil
        }
    }

    @objc
    public func setUpWith(_ param: [String: String], userInfo: AnyObject?) -> Bool {

        return true
    }
}
