//
//	ffCharacterModelResult.m
//
//	Create by 德伦 朱 on 16/5/2018
//	Copyright © 2018. All rights reserved.
//

#import "ffCharacterModel.h"

@implementation ffCharacterModel
+ (NSString *)gt_aliasPropertyName:(NSString *)propertyName {
    return @{@"id": @"idField",
             @"description": @"descField"
             }[propertyName];
}

+ (Class)gt_classForPropertyName:(NSString *)propertyName {
    return @{@"urls": [ffUrlModel class],
             @"thumbnail": [ffImageModel class],
             @"comics": [ffCategoryListModel class],
             @"events": [ffCategoryListModel class],
             @"series": [ffCategoryListModel class],
             @"stories": [ffCategoryListModel class],
             }[propertyName];
}

@end
