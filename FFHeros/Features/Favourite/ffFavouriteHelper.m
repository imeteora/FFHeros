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
        [_instance load];
    });
    return _instance;
}

- (NSString *)_configName {
    return @"com.farfetch.fav";
}

- (void)load {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:[self _configName]];
    if (data == nil) {
        _favDict = [@{} mutableCopy];
        [self save];
        data = [NSKeyedArchiver archivedDataWithRootObject:_favDict];
    }
    _favDict = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
}

- (void)save {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_favDict];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:[self _configName]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableDictionary<NSNumber *,id> *)favDict {
    if (NOT _favDict) {
        [self load];
    }
    return _favDict;
}

- (void)addFavourite:(NSDictionary *)obj asCharacter:(int64_t)cid {
    [self.favDict setObject:obj forKey:@(cid)];
}

- (void)removeFavouriteWithCid:(int64_t)cid {
    if ([self.favDict.allKeys containsObject:@(cid)]) {
        [self.favDict removeObjectForKey:@(cid)];
    }
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

- (BOOL)favouriteStatusWithCid:(int64_t)cid {
    id anyInfo = [self favouriteForCID:cid];
    return (anyInfo != nil);
}

@end
