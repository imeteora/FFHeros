//
//  FFModule_StringUtils.swift
//  FFRouterTests
//
//  Created by Zhu Delun on 2018/6/6.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

import XCTest
@testable import gbRouter
@testable import gbUtils

class FFModule_StringUtils: XCTestCase {
    private let urlstr: String = "http://marvel.com/comics/characters/1017100/a-bomb_has?utm_campaign=apiRef&utm_source=aaee6fa40625a68298d42a9bb9dcd09d"

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFetchParamInQuery() {
        let param: [String: String] = gbURLUtils.parametersInQuery(urlstr)
        XCTAssert(param == ["utm_source": "aaee6fa40625a68298d42a9bb9dcd09d", "utm_campaign": "apiRef"])
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
