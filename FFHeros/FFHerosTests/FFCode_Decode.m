//
//  FFCode_Decode.m
//  FFHerosTests
//
//  Created by Zhu Delun on 2018/5/15.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DESUtils.h"
#import "ffApiSignHelper.h"

@interface FFCode_Decode : XCTestCase

@end

@implementation FFCode_Decode

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMD5 {
    NSString * md5_str = [DESUtils MD5:@"1abcd1234"];
    XCTAssert([md5_str isEqualToString:@"ffd275c5130566a2916217b101f26150"]);
}

- (void)testSignQuery {
    NSString *md5_str = [ffApiSignHelper signQueryFrom:@[@"1", @"abcd", @"1234"] withCombineComponent:@""];
    XCTAssert([md5_str isEqualToString:@"ffd275c5130566a2916217b101f26150"]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
