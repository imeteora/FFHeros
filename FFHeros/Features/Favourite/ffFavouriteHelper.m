//
//  ffFavouriteHelper.m
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/20.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffFavouriteHelper.h"

@interface ffFavouriteHelper ()
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, id> *favDict;
@end

@implementation ffFavouriteHelper

+ (ffFavouriteHelper *)shared {
    static ffFavouriteHelper *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ffFavouriteHelper alloc] init];
    });
    return _instance;
}

- (NSString *)_configName {
    return @"com.farfetch.fav";
}

- (void)load {
    self.favDict = [[NSUserDefaults standardUserDefaults] valueForKey:[self _configName]];
    if (self.favDict == nil) {
        self.favDict = [[NSMutableDictionary alloc] init];
        [self save];
    }
}

- (NSMutableDictionary<NSNumber *,id> *)favDict {
    if (NOT _favDict) {
        [self load];
    }
    return _favDict;
}

- (void)save {
    [[NSUserDefaults standardUserDefaults] setValue:self.favDict forKey:[self _configName]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)addFavourite:(NSDictionary *)obj asCharacter:(int64_t)cid {
    [self.favDict setObject:obj forKey:@(cid)];
}

- (int32_t)numberOfFavourites {
    return (int32_t)[self.favDict.allKeys count];
}

- (NSArray *)allFavourites {
    return [self.favDict allValues];
}

- (NSDictionary<NSNumber *, id> * _Nullable)favouriteForCID:(int64_t)cid {
    if ([[self.favDict allKeys] containsObject:@(cid)]) {
        return self.favDict[@(cid)];
    }
    return nil;
}
@end
