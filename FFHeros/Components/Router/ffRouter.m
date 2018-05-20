//
//  ffRouter.m
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/19.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffRouter.h"

@interface ffRouterNode : NSObject
@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic) id ruby;
@property (nonatomic, strong) NSMutableArray<ffRouterNode *> *childNotes;
@end

@implementation ffRouterNode
- (instancetype)init {
    if (self = [super init]) {
        _childNotes = [[NSMutableArray alloc] init];
    }
    return self;
}

// just find node with key 'component' in current children nodes.
- (ffRouterNode * _Nullable)childNodeWith:(NSString *)keyPath {
    __block ffRouterNode *result = nil;
    [_childNotes enumerateObjectsUsingBlock:^(ffRouterNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.keyPath isEqualToString:keyPath]) {
            result = obj;
            *stop = YES;
        }
    }];
    return result;
}

- (ffRouterNode * _Nullable)childNodeDeeplyIn:(ffRouterNode * __nonnull)routerNode withKeyPath:(NSArray<NSString *> * __nonnull)keyPath {
    NSString * const key = keyPath[0];
    ffRouterNode *node = [self childNodeWith:key];
    if (node == nil OR [keyPath count] == 1) {
        return node;
    }

    NSArray<NSString *> *tailKeyPath = [keyPath subarrayWithRange:NSMakeRange(1, [keyPath count] - 1)];
    return [self childNodeDeeplyIn:node withKeyPath:tailKeyPath];
}


- (ffRouterNode * _Nullable)findRouterNode:(ffRouterNode *)root WithKeyPath:(NSString *)keyPath
{
    NSArray<NSString *> *allKeyPaths = [keyPath componentsSeparatedByString:@"/"];
    if ([allKeyPaths count] == 1) {
        if ([root.keyPath isEqualToString:allKeyPaths[0]]) {
            return root;
        } else {
            return nil;
        }
    }

    ffRouterNode *subNode = [self childNodeWith:allKeyPaths[0]];
    if (subNode == nil) return nil;
    NSArray<NSString *> *tailKeyPaths = [allKeyPaths subarrayWithRange:NSMakeRange(1, [allKeyPaths count] - 1)];
    return [self childNodeDeeplyIn:subNode withKeyPath:tailKeyPaths];
}

@end


@interface ffRouter ()
@property (nonatomic, strong) NSDictionary<NSString *, id> *allRouter;
@end

@implementation ffRouter

+ (ffRouter *)shared {
    static ffRouter *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ffRouter alloc] init];
    });
    return _instance;
}

- (void)map:(NSString *)router toViewController:(Class)vcClass {
    return;
}


+ (NSDictionary<NSString *, id> * _Nonnull )rebuildRouterMapping:(ffRouterNode *__nonnull)routerMappingDict fromRouter:(NSString *)router toClass:(Class __nonnull)cls {
    NSMutableDictionary<NSString *, id> *result = [routerMappingDict mutableCopy];
    if (result == nil) {
        result = [[NSMutableDictionary alloc] init];
    }

    NSArray<NSString *> *keyPaths = [router componentsSeparatedByString:@"/"];

    if ([keyPaths count] == 1) {
        result[keyPaths[0]] = cls;
        return result;
    }

    NSArray<NSString *> *tailKeyPaths = [keyPaths subarrayWithRange:NSMakeRange(1, [keyPaths count] - 1)];
    result[keyPaths[0]] = [self storeClass:cls intoRouterMapping:tailKeyPaths];
    return result;
}

+ (NSDictionary<NSString *, id> * _Nonnull)storeClass:(Class __nonnull)cls intoRouterMapping:(NSArray<NSString *> * __nonnull)keyPath {
    NSMutableDictionary<NSString *, id> *result = [[NSMutableDictionary alloc] init];
    if ([keyPath count] == 1) {
        result[keyPath[0]] = cls;
        return result;
    }
    NSArray<NSString *> *tailKeyPath = [keyPath subarrayWithRange:NSMakeRange(1, [keyPath count] - 1)];
    result[keyPath[0]] = [self storeClass:cls intoRouterMapping:tailKeyPath];
    return result;
}

@end
