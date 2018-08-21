//
//  ffRouterableProtocol.swift
//  FFRouter
//
//  Created by Zhu Delun on 2018/6/5.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

import Foundation

@objc public protocol RouterableProtocol {

    func setUpWith(_ param: [String: String], userInfo: AnyObject?) -> Bool
}
