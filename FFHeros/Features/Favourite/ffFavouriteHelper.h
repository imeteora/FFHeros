//
//  ffFavouriteHelper.h
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/20.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ffFavouriteItemModel.h"

@interface ffFavouriteHelper : NSObject

+ (ffFavouriteHelper *)shared;

- (void)load;
- (void)save;

- (void)addFavourite:(NSDictionary *)obj asCharacter:(int64_t)cid;
- (void)removeFavouriteWithCid:(int64_t)cid;
- (int32_t)numberOfFavourites;
- (NSArray *)allFavourites;
- (NSDictionary<NSNumber *, id> * _Nullable)favouriteForCID:(int64_t)cid;
- (BOOL)favouriteStatusWithCid:(int64_t)cid;

@end
