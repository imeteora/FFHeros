//
//  NSObject+VLNetworkHelper.h
//  VanBuren Plan
//
//  Created by Zhu Delun on 15-4-17.
//  Copyright (c) 2015年 Gamebable Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NetworkHelper)

/**
 *  获取所有属性Key
 *
 *  @param includeSuper 是否需要包含父类属性
 *
 *  @return 所有属性Key
 */
+ (NSArray *)allPropertyKeys:(BOOL)includeSuper;

/**
 *
 */
+ (NSString*)classNameForPropertyName: (NSString*)propertyName;

/**
 *  获取指定属性类型
 *
 *  @param propertyName 属性名
 *
 *  @return 类型
 */
+ (Class)classForPropertyName:(NSString *)propertyName;

@end
