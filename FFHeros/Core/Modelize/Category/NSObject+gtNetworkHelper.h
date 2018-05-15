//
//  NSObject+ReflectHelper.h
//  VanBuren Plan
//
//  Created by Zhu Delun on 15-4-17.
//  Copyright (c) 2015年 Gamebable Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ReflectHelper)

/**
 *  获取所有属性Key
 *
 *  @param includeSuper 是否需要包含父类属性
 *
 *  @return 所有属性Key
 */
+ (NSArray *)obj_allPropertyKeys:(BOOL)includeSuper;

/**
 *
 */
+ (NSString*)obj_classNameForPropertyName: (NSString*)propertyName;

/**
 *  获取指定属性类型
 *
 *  @param propertyName 属性名
 *
 *  @return 类型
 */
+ (Class)obj_classForPropertyName:(NSString *)propertyName;

@end
