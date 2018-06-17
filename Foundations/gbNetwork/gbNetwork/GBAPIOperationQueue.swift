//
//  gbAPIOperationQueue.swift
//  gbNetwork
//
//  Created by ZhuDelun on 2018/6/18.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

import UIKit

class GBAPIOperationQueue: OperationQueue, URLSessionDelegate {
    lazy var _session: URLSession = {

        return URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
    }()

    public static var shared: GBAPIOperationQueue = {
        let _instance = GBAPIOperationQueue()
        _instance.maxConcurrentOperationCount = 6

        return _instance
    }()

    deinit {
        _session.invalidateAndCancel()
    }

    // MARK: - URLSessionDelegate
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod.elementsEqual(NSURLAuthenticationMethodServerTrust) {
            if challenge.protectionSpace.host.contains("marvel.com") {
                let credential = URLCredential.init(trust: challenge.protectionSpace.serverTrust)
                completionHandler(.useCredential, credential)

                return
            }
        }
        completionHandler(.performDefaultHandling, challenge.proposedCredential)
    }
}
