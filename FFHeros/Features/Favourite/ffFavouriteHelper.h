//
//  ffFavouriteHelper.h
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/20.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ffPreference.h"

@interface ffFavouriteHelper : NSObject

+ (ffFavouriteHelper *)shared;

- (void)load;
- (void)save;

- (void)addFavourite:(NSDictionary *)obj asCharacter:(int64_t)cid;
- (int32_t)numberOfFavourites;
- (NSArray *)allFavourites;
- (NSDictionary<NSNumber *, id> * _Nullable)favouriteForCID:(int64_t)cid;

@end
