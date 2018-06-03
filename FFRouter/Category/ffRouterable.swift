//
//  ffRouterHelper.swift
//  FFRouter
//
//  Created by ZhuDelun on 2018/5/24.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

import Foundation
import UIKit

@objc
public protocol ffRouterable {
    func setUpWith(_ param: [String: String]!, userInfo:AnyObject?) -> Bool;
}

extension UIViewController: ffRouterable {
    static func viewController(_ router: String!, userInfo:AnyObject?) -> UIViewController? {
        let cls_parma: [Any]? = ffRouter.shared.classMatchRouter(router)
        if cls_parma == nil {
            return nil
        }
        let cls_vc: UIViewController.Type = cls_parma![0] as! UIViewController.Type
        let vc_param: [String: String]? = cls_parma![1] as? [String: String]
        let vc = cls_vc.init()
        if vc.responds(to: #selector(ffRouterable.setUpWith(_:userInfo:))) {
            if false == vc.setUpWith(vc_param, userInfo: userInfo) {
                return nil
            }
        }
        return vc
    }

    @objc public  func setUpWith(_ param: [String : String]!,userInfo:AnyObject?) -> Bool {
        return true
    }
}
