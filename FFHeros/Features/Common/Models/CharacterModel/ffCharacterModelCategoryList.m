//
//	ffCharacterModelComic.m
//
//	Create by 德伦 朱 on 16/5/2018
//	Copyright © 2018. All rights reserved.
// 



#import "ffCharacterModelCategoryList.h"

@implementation ffCharacterModelCategoryList

+ (Class)classForPropertyName:(NSString *)propertyName {
    return @{@"items": [ffCharacterSummaryModel class]}[propertyName];
}

@end
