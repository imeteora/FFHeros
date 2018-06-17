//
//  gbAPIRequest.swift
//  gbNetwork
//
//  Created by ZhuDelun on 2018/6/17.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

import Foundation

@objcMembers
public class GBAPIRequest: Operation {
    public typealias ErrorPointer = AutoreleasingUnsafeMutablePointer<Error?>

    public var completeHandler: (([String: AnyObject]?) -> Void)?
    public var errorHandler: ((Error?, [String: AnyObject]?) -> Void)?

    private var _preRequestHandler: ((String) -> (Bool))?
    private var _postRequestHandler: ((Data?, URLResponse?, Error?) -> Void)?
    private var _requestConfig: GBAPIConfig?
    private var _request: URLRequest?
    private var _currentThread: Thread = Thread.current
    private var _isFinished: Bool
    private var _isCanceled: Bool
    private var _isRequested: Bool

    public init(_ config: GBAPIConfig) {
        _requestConfig = config
        _isFinished = false
        _isCanceled = false
        _isRequested = false
    }

    deinit {
        _didCanceledRequestOperation()
    }

    public final func requestAsync() {
        assert(_currentThread.isEqual(Thread.current), "current thread is not same as one when request be created.")
        assert(_requestConfig != nil, "Network request config has not been configed.")

        if !_isRequested {
            _isRequested = true
            GBAPIOperationQueue.shared.addOperation(self)
        } else {
            assert(false, "current http request had been already established.")
        }
    }

    public override func main() {
        let preBlock: ((String) -> (Bool)) = { _ in return true }

        let postBlock: ((Data?, URLResponse?, Error?) -> Void) = { [weak self] (data, response, error) in
            guard let `self` = self else {

                return
            }

            guard data != nil, error == nil else {
                if let `errorHandler` = self.errorHandler {
                    DispatchQueue.main.async {
                        errorHandler(error, nil)
                    }
                }

                return
            }

            do {
                guard let jsonDict: [String: AnyObject] = try self._deserialize(data, withResponse: response) else {
                    if let `errorHandler` = self.errorHandler {
                        DispatchQueue.main.async {
                            errorHandler(error, nil)
                        }
                    }

                    return
                }
                debugPrint("---- query success ----\n \(jsonDict) \n------------------")

                guard let result: [String: AnyObject] = try self._mappingModel(from: jsonDict) else {
                    if let `errorHandler` = self.errorHandler {
                        DispatchQueue.main.async {
                            errorHandler(error, nil)
                        }
                    }

                    return
                }

                if let `completeHandler` = self.completeHandler {
                    DispatchQueue.main.async {
                        completeHandler(result)
                    }
                }

            } catch let err {
                if let `errorHandler` = self.errorHandler {
                    DispatchQueue.main.async {
                        errorHandler(err, nil)
                    }
                }

                return
            }
        }

        _makeRequestOperation(withPreHandler: preBlock, andPostHandler: postBlock)
        _establish()
    }

    // MARK: - private helpers
    fileprivate func _makeRequestOperation(withPreHandler preBlock:@escaping ((String) -> (Bool)),
                                           andPostHandler postBlock:@escaping ((Data?, URLResponse?, Error?) -> Void)) {
        self._preRequestHandler = preBlock
        self._postRequestHandler = { [unowned self] (data, response, error) in
            postBlock(data, response, error)
            self._didCanceledRequestOperation()
        }

        var request: URLRequest? = nil
        let queryString: String = self._queryString()

        guard let requestConfig = _requestConfig  else {
            assert(false, "Network url request config is needed.")

            return
        }

        switch requestConfig.method {
        case .GET:
            var requestUrlStr: String = requestConfig.baseURL
            if queryString.isEmpty == false {
                requestUrlStr = requestConfig.baseURL + "?" + queryString
            }

            if let requestURL: URL = URL.init(string: requestUrlStr) {
                request = URLRequest.init(url: requestURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: ((requestConfig.timeout > 0) ? requestConfig.timeout : 60))
                request?.httpMethod = "GET"
                request?.setValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
                request?.setValue("*/*", forHTTPHeaderField: "Accept")
                request?.setValue("en-us", forHTTPHeaderField: "Accept-Language")
                request?.setValue("keep-alive", forHTTPHeaderField: "Connection")
            }

        case .POST:
            let requestUrlStr: String = requestConfig.baseURL
            if let requestURL: URL = URL.init(string: requestUrlStr) {
                request = URLRequest.init(url: requestURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: requestConfig.timeout)
                request?.httpMethod = "POST"
            }

        case .PUT:
            assert(false, "Network \(requestConfig.method) not implemented yet")

        case .DELETE:
            assert(false, "Network \(requestConfig.method) not implemented yet")
        }

        if let `request` = request {
            // external http header if has some
            if let extHttpHeader = requestConfig.extHttpHeader {
                for (key, value) in extHttpHeader {
                    request.setValue(value, forHTTPHeaderField: key)
                }
            }

            if let authSignDic in requestConfig.authSignDictOfRequest {
                for (key, value) in authSignDic {
                    request.setValue(value, forHTTPHeaderField: key)
                }
            }

            if let httpBodyData: Data = _queryBody(from: queryString) {
                request.httpBody = httpBodyData
            }

            debugPrint("-----\n request URL: \(String(describing: request?.url?.absoluteString)) \n ------")
            _request = request
        }
    }

