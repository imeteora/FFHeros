//
//  FFModule_RouterUITest.swift
//  FFRouterTests
//
//  Created by ZhuDelun on 2018/5/24.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

import XCTest
@testable import FFRouter

class ffFooViewController: UIViewController {
    public override func setUpWith(_ param: [String : String]!, userInfo: AnyObject?) -> Bool {
        print("param: " + param.description)
        return true
    }
}

class FFModule_RouterUITest: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        ffRouter.shared.map("/foo/:param1/:param2", toClass: ffFooViewController.self)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let vc: UIViewController = UIViewController.viewController("/foo/123/456", userInfo: nil)!
        XCTAssert(vc != nil)
    }
    
}
