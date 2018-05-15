//
//  ffAPIRequest.h
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/15.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ffAPIConfig;

@interface ffAPIRequest : NSObject

- (instancetype)initWithConfig:(ffAPIConfig *)config;

- (void)requestAsync;
- (void)requestSync;

@end
