//
//  gtModelizable.h
//  VanBuren Plan
//
//  Created by Zhu Delun on 15-4-17.
//  Copyright (c) 2015年 Gamebable Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface gtModelizable : NSObject

/**
 *  通过JSON字典初始化模型对象
 *
 *  @param jsonDictionary JSON字典
 *
 *  @return 模型对象
 */
- (instancetype)initWithDictionary:(NSDictionary *)jsonDictionary;

/**
 *  获取指定集合型属性的Item类
 *  ps.默认返回nil，子类需自行重载处理
 *
 *  @param propertyName 属性名称
 *
 *  @return item类
 */
+ (Class)classForCollectionPropertyName:(NSString *)propertyName;


/**
 *  获得当前类型的属性键值对
 *
 *  @return 当前实例的键值对
 */
- (NSDictionary*)dictionaryWithKeyValues;

/**
 *  从当前类型实例中实例化一个新的目标对象。
 *
 *  @param targetClass 目标对象类型
 *
 *  @return 返回转换好的目标实例
 */
- (instancetype)generateObjectForClass: (Class)targetClass;

/**
 *  扩展字段，既能够方便的实现业务功能，也不会污染业务model
 */
@property(nonatomic,assign) NSInteger  extention;


@end

@interface gtModelizable (kvCoding)
- (id) keyValueFor: (NSString*)property;
@end

@interface NSArray (gtNetworkModel)
- (NSArray*)keyValueArray;
@end
