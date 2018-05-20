//
//  ffFavouriteItemModel.m
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/20.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffFavouriteItemModel.h"

@implementation ffFavouriteItemModel
+ (NSString *)gt_aliasPropertyName:(NSString *)propertyName {
    return @{@"id": @"cid",
             @"description": @"descField"
             }[propertyName];
}
@end
