//
//  ffRouter.m
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/19.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffRouterManager.h"

static NSString * const kInvalidNodeKeyPath = @".";
static NSString * const kSpecialNodeKeyPath = @"-";

@interface ffRouterNode : NSObject
@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic) id ruby;
@property (nonatomic, weak) ffRouterNode * parentNode;
@property (nonatomic, strong) NSMutableArray<ffRouterNode *> *childNotes;
@end

@implementation ffRouterNode
- (instancetype)init {
    if (self = [super init]) {
        _keyPath = kInvalidNodeKeyPath;
        _ruby = nil;
        _parentNode = nil;
        _childNotes = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    _keyPath = kInvalidNodeKeyPath;
    _ruby = nil;
    _parentNode = nil;
    if ([_childNotes count]) {
        [_childNotes removeAllObjects];
    }
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

- (ffRouterNode * _Nullable)childNodeDeeplyWithKeyPath:(NSArray<NSString *> * __nonnull)keyPath {
    NSString * const key = keyPath[0];
    ffRouterNode *node = [self childNodeWith:key];
    if (node == nil) {
        return node;
    }
    if ([keyPath count] == 1) {
        return node;
    }

    NSArray<NSString *> *tailKeyPath = [keyPath subarrayWithRange:NSMakeRange(1, [keyPath count] - 1)];
    return [node childNodeDeeplyWithKeyPath:tailKeyPath];
}


- (ffRouterNode * _Nullable)findRouterNodeWithKeyPath:(NSString *)keyPath
{
    NSArray<NSString *> *allKeyPaths = [keyPath componentsSeparatedByString:@"/"];
    NSString *key = allKeyPaths[0];

    ffRouterNode *subNode = [self childNodeWith:key];
    if (subNode == nil) {
        return subNode;
    }

    if ([allKeyPaths count] == 1) {
        return subNode;
    }

    NSArray<NSString *> *tailKeyPaths = [allKeyPaths subarrayWithRange:NSMakeRange(1, [allKeyPaths count] - 1)];
    return [subNode childNodeDeeplyWithKeyPath:tailKeyPaths];
}

- (void)buildKeyPath:(NSArray<NSString *> * __nonnull)keyPath forObject:(id __nonnull)obj {
    NSString * key = keyPath[0];

    ffRouterNode *node = [self childNodeWith:key];
    if (node == nil) {
        node = [ffRouterNode new];
        node.keyPath = key;
        node.parentNode = self;
        [self.childNotes addObject:node];

        if ([keyPath count] == 1) {
            node.ruby = obj;
        } else {
            NSArray<NSString *> *tailKeyPath = [keyPath subarrayWithRange:NSMakeRange(1, [keyPath count] - 1)];
            [node buildKeyPath:tailKeyPath forObject:obj];
        }
    } else {
        if ([keyPath count] == 1) {
            /// !!! overwrite could be happend here !!!
            node.ruby = obj;
        } else {
            NSArray<NSString *> *tailKeyPath = [keyPath subarrayWithRange:NSMakeRange(1, [keyPath count] - 1)];
            [node buildKeyPath:tailKeyPath forObject:obj];
        }
    }
}

#pragma mark - private helpers
- (BOOL)_isNum:(NSString * _Nonnull)val {
    NSScanner *scanner = [NSScanner scannerWithString:val];
    int32_t d;
    return [scanner scanInt:&d] && [scanner isAtEnd];
}

@end


@interface ffRouterManager ()
@property (nonatomic, strong) ffRouterNode *root;
@end

@implementation ffRouterManager

+ (ffRouterManager *)shared {
    static ffRouterManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ffRouterManager alloc] init];
        _instance.root = [[ffRouterNode alloc] init];
    });
    return _instance;
}

- (void)map:(NSString *)router toClass:(Class)vcClass {
    [ffRouterManager rebuildRouterMapping:_root fromRouter:router toClass:vcClass];
}

- (id _Nullable)classMatchRouter:(NSString *)router {
    ffRouterNode *node = [_root findRouterNodeWithKeyPath:router];
    return node.ruby;
}

+ (void)rebuildRouterMapping:(ffRouterNode *__nonnull)root fromRouter:(NSString *)router toClass:(Class __nonnull)cls {
    NSArray<NSString *> *keyPath = [router componentsSeparatedByString:@"/"];
    [root buildKeyPath:keyPath forObject:cls];
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
