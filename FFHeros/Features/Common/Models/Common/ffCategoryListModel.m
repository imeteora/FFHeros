//
//	ffCharacterModelComic.m
//
//	Create by 德伦 朱 on 16/5/2018
//	Copyright © 2018. All rights reserved.
// 



#import "ffCategoryListModel.h"

@implementation ffCategoryListModel

+ (Class)gt_classForPropertyName:(NSString *)propertyName {
    return @{@"items": [ffSummaryModel class]}[propertyName];
}

@end
