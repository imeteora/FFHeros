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
//@property (nonatomic, assign) BOOL  isArray;
@property (nonatomic, nonnull, strong) Class mappingClass;

/**
 create a model description for deserializing the json data which returns from remote server.

 @param keyPath the key-path which client api focus on
 @param mappingClass model which would be mapping from a json object
 @return the instance of the model description 
 */
+ (instancetype _Nonnull) modelWith:(nonnull NSString *)keyPath toMappingClass:(nonnull Class)mappingClass;

/**
 find object for json object with key-path

 @param keyPath the key-path for a value
 @param responseObj the result about finding json object, the result is nullable
 @return json object data which looking by using key-path
 */
+ (id _Nullable)findObjectByKeyPath:(NSString * _Nonnull)keyPath inObject:(NSDictionary<NSString *, id> * _Nonnull)responseObj;

/**
 fetch json object from the origin json object in the interation way.

 @param obj the origin json object
 @param keyPathArray key-paths in array form
 @return json object data which looking for by using key-path
 */
+ (id _Nullable)fetchObjectIn:(NSDictionary<NSString *, id> * _Nonnull)obj keyPathArray:(NSArray<NSString *> * _Nonnull)keyPathArray;

+ (NSDictionary<NSString *, id> * _Nonnull )rebuildRouterMapping:(NSDictionary<NSString *, id> * __nonnull)routerMapping fromRouter:(NSString *)router toClass:(Class __nonnull)cls;

@end
