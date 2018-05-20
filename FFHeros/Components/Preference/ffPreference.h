//
//  ffPreference.h
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/20.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ffPreference : NSObject

+ (instancetype __nullable)shared;
- (void)sync;
/**
 *  Override
 */
- (NSString * __nullable)configName;
- (NSDictionary * __nullable)defaultConfig;

@end