    fileprivate func _establish() {
        guard let request = _request, preRequestHandler = _preRequestHandler, postRequestHandler = _postRequestHandler else {
            assert(false, "HTTP request has no available url request instance.")

            return
        }

        if let requestUrl = request.url?.absoluteString,
            let requestTimeoutInterval = request.timeoutInterval,
            preRequestHandler(requestUrl) == false {

            _didCanceledRequestOperation()

            return
        }

        var retData: Data?
        var retResponse: URLResponse?
        var retError: Error?
        var hadBeenHandled: Bool = false

        let _semephore: DispatchSemaphore = DispatchSemaphore.init(value: 0)

        GBAPIOperationQueue.shared._session.dataTask(with: request) { (data, response, error) in
            if hadBeenHandled == false {
                hadBeenHandled = true
                retData = data
                retResponse = response
                retError = error
            }
            _semephore.signal()
        }.resume()

        let semaphoreResult = _semephore.wait(timeout: DispatchTime.init(uptimeNanoseconds: 60 * NSEC_PER_SEC))
        if semaphoreResult == .timedOut || hadBeenHandled == false {
            hadBeenHandled = true
            retError = NSError.init(domain: GBAPIError.Domain.Network.rawValue,
                                    code: NSURLErrorTimedOut,
                                    userInfo: [NSLocalizedFailureErrorKey: "\(Date.init()), \(requestUrl), \(String(describing: requestTimeoutInterval))"])
        }

        if let postRequestHandler = _postRequestHandler {
            postRequestHandler(retData, retResponse, retError)
        }
    }

    fileprivate func _queryString() -> String {
        guard let `_requestConfig` = _requestConfig else {

            return ""
        }

        var retParam: [String: String] = _requestConfig.params ?? [:]
        if _requestConfig.signType == .Server {
            retParam[_requestConfig.signKey] = GBAPISignHelper.signQuery(fromParameter: _requestConfig.authSignStringOfRequest())
        } else if _requestConfig.signType == .Client {
            retParam[_requestConfig.signKey] = _requestConfig.authSignStringOfRequest()
        }

        var all_param: [String] = []
        for each_param in retParam {
            let param_pair = "\(each_param.0)=\(each_param.1)"
            all_param.append(param_pair)
        }

        return all_param.joined(separator: "&")
    }

    fileprivate func _queryBody(from query: String) -> Data? {
        if let `_requestConfig` = _requestConfig, _requestConfig.method == .GET {

            return nil
        } else {

            return query.data(using: .utf8)
        }
    }

    fileprivate func _deserialize(_ data: Data?, withResponse response: URLResponse?) throws -> [String: AnyObject]? {
        guard let `data` = data else {

            return nil
        }

        if let x = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) {

            return x
        } else {
            throw NSError(domain: GBAPIError.Domain.Parser.rawValue,
                          code: GBAPIError.ErrorCode.Serialization.rawValue,
                          userInfo: nil)
        }

        if let `x` = x as Dictionary<String, AnyObject>) {

            return x
        } else {
            throw NSError(domain: GBAPIError.Domain.Feature.rawValue,
                          code: GBAPIError.ErrorCode.InvalidResult.rawValue,
                          userInfo: nil)
        }
        return x
    }

    fileprivate func _mappingModel(from jsonObj: [String: AnyObject]) throws -> [String: AnyObject]? {

        return nil
    }

    fileprivate func _didCanceledRequestOperation() {
        objc_sync_enter(self)

        _requestConfig = nil
        _isCanceled = true
        _isFinished = true
        _isRequested = true

        objc_sync_exit(self)
    }
}
