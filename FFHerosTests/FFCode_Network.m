//
//  FFCode_Network.m
//  FFHerosTests
//
//  Created by Zhu Delun on 2018/5/15.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ffFetchCharacterInfoApi.h"

@interface FFCode_Network : XCTestCase

@end

@implementation FFCode_Network

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCheckQuery {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    XCTestExpectation *apiExpectation = [[XCTestExpectation alloc] initWithDescription:@"test http request"];
    __block BOOL bSuccess = NO;
    ffFetchCharacterInfoApi *api = [[ffFetchCharacterInfoApi alloc] init];
    [api requestAfterComplete:^(NSDictionary * _Nonnull result) {
        bSuccess = YES;
        [apiExpectation fulfill];
    } ifError:^(NSError * _Nonnull error, id _Nullable result) {
        bSuccess = NO;
        [apiExpectation fulfill];
    }];

    [self waitForExpectations:@[apiExpectation] timeout:35];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
