//
//	ffCharacterModelResult.m
//
//	Create by 德伦 朱 on 16/5/2018
//	Copyright © 2018. All rights reserved.
//

#import "ffCharacterModelResult.h"

@implementation ffCharacterModelResult
+ (NSString *)aliasPropertyName:(NSString *)propertyName {
    return @{@"id": @"idField",
             @"descField": @"Description"
             }[propertyName];
}

+ (Class)classForPropertyName:(NSString *)propertyName {
    return @{@"urls": [ffCharacterModelUrl class],
             @"thumbnail": [ffCharacterModelThumbnail class],
             @"comics": [ffCharacterModelCategoryList class],
             @"events": [ffCharacterModelCategoryList class],
             @"series": [ffCharacterModelCategoryList class],
             @"stories": [ffCharacterModelCategoryList class],
             }[propertyName];
}

@end
