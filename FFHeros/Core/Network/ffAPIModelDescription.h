//
//  ffAPIModelDescription.h
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/15.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ffAPIModelDescription : NSObject
@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, assign) BOOL  isArray;
@property (nonatomic, strong) Class mappingClass;

+ (instancetype)modelWith:(NSString *)keyPath toMappingClass:(nonnull Class)mappingClass isArray:(BOOL)isArray;

@end
