//
//  FFRouterTests.swift
//  FFRouterTests
//
//  Created by ZhuDelun on 2018/5/23.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

import XCTest
@testable import FFRouter

class ffFoo {
    var hello: String = "world"
}

class FFRouterTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRouterNormal() {
        ffRouter.shared.map("/hello/world", toClass: ffFoo.self)
        XCTAssert(ffRouter.shared.classMatchRouter("/hello/world")?.0 == ffFoo.self)
    }

    func testRouterParamA() {
        ffRouter.shared.map("/hello/:world", toClass: ffFoo.self)
        XCTAssert(ffRouter.shared.classMatchRouter("/hello/123")?.0 == ffFoo.self)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
