//
//  ffRouterTranslatorProcotol.swift
//  FFRouter
//
//  Created by Zhu Delun on 2018/6/5.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

import Foundation

@objc
public protocol RouterTranslatorBehaviorProtocol: class {

    func tryTranslateUrl(_ url: String) -> String
}
