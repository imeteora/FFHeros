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
    API_METHOD_GET = 0,
    API_METHOD_POST,
    API_METHOD_PUT,
    API_METHOD_DELETE,
} ffAPIRequestMethod;

@interface ffAPIConfig : NSObject

@property (nonatomic, copy) NSString       *baseURL;
@property (nonatomic, assign) ffAPIRequestMethod    method;
@property (nonatomic, copy) NSDictionary<NSString *, NSString *> *params;
@property (nonatomic, strong) NSArray<ffAPIModelDescription *> *modelDescriptions;

@end
