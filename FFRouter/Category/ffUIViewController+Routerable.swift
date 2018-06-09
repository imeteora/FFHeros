//
//  ffRouterHelper.swift
//  FFRouter
//
//  Created by ZhuDelun on 2018/5/24.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController: ffRouterableProtocol {
    static func viewController(_ router: String!, withParameter args: [String : String] = [:], userInfo: AnyObject? = nil) -> UIViewController?
    {
        if let cls_parma: ffRouter.MatchResultType = ffRouter.shared.classMatchRouter(router) {
            if !(cls_parma.0 is UIViewController.Type) {
                return nil
            }
            
            let cls_vc: UIViewController.Type = cls_parma.0 as! UIViewController.Type
            var vc_param: [String: String] = cls_parma.1

            if args.count != 0 {
                vc_param.merge(args) { (_, new) -> String in new }
            }

            let vc = cls_vc.init()
            if vc.responds(to: #selector(ffRouterableProtocol.setUpWith(_:userInfo:))) {
                if false == vc.setUpWith(vc_param, userInfo: userInfo) {
                    return nil
                }
            }
            return vc
        } else {
            return nil
        }
    }

    @objc public func setUpWith(_ param: [String : String]!,userInfo:AnyObject?) -> Bool {
        return true
    }
}
