//
//  gtModelizable.m
//  VanBuren Plan
//
//  Created by Zhu Delun on 15-4-17.
//  Copyright (c) 2015年 Gamebable Studio. All rights reserved.
//

@import ObjectiveC.runtime;
#import "gtModelizable.h"
#import "NSObject+gtNetworkHelper.h"

@implementation gtModelizable

#pragma mark - Interface Method

- (instancetype)initWithDictionary:(NSDictionary *)jsonDictionary
{
    self = [super init];
    if (self) {
        @try {
            [self setValuesForKeysWithDictionary:jsonDictionary];
        }
        @catch (NSException *exception) {
            NSLog(@"%@: %@", [exception name], [exception reason]);
        }
        @finally {
        }
    }
    return self;
}

- (NSDictionary *)dictionaryWithKeyValues {
    Class superClass = class_getSuperclass(self.class);
    NSArray* allPropertiesKeys = [self.class allPropertyKeys: (superClass != gtModelizable.class)];
    
    /// 去掉value为nil的键值对的键
    NSMutableArray* keysWithoutNilValue = [NSMutableArray array];
    for (NSString* eachProperty in allPropertiesKeys) {
        id propertyValue = [self valueForKey:eachProperty];
        if (propertyValue != nil && propertyValue != [NSNull null]) {
            [keysWithoutNilValue addObject: eachProperty];
        }
    }
    
    /// all values
    NSDictionary* allKeysValues = [self dictionaryWithValuesForKeys: keysWithoutNilValue];
    
    ///
    NSMutableDictionary* retData = [NSMutableDictionary dictionaryWithDictionary:allKeysValues];
    
    for (NSString* eachProperty in keysWithoutNilValue)
    {
        id propertyValue = [self valueForKey:eachProperty];
        
        if ([[propertyValue class] isSubclassOfClass:[gtModelizable class]]) {
            gtModelizable* eachPropertyModel = (gtModelizable*)propertyValue;
            NSDictionary* eachPropertyModelData = [eachPropertyModel dictionaryWithKeyValues];
            retData[eachProperty] = eachPropertyModelData;
        }
        else if ([propertyValue isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary* newPropertyDict = [NSMutableDictionary dictionaryWithDictionary:propertyValue];
            
            NSDictionary* propertyValueDict = (NSDictionary*)propertyValue;
            for (NSString* eachSubKeys in propertyValueDict.allKeys) {
                id subValue = [propertyValueDict objectForKey:eachSubKeys];
                if ([[subValue class] isSubclassOfClass:[gtModelizable class]]) {
                    /// delete the old value
                    [newPropertyDict removeObjectForKey:eachSubKeys];
                    /// append new value;
                    newPropertyDict[eachSubKeys] = [subValue dictionaryWithKeyValues];
                }
            }
            
            retData[eachProperty] = newPropertyDict;
        }
        else if ([propertyValue isKindOfClass:[NSArray class]]) {
            NSMutableArray* newPropertyArray = [NSMutableArray arrayWithArray:propertyValue];
            
            NSArray* propertyValueArray = (NSArray*)propertyValue;
            for (id eachProperty in propertyValueArray) {
                if ([[eachProperty class] isSubclassOfClass: [gtModelizable class]]) {
                    /// reomve the old value
                    [newPropertyArray removeObject: eachProperty];
                    /// append the new value.
                    [newPropertyArray addObject: [eachProperty dictionaryWithKeyValues]];
                }
            }
            
            retData[eachProperty] = newPropertyArray;
        }
    }
    
    allKeysValues = nil;
    
    return retData;
}

- (instancetype)generateObjectForClass:(Class)targetClass
{
    NSDictionary* allKeyValuesDict = [self dictionaryWithKeyValues];
    return [[targetClass alloc] initWithDictionary: allKeyValuesDict];
}


+ (Class)classForCollectionPropertyName:(NSString *)propertyName {
    return nil;
}

#pragma mark - NSKeyValueCoding

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([value isKindOfClass:[NSArray class]]) {
        
        Class propertyItemClass = [self.class classForCollectionPropertyName:key];
        if ([propertyItemClass isSubclassOfClass:[gtModelizable class]]) {
            NSMutableArray *propertyModel = [NSMutableArray array];
            for (id propertyItem in value) {
                gtModelizable *itemModel = [[propertyItemClass alloc]initWithDictionary:propertyItem];
                [propertyModel addObject:itemModel];
            }
            value = propertyModel;
        }
        [super setValue:value forKey:key];
    }
    else if ([value isKindOfClass:[NSDictionary class]]) {
        
        Class propertyClass = [self.class classForPropertyName:key];
        if ([propertyClass isSubclassOfClass:[gtModelizable class]]) {
            gtModelizable *propertyModel = [[propertyClass alloc]initWithDictionary:value];
            value = propertyModel;
        }
        [super setValue:value forKey:key];
    }
    else {
        Class keyClass = [self.class classForPropertyName:key];
        
        Class superClass = class_getSuperclass(keyClass);
        if (superClass != [NSObject class]) {           /// 如果key的类型不是NSObject的子集，那么就直接会把value设置进去. 比如NSInteger此类的。
            [super setValue:value forKey:key];
            return;
        }
        
        NSString* keyClassName = NSStringFromClass(keyClass);
        if (!value || value == [NSNull null])
            return;
        
        if ([keyClassName isEqualToString:@"i"] || [keyClassName isEqualToString:@"l"] || [keyClassName isEqualToString:@"s"] || [keyClassName isEqualToString:@"q"])
            [super setValue:[NSNumber numberWithInteger:[value integerValue]] forKey: key];
        else if ([keyClassName isEqualToString:@"I"] || [keyClassName isEqualToString:@"L"] || [keyClassName isEqualToString:@"S"] || [keyClassName isEqualToString:@"Q"])
            [super setValue:[NSNumber numberWithLong: [value longValue]] forKey:key];
        else if ([keyClassName isEqualToString:@"f"] || [keyClassName isEqualToString:@"d"])
            [super setValue:[NSNumber numberWithFloat:[value floatValue]] forKey:key];
        else if ([keyClassName isEqualToString:@"c"])
            [super setValue:[NSNumber numberWithChar:[value charValue]] forKey:key];
        else if ([keyClassName isEqualToString:@"B"])
            [super setValue:[NSNumber numberWithBool:[value boolValue]] forKey:key];
        else if ([keyClassName isEqualToString:@"NSNumber"])
            [super setValue:value forKeyPath:key];
        else if ([keyClassName isEqualToString:@"NSString"])
            [super setValue:[NSString stringWithFormat:@"%@", value] forKey:key];
        else
            [super setValue:value forKey:key];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
#ifdef DEBUG
    NSLog(@"[warning] !!!!!!--%@--Undefined--key[%@]--!!!!!!",NSStringFromClass(self.class),key);
#endif
}


@end

@implementation gtModelizable (kvCoding)

- (id)keyValueFor:(NSString *)property {
    NSDictionary *all = [self dictionaryWithKeyValues];
    if (NO == [all.allKeys containsObject:property]) {
        return nil;
    }
    return all[property];
}

@end


@implementation NSArray (gtNetworkModel)

- (NSArray *)keyValueArray {
    if ([self count] == 0) {
        return @[];
    }
    
    NSMutableArray<NSDictionary*>* ret = [[NSMutableArray alloc] initWithCapacity:[self count]];
    [self enumerateObjectsUsingBlock:^(gtModelizable*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *objDict = [obj dictionaryWithKeyValues];
        [ret addObject:objDict];
    }];
    
    return ret;
}

@end
