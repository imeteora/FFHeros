//
//  ffRouterTransfer.swift
//  FFRouterTests
//
//  Created by ZhuDelun on 2018/5/26.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

import XCTest
@testable import FFRouter

class FFRouter_Transfer: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testRouterTransferUrl() {
        let transfer: ffRouterTranslator = ffRouterTranslator.shared
        transfer.acceptHosts = ["*.marvel.com"]
        XCTAssert(transfer.processUrl("http://www.marvel.com/hello", animated: true))
    }

    func testURLEncodeAndDecode() {
        let url: String = "http://www.baidu.com/?hello world=123"
        let encoded_url: String = ff_router_encodeUrl(url)
        let decoded_url: String = ff_router_decodeUrl(encoded_url)

        print(url + "\n")
        print(encoded_url + "\n")
        print(decoded_url + "\n")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
