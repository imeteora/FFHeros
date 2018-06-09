//
//  FFRouterTests.swift
//  FFRouterTests
//
//  Created by ZhuDelun on 2018/5/23.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

import XCTest
@testable import FFRouter
@testable import FFUtils

class ffFoo {
    var hello: String = "world"
}

class ffFooViewController: UIViewController {
    public override func setUpWith(_ param: [String : String]!, userInfo: AnyObject?) -> Bool {
        print("param: " + param.description)
        return true
    }
}

class FFModule_RouterTests: XCTestCase {
    private let urlstr: String = "http://marvel.com/comics/characters/1017100/a-bomb_has?utm_campaign=apiRef&utm_source=aaee6fa40625a68298d42a9bb9dcd09d"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        ffRouter.shared.map("/hello/world", toClass: ffFoo.self)
        ffRouter.shared.map("/hello/:world", toClass: ffFoo.self)
        ffRouter.shared.map("/hello/:world/guy/:name", toClass: ffFoo.self)
        ffRouter.shared.map("/hello/:world/user/:id", toClass: ffFoo.self)
        ffRouter.shared.map("/foo/:param1/:param2", toClass: ffFooViewController.self)
        ffRouter.shared.map("/browser", toClass: ffFooViewController.self)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testUIViewController() {
        let vc: UIViewController? = UIViewController.viewController("/foo/123/456", withParameter: ["hello": "world"], userInfo: nil)!
        XCTAssert(vc != nil)
    }

    func testProcessURL() {
        XCTAssert(ffRouter.shared.processUrl(urlstr, animated: true))
    }

    func testMatchHost() {
        var result: Bool = URLUtils.matchString("*.marvel.com", withSource:"marvel.com", separatedBy:".")
        XCTAssert(result == true)

        result = URLUtils.matchString("*.marvel.com", withSource:"www.marvel.com", separatedBy:".")
        XCTAssert(result == true)

        result = URLUtils.matchString("marvel.com", withSource:"www.marvel.com", separatedBy:".")
        XCTAssert(result == false)
    }
    
    func testRouterNormal() {
        XCTAssert(ffRouter.shared.classMatchRouter("/hello/world")?.0 == ffFoo.self)
    }

    func testRouterParamA() {
        XCTAssert(ffRouter.shared.classMatchRouter("/hello/123")?.0 == ffFoo.self)
    }

    func testRouterParamB() {
        var result: ffRouter.MatchResultType?

        result = ffRouter.shared.classMatchRouter("/hello/123")
        XCTAssert(result?.0 == ffFoo.self)

        result = ffRouter.shared.classMatchRouter("/hello/123/guy")
        XCTAssert(result?.0 == nil)

        result = ffRouter.shared.classMatchRouter("/hello/123/guy/456")
        print(String(describing: result?.1))
        XCTAssert(result?.0 == ffFoo.self)

        result = ffRouter.shared.classMatchRouter("/hello/234/user/999")
        print(String(describing: result?.1))
        XCTAssert(result?.0 == ffFoo.self)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
