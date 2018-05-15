//
//  ffAPIModelDescription.h
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/15.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ffAPIModelDescription : NSObject
@property (nonatomic, nonnull, copy) NSString *keyPath;
@property (nonatomic, assign) BOOL  isArray;
@property (nonatomic, nonnull, strong) Class mappingClass;

+ (_Nonnull instancetype) modelWith:(nonnull NSString *)keyPath toMappingClass:(nonnull Class)mappingClass isArray:(BOOL)isArray;

@end
