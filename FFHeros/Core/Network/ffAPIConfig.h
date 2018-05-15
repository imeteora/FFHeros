//
//  ffAPIConfig.h
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/15.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ffAPIModelDescription.h"

typedef enum : NSUInteger {
    FFApiRequestMethodGET = 0,
    FFApiRequestMethodPOST,
    FFApiRequestMethodPUT,
    FFApiRequestMethodDELETE,
} ffAPIRequestMethod;

@interface ffAPIConfig : NSObject

@property (nonatomic, nonnull, copy)  NSString *baseURL;
@property (nonatomic, assign) ffAPIRequestMethod method;
@property (nonatomic, assign) NSTimeInterval timeout;
@property (nonatomic, nullable, strong) NSDictionary<NSString *, NSString *> *params;
@property (nonatomic, nullable, strong) NSDictionary<NSString *, NSString *> *extHttpHeader;
@property (nonatomic, nullable, strong) NSArray<ffAPIModelDescription *> *modelDescriptions;

- (nullable NSString *)authSignStringOfRequest;
- (nullable NSDictionary<NSString *, NSString *> *)authSignDictOfRequest;

@end
