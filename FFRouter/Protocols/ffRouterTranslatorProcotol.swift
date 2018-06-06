//
//  ffRouterTranslatorProcotol.swift
//  FFRouter
//
//  Created by Zhu Delun on 2018/6/5.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

import Foundation

@objc public protocol ffRouterTranslatorBehaviorProtocol {
    func tryTranslateUrl(_ url: String!) -> String!
}
