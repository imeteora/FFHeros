//
//  FFCode_Model.m
//  FFHerosTests
//
//  Created by ZhuDelun on 2018/5/16.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ffFooModel.h"
#import "ffAPIModelDescription.h"

@interface FFCode_Model : XCTestCase
@property (nonatomic, strong) NSDictionary *json;
@end

@implementation FFCode_Model

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.json = @{@"id": @"1",
                  @"name": @"Jason",
                  @"description": @"I am Jason",
                  @"items": @[@{@"name": @"Michael"}, @{@"name": @"Alex"}],
                  @"selected": @{@"name": @"Michael"}
                  };
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testModelReflectAlias {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    ffFooModel *foo = [[ffFooModel alloc] initWithDictionary:self.json];
    XCTAssert([foo.idField isEqualToString:@"1"]);
}

- (void)testFetchValueInJsonObjectWithKeyPath {
    id value = [ffAPIModelDescription findObjectByKeyPath:@"/selected/name" inObject:self.json];
    XCTAssert(value != nil && [value isKindOfClass:[NSString class]] && [value isEqualToString:@"Michael"]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
