//
//  FFCode_Router.m
//  FFHerosTests
//
//  Created by ZhuDelun on 2018/5/20.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ffFooModel.h"

@interface FFCode_Router : XCTestCase

@end

@implementation FFCode_Router

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
//    [[ffRouter shared] map:@"/hello/world" toClass:[ffFooModel class]];
//    Class cls = [[ffRouter shared] classMatchRouter:@"/hello/world"];
//    XCTAssert(cls == [ffFooModel class]);
//    Class cls1 = [[ffRouter shared] classMatchRouter:@"/hello/world/foo"];
//    XCTAssert(cls1 == Nil);
//    [[ffRouter shared] map:@"/" toClass:[ffFooModel class]];
//    Class cls2 = [[ffRouter shared] classMatchRouter:@""];
//    XCTAssert(cls2 == Nil);
    
    [[ffRouter shared] map:@"/hello/:uid/world/:mid" toClass:[ffFooModel class]];
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
