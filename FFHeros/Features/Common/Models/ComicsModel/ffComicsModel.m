//
//	ffComicsModel.m
//
//	Create by 德伦 朱 on 17/5/2018
//	Copyright © 2018. All rights reserved.
//


#import "ffComicsModel.h"

@implementation ffComicsModel

+ (NSString *)aliasPropertyName:(NSString *)propertyName {
    return @{@"id": @"idField",
             @"description": @"descriptionField",
             }[propertyName];
}

+ (Class)classForPropertyName:(NSString *)propertyName {
    return @{@"events": [ffCategoryListModel class],
             @"images": [ffImageModel class],
             @"prices": [ffPriceModel class],
             @"series": [ffSummaryModel class],
             @"characters": [ffCategoryListModel class],
             @"stories": [ffCategoryListModel class],
             @"creators": [ffCategoryListModel class],
             @"textObjects": [ffTextObjectModel class],
             @"thumbnail": [ffImageModel class],
             @"urls": [ffUrlModel class],
             @"dates": [ffDateModel class],
             @"collectedIssues": [ffSummaryModel class],
             @"collections": [ffSummaryModel class],
             @"variants": [ffSummaryModel class],
             }[propertyName];
}

@end
